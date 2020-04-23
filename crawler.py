# -*- coding: utf-8 -*-

from declarations import *
from db.db import Db
from db.connection import *
import wikitextparser as wtp
import wikipedia
from datetime import date
from bs4 import BeautifulSoup
import re

p = re.compile(r'[\r?\n]')

def conecta():
	#print(config)
	db = Db(config)
	#print(db.config);
	conn = db.connect()
	#print(db)
	return db

db = conecta()

def get_competicoes():
	for competicao in competicoes:
		competicao['id_categoria'] = db.insert_if_not_exists("temp_categoria", {"nome": competicao['tipo']}, {"nome": competicao['tipo']})
		data = {"nome": competicao['campeonato'], 'categoria_id':competicao['id_categoria']}
		
		competicao['id_competicao'] = db.insert_if_not_exists("temp_competicao", data, {"nome": competicao['campeonato']})

		ano_inicial = int(competicao['start_year'])
		if "end_year" in competicao:
			ano_final = int(competicao['end_year'])
		else:
			ano_final = date.today().year
		ano = ano_inicial
		while ano <= ano_final:
			try:
				get_competicao_pt(competicao, ano)
			except Exception as e:
				print(e)
				raise
			else:
				pass
			finally:
				ano += 1

def get_competicao_pt(competicao, ano):
	#for prep in preposicoes:
		url = temporada['pt'] + ' ' + competicao['prep'] + ' ' + competicao['pt'].replace('_',' ') + ' de ' + str(ano)
		try:
			wikipedia.set_lang("pt")
			pTemporada = wikipedia.page(url)
		except:
			print("Página ",url," não existe")
		else:
			parse_temporada_pt(competicao, ano, pTemporada)
		finally:
			pass

def parse_temporada_pt(competicao, ano, page):
	data = {
		'competicao_id': competicao['id_competicao'],
		'ano': ano
	};
	id_temporada = db.insert_if_not_exists('temp_temporada',data,data)
	soup = BeautifulSoup(page.html(),'lxml')
	parse_temporada_pontos_pt(competicao, ano, soup, id_temporada)
	#secResultados = page.section("Resultados")

def checkTitleLine(tr):
	ret = False;
	if (tr.th != None):
		attrs = tr.th.attrs
		if "colspan" in attrs:
			if int(attrs['colspan'])>1:
				ret = True

	return ret

def parse_temporada_pontos_pt(competicao, ano, soup, id_temporada):
	
	h2 = soup.find(id="Sistema_de_Pontuação")
	if h2 == None:
		return False;
	
	table = h2.parent.next_sibling
	#print(re.sub(p,'',repr(table)).strip());
	while not "table" in repr(table):
		table = table.next_sibling
	
	posicoes = [];
	pontos = [];

	for i, tr in enumerate(table.find_all('tr')):
		if checkTitleLine(tr):
			i-=1
			continue

		
		if i==0:
			for th in tr.find_all('th'):
				for j in th.contents:
					if j == None:
						continue;				
					j=str(j);
					if j.replace('<b>','').replace('</b>','').strip() !="":
						if not "posição" in j.strip().lower():
							posicoes.append(j.strip().replace('<b>','').replace('</b>','').replace('º','').replace('.','').replace(':',''))
			for td in tr.find_all('td'):
				for j in td.contents:
					if j == None:
						continue;

					j=str(j);
					if j.replace('<b>','').replace('</b>','').strip() !="":
						if not "posição" in j.strip().lower():
							posicoes.append(j.strip().replace('<b>','').replace('</b>','').replace('º','').replace('.','').replace(':',''))
		if i==1:
			for th in tr.find_all('th'):
				for j in th.contents:
					if j == None:
						continue;
					j=str(j);
					if j.replace('<b>','').replace('</b>','').strip() !="":
						if not "pontos" in j.strip().lower():
							pontos.append(j.replace('<b>','').replace('</b>','').strip())
			for td in tr.find_all('td'):
				for j in td.contents:
					if j == None:
						continue;
					j=str(j);
					if j.replace('<b>','').replace('</b>','').strip() !="":
						if not "pontos" in j.strip().lower():
							pontos.append(j.replace('<b>','').replace('</b>','').strip())




	lista = (list(zip(posicoes, pontos)))
	for i in lista:
		if (not "VR" in i[0]):
			conditions = {
				'temporada_id': id_temporada,
				'posicao': i[0]
			};
			data = conditions.copy()
			data['pontos'] = i[1]
			if not db.insert_if_not_exists('temp_pontuacao_temporada',data,conditions):
				print("Erro ao incluir Pontuação")
				return False

	return True
	#secPontuacao = page.section("Sistema de Pontuação")
	#print(secPontuacao)



get_competicoes()