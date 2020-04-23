use id13348972_racing;
CREATE TABLE temp_categoria(
	id integer AUTO_INCREMENT, 
	nome varchar(255) ,
	constraint pk_temp_categoria primary key(id)
);

CREATE TABLE temp_competicao(
	id integer AUTO_INCREMENT, 
	categoria_id int ,
	nome varchar(255) ,
	constraint pk_temp_competicao primary key(id)
);

CREATE TABLE temp_temporada(
	id integer AUTO_INCREMENT, 
	competicao_id int , 
	ano int ,
	constraint pk_temp_temporada primary key(id)
);

CREATE TABLE temp_pontuacao_temporada(
	id integer AUTO_INCREMENT,
	temporada_id int ,
	posicao int ,
	pontos int ,
	constraint pk_temp_pontuacao_temporada primary key(id)
);

CREATE TABLE temp_grande_premio(
	id integer AUTO_INCREMENT, 
	nome varchar(255) ,
	constraint pk_temp_gp primary key(id)	
);

CREATE TABLE temp_pais (
	id integer AUTO_INCREMENT, 
	nome varchar(255) ,
	constraint pk_temp_pais primary key(id)	
);

CREATE TABLE temp_circuito(
	id integer AUTO_INCREMENT, 
	pais_id int ,
	nome varchar(255) ,
	constraint pk_temp_circuito primary key(id)
);

CREATE TABLE temp_corrida(
	id integer AUTO_INCREMENT,
	ano int ,
	grande_premio_id integer ,
	circuito_id int ,
	constraint pk_temp_corrida primary key(id)
);

CREATE TABLE temp_corrida_competicao(
	id integer AUTO_INCREMENT,
	corrida_id integer,
	competicao_id int null,
	temporada_id int null,
	categoria_id int,
	constraint pk_temp_corrida_competicao primary key(id)	
);

CREATE TABLE temp_motor(
	id integer AUTO_INCREMENT,
	pais_id integer ,
	nome varchar(255) ,
	constraint pk_temp_motor primary key(id)
);

CREATE TABLE temp_construtor(
	id integer AUTO_INCREMENT,
	pais_id integer ,
	nome varchar(255) ,
	constraint pk_temp_construtor primary key(id)
);

CREATE TABLE temp_equipe(
	id integer AUTO_INCREMENT,
	pais_id integer ,
	nome varchar(255) ,
	constraint pk_temp_equipe primary key(id)
);

CREATE TABLE temp_piloto(
	id integer AUTO_INCREMENT,
	pais_id integer ,
	nome varchar(255) ,
	constraint pk_temp_piloto primary key(id)
);

CREATE table temp_resultado_corrida(
	id integer AUTO_INCREMENT,
	corrida_id int ,
	posicao int ,
	piloto_id int ,
	equipe_id int ,
	construtor_id int ,
	motor_id int ,
	constraint pk_temp_resultado_corrida primary key(id)		
);

CREATE TABLE temp_resultado_corrida_comp(
	id integer AUTO_INCREMENT,
	resultado_corrida_id int,
	corrida_competicao_id int,
	pontos int,
	constraint pk_temp_resultado_corrida_comp primary key(id)			
);

