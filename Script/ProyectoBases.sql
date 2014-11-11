CREATE TABLE provincia(
cod_prov INT PRIMARY KEY,
nombre_prov VARCHAR2(100) UNIQUE NOT NULL,
area_prov FLOAT(3) DEFAULT NULL,
hectareas_prov FLOAT(3),
geom SDO_GEOMETRY DEFAULT NULL
);

CREATE TABLE canton(
cod_can INT PRIMARY KEY,
cod_prov INT NOT NULL, 
nombre_can VARCHAR2(100) UNIQUE NOT NULL,
area_can FLOAT(3) DEFAULT NULL,
hectareas_can FLOAT(3),
geom SDO_GEOMETRY DEFAULT NULL,
FOREIGN KEY (cod_prov) REFERENCES provincia(cod_prov)
); 

CREATE TABLE distrito(
cod_dis INT PRIMARY KEY,
cod_can INT NOT NULL, 
nombre_dis VARCHAR2(100) UNIQUE NOT NULL,
area_dis FLOAT(3) DEFAULT NULL,
nacimientoT INT,
nacimientoH INT,
nacimientoM INT,
geom SDO_GEOMETRY DEFAULT NULL,
FOREIGN KEY (cod_can) REFERENCES canton(cod_can)
); 

CREATE TABLE seguro(
tipo_seguro VARCHAR2(100),
cantidad_asegurados INT,
cod_dis INT NOT NULL,
PRIMARY KEY(cod_dis, tipo_seguro)
);

CREATE TABLE region(
nombre_re VARCHAR2(100) PRIMARY KEY,
geom SDO_GEOMETRY DEFAULT NULL
);

CREATE TABLE area_salud(
nombre_as VARCHAR2(100) PRIMARY KEY,
total_consultas FLOAT(1),
consultas_urgencia FLOAT(1),
cosultas_hora FLOAT(1),
consultas_dia FLOAT(1),
area FLOAT(3) DEFAULT NULL,
cant_ebais FLOAT(1),
habitantes_ebais FLOAT (1),
geom SDO_GEOMETRY DEFAULT NULL
);

CREATE TABLE centro_medico(
nombre VARCHAR2(100) PRIMARY KEY,
nombre_as VARCHAR2(100) NOT NULL,
geom SDO_GEOMETRY DEFAULT NULL,
FOREIGN KEY (nombre_as) REFERENCES area_salud(nombre_as)
); 

CREATE TABLE hospital(
nombre_cm VARCHAR2(100) PRIMARY KEY,
FOREIGN KEY (nombre_cm) REFERENCES centro_medico(nombre)
); 

CREATE TABLE clinica(
nombre_cm VARCHAR2(100) PRIMARY KEY,
tipo VARCHAR2(100), 
FOREIGN KEY (nombre_cm) REFERENCES centro_medico(nombre)
); 

CREATE TABLE riesgo_inun(
nombre VARCHAR2(100),
tipo VARCHAR2(100),
clasificacion VARCHAR2(100),
longitud FLOAT(3) DEFAULT NULL,
geom SDO_GEOMETRY PRIMARY KEY
); 

CREATE TABLE riesgo_incen(
messec INT NOT NULL, 
clasificacion VARCHAR2(100),
riesgo VARCHAR2(100),
area FLOAT(3),
geom SDO_GEOMETRY PRIMARY KEY
); 

CREATE TABLE centro_inun(
nombre_cm VARCHAR2(100),
geom_inun SDO_GEOMETRY,
PRIMARY KEY (nombre_cm,geom_inun) ,
FOREIGN KEY (nombre_cm) REFERENCES centro_medico(nombre),
FOREIGN KEY (geom_inun) REFERENCES riesgo_inun(geom)
); 

CREATE TABLE centro_incen(
nombre_cm VARCHAR2(100),
geom_inc SDO_GEOMETRY,
PRIMARY KEY (nombre_cm,geom_inc),
FOREIGN KEY (nombre_cm) REFERENCES centro_medico(nombre),
FOREIGN KEY (geom_inc) REFERENCES riesgo_incen(geom)
);