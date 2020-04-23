create database id13348972_racing;
use id13348972_racing;
CREATE TABLE categoria(
	id integer AUTO_INCREMENT, 
	nome varchar(255) not null,
	constraint pk_categoria primary key(id)
);

CREATE TABLE competicao(
	id integer AUTO_INCREMENT, 
	categoria_id int not null,
	nome varchar(255) not null,
	constraint pk_competicao primary key(id)
);
ALTER TABLE competicao ADD CONSTRAINT fk__competicao__categoria FOREIGN KEY(categoria_id) REFERENCES categoria(id);

CREATE TABLE temporada(
	id integer AUTO_INCREMENT, 
	competicao_id int not null, 
	ano int not null,
	constraint pk_temporada primary key(id)
);
ALTER TABLE temporada ADD CONSTRAINT fk__temporada__competicao FOREIGN KEY(competicao_id) REFERENCES competicao(id);

CREATE TABLE pontuacao_temporada(
	id integer AUTO_INCREMENT,
	temporada_id int not null,
	posicao int not null,
	pontos int not null,
	constraint pk_pontuacao_temporada primary key(id)
);
ALTER TABLE pontuacao_temporada ADD CONSTRAINT fk__pontuacao_temporada__temporada FOREIGN KEY(temporada_id) REFERENCES temporada(id);

CREATE TABLE grande_premio(
	id integer AUTO_INCREMENT, 
	nome varchar(255) not null,
	constraint pk_gp primary key(id)	
);

CREATE TABLE pais (
	id integer AUTO_INCREMENT, 
	nome varchar(255) not null,
	constraint pk_pais primary key(id)	
);

CREATE TABLE circuito(
	id integer AUTO_INCREMENT, 
	pais_id int not null,
	nome varchar(255) not null,
	constraint pk_circuito primary key(id)
);
ALTER TABLE circuito ADD CONSTRAINT fk__circuito__pais FOREIGN KEY(pais_id) REFERENCES pais(id);

CREATE TABLE corrida(
	id integer AUTO_INCREMENT,
	ano int not null,
	grande_premio_id integer not null,
	circuito_id int not null,
	constraint pk_corrida primary key(id)
);

ALTER TABLE corrida ADD CONSTRAINT fk__corrida__gp FOREIGN KEY(grande_premio_id) REFERENCES grande_premio(id);
ALTER TABLE corrida ADD CONSTRAINT fk__corrida__circuito FOREIGN KEY(circuito_id) REFERENCES circuito(id);

CREATE TABLE corrida_competicao(
	id integer AUTO_INCREMENT,
	corrida_id integer not null,
	competicao_id int null,
	temporada_id int null,
	categoria_id int not null,
	constraint pk_temp_corrida_competicao primary key(id)	
);
ALTER TABLE corrida_competicao ADD CONSTRAINT fk__corrida_comp__categoria FOREIGN KEY(categoria_id) REFERENCES categoria(id);
ALTER TABLE corrida_competicao ADD CONSTRAINT fk__corrida_comp__competicao FOREIGN KEY(competicao_id) REFERENCES competicao(id);
ALTER TABLE corrida_competicao ADD CONSTRAINT fk__corrida_comp__temporada FOREIGN KEY(temporada_id) REFERENCES temporada(id);

CREATE TABLE motor(
	id integer AUTO_INCREMENT,
	pais_id integer not null,
	nome varchar(255) not null,
	constraint pk_motor primary key(id)
);
ALTER TABLE motor ADD CONSTRAINT fk__motor__pais FOREIGN KEY(pais_id) REFERENCES pais(id);

CREATE TABLE construtor(
	id integer AUTO_INCREMENT,
	pais_id integer not null,
	nome varchar(255) not null,
	constraint pk_construtor primary key(id)
);
ALTER TABLE construtor ADD CONSTRAINT fk__construtor__pais FOREIGN KEY(pais_id) REFERENCES pais(id);

CREATE TABLE equipe(
	id integer AUTO_INCREMENT,
	pais_id integer not null,
	nome varchar(255) not null,
	constraint pk_equipe primary key(id)
);
ALTER TABLE equipe ADD CONSTRAINT fk__equipe__pais FOREIGN KEY(pais_id) REFERENCES pais(id);

CREATE TABLE piloto(
	id integer AUTO_INCREMENT,
	pais_id integer not null,
	nome varchar(255) not null,
	constraint pk_piloto primary key(id)
);
ALTER TABLE piloto ADD CONSTRAINT fk__piloto__pais FOREIGN KEY(pais_id) REFERENCES pais(id);

CREATE table resultado_corrida(
	id integer AUTO_INCREMENT,
	corrida_id int not null,
	posicao int not null,
	piloto_id int not null,
	equipe_id int not null,
	construtor_id int not null,
	motor_id int not null,
	constraint pk_resultado_corrida primary key(id)		
);

ALTER TABLE resultado_corrida ADD CONSTRAINT fk__resultado_corrida__corrida FOREIGN KEY(corrida_id) REFERENCES corrida(id);
ALTER TABLE resultado_corrida ADD CONSTRAINT fk__resultado_corrida__piloto FOREIGN KEY(piloto_id) REFERENCES piloto(id);
ALTER TABLE resultado_corrida ADD CONSTRAINT fk__resultado_corrida__equipe FOREIGN KEY(equipe_id) REFERENCES equipe(id);
ALTER TABLE resultado_corrida ADD CONSTRAINT fk__resultado_corrida__construtor FOREIGN KEY(construtor_id) REFERENCES construtor(id);
ALTER TABLE resultado_corrida ADD CONSTRAINT fk__resultado_corrida__motor FOREIGN KEY(motor_id) REFERENCES motor(id);

CREATE TABLE resultado_corrida_comp(
	id integer AUTO_INCREMENT,
	resultado_corrida_id int,
	corrida_competicao_id int,
	pontos int,
	constraint pk_temp_resultado_corrida_comp primary key(id)			
);

ALTER TABLE resultado_corrida_comp ADD CONSTRAINT fk__resultado_corrida_comp__resultado_corrida FOREIGN KEY(resultado_corrida_id) REFERENCES resultado_corrida(id);
ALTER TABLE resultado_corrida_comp ADD CONSTRAINT fk__resultado_corrida_comp__corrida_competicao FOREIGN KEY(corrida_competicao_id) REFERENCES corrida_competicao(id);
