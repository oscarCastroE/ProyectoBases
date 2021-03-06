---------------------------- Recuperaci�n de Datos (TABLA DISTRITOS) ----------------------------

-- Primero que todo, nos traemos el shape de "distritos" a la tabla "distritos2008crtm05".
-- Luego, arreglamos las geometr�as de la tabla "distritos2008crtm05".
SELECT NDISTRITO, geom.STIsValid()
FROM distritos2008crtm05;

UPDATE distritos2008crtm05
SET geom = geom.MakeValid();

UPDATE distritos2008crtm05
SET geom = geom.STUnion(geom.STStartPoint());

UPDATE distritos2008crtm05
SET geom = geom.STBuffer(0.00001).STBuffer(-0.00001);

-- Ahora creamos las tablas de "provincias", "cantones" y "distritos".
CREATE TABLE provincias(
	cod_prov INT PRIMARY KEY,
	nombre_prov VARCHAR(100) UNIQUE NOT NULL,
	area_prov FLOAT(3) DEFAULT NULL,
	geom geometry DEFAULT NULL
);

CREATE TABLE cantones(
	cod_can INT PRIMARY KEY,
	cod_prov INT, 
	nombre_can VARCHAR(100) NOT NULL,
	area_can FLOAT(3) DEFAULT NULL,
	geom geometry DEFAULT NULL,
	FOREIGN KEY (cod_prov) REFERENCES provincias(cod_prov)
); 

CREATE TABLE distritos(
	cod_dis INT PRIMARY KEY,
	cod_can INT, 
	nombre_dis VARCHAR(100) NOT NULL,
	area_dis FLOAT(3) DEFAULT NULL,
	nacimientoT INT,
	nacimientoH INT,
	nacimientoM INT,
	geom geometry,
	FOREIGN KEY (cod_can) REFERENCES cantones(cod_can)
);

-- Contiene los datos del SHAPEFILE.
CREATE TABLE distritosSF(
	cod_dis INT PRIMARY KEY,
	cod_can INT, 
	nombre_dis VARCHAR(100) NOT NULL,
	area_dis FLOAT(3) DEFAULT NULL,
	nacimientoT INT,
	nacimientoH INT,
	nacimientoM INT,
	geom geometry,
	FOREIGN KEY (cod_can) REFERENCES cantones(cod_can)
);

-- Contiene los datos del EXCEL.
CREATE TABLE distritosEX(
	cod_dis INT PRIMARY KEY,
	cod_can INT, 
	nombre_dis VARCHAR(100) NOT NULL,
	nacimientoT INT,
	nacimientoH INT,
	nacimientoM INT,
	FOREIGN KEY (cod_can) REFERENCES cantones(cod_can)
); 

-- Inserto en la tabla de "distritosSF", los datos del shape de "distritos".
INSERT INTO distritosSF(cod_dis, nombre_dis)
SELECT DISTINCT CODDIST, NDISTRITO
FROM distritos2008crtm05;

DECLARE @codDist int
DECLARE @GeomComp geometry
SET @GeomComp = geometry::Parse('MULTIPOLYGON EMPTY')
DECLARE cursorCodDist CURSOR FOR SELECT cod_dis FROM distritosSF 
OPEN cursorCodDist 
FETCH NEXT FROM cursorCodDist INTO @codDist
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @GeomComp = @GeomComp.STUnion(d.geom)
		FROM distritos2008crtm05 d
		WHERE d.CODDIST = @codDist
		UPDATE distritosSF  SET geom = @GeomComp
		WHERE cod_dis = @codDist
		SET @GeomComp = geometry::Parse('MULTIPOLYGON EMPTY')
		FETCH NEXT FROM cursorCodDist INTO @codDist
	END
CLOSE cursorCodDist
DEALLOCATE cursorCodDist

-- Ahora calculo el �rea de los distritos y la inserto en la tabla "distritos".
UPDATE distritosSF
SET area_dis = geom.STArea();

--
-- Insertar los datos de "distrito2" desde el script distrito.
--


-- Unimos los datos de los archivos SHAPE y EXCEL en una nueva tabla.
-- Guardamos los resultados en una nueva tabla llamada "distritos".
select distritosSF.cod_dis as cod_dis,
	distritosSF.nombre_dis as nombre_dis,
	distritosEX.nacimientoT as nacimientoT,
	distritosEX.nacimientoH as nacimientoH,
	distritosEX.nacimientoM as nacimientoM,
	distritosSF.area_dis as area_dis,
	distritosSF.geom as geom
into distritosParcial
FROM
     distritosEX
RIGHT JOIN    
     distritosSF
ON     
     distritosEX.cod_dis = distritosSF.cod_dis

-- Movemos el contenido de la tabla parcial a la definitiva de "distritos".
INSERT INTO distritos(cod_dis, nombre_dis, nacimientoT, nacimientoH, nacimientoM, area_dis, geom)
SELECT *
FROM distritosParcial;

-- Eliminamos las tablas temporales.
drop table distritosSF, distritosEX, distritosParcial, distritos2008crtm05;

select * from distritos;


---------------------------- Recuperaci�n de Datos (TABLA CANTONES) ----------------------------

-- Insertar el shape de "cantones" en la tabla "cantones"
-- Luego, arreglamos las geometr�as de la tabla "cantones2008ctm05"
SELECT NCANTON, geom.STIsValid()
FROM cantones2008ctm05;

UPDATE cantones2008ctm05
SET geom = geom.MakeValid();

UPDATE cantones2008ctm05
SET geom = geom.STUnion(geom.STStartPoint());

UPDATE cantones2008ctm05
SET geom = geom.STBuffer(0.00001).STBuffer(-0.00001);

-- Arreglo el null de la tabla de "cantones2008ctm05".
UPDATE cantones2008ctm05
SET CODNUM = -9999
WHERE NCANTON = 'NA';

-- Inserto en la tabla de "cantones", los datos del shape de "cantones".
INSERT INTO cantones (cod_can, nombre_can, geom)
SELECT CODNUM, NCANTON, geom
FROM cantones2008ctm05;

-- Ahora calculo el �rea de los cantones y la inserto en la tabla "cantones".
UPDATE cantones
SET area_can = geom.STArea();


---------------------------- Recuperaci�n de Datos (TABLA PROVINCIA) ----------------------------

-- Insertar el shape de "provincias" en la tabla "provincias".
-- Luego, arreglamos las geometr�as de la tabla "provincias2008crtm05".
SELECT PROVINCIA, geom.STIsValid()
FROM provincias2008crtm05;

UPDATE provincias2008crtm05
SET geom = geom.MakeValid();

UPDATE provincias2008crtm05
SET geom = geom.STUnion(geom.STStartPoint());

UPDATE provincias2008crtm05
SET geom = geom.STBuffer(0.00001).STBuffer(-0.00001);

-- Arreglo el null de la tabla de "provincias2008crtm05"
UPDATE provincias2008crtm05
SET COD_PROV = -9999
WHERE PROVINCIA = 'NA';

-- Inserto en la tabla de "provincias", los datos del shape de "provincias"
INSERT INTO provincias (cod_prov, nombre_prov, geom)
SELECT COD_PROV, PROVINCIA, geom
FROM provincias2008crtm05;

-- Ahora calculo el �rea de las provincias y la inserto en la tabla "provincias"
UPDATE provincias
SET area_prov = geom.STArea();

---------------------------- Recuperaci�n de Datos (LLAVES FOR�NEAS) ----------------------------

-- DECLARE @geomDis geometry 
-- SET @geomDis = (SELECT geom from distritosSF where cod_dis = 10103)
-- SELECT c.nombre_can FROM cantones c WHERE c.geom.STIntersects(@geomDis) = 1;

-- UPDATE distritosSF
-- SET cod_can = ( SELECT c.cod_can FROM cantones c WHERE c.geom.STIntersects(geom) = 1 );

-- Conseguimos las llaves for�neas "cod_can" de la tabla "cantones",
-- utilizando relaciones topol�gicas.
DECLARE @interTable TABLE (cod_can int, intersection geometry, area float)
DECLARE @codDist int 
DECLARE @geomDist geometry
DECLARE cursorDist CURSOR FOR SELECT cod_dis, geom FROM distritosSF 
OPEN cursorDist 
FETCH NEXT FROM cursorDist INTO @codDist, @geomDist
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @interTable (cod_can, intersection)
		SELECT c.cod_can, @geomDist.STIntersection(c.geom) FROM cantones c WHERE @geomDist.STIntersects(c.geom) = 1 
		UPDATE @interTable
		SET area = intersection.STArea();
		UPDATE distritosSF 
		SET cod_can = ( SELECT c.cod_can FROM @interTable c WHERE c.area = (SELECT MAX(area) from @interTable) )
		WHERE cod_dis = @codDist
		DELETE FROM @interTable WHERE 1=1
		FETCH NEXT FROM cursorDist INTO @codDist, @geomDist
	END
CLOSE cursorDist
DEALLOCATE cursorDist

-- Verificamos que la llave for�nea se actualizara correctamente.
-- select * from distritosSF;

-- Conseguimos las llaves for�neas "cod_prov" de la tabla "provincias",
-- utilizando relaciones topol�gicas.
DECLARE @interTable TABLE (cod_prov int, intersection geometry, area float)
DECLARE @codCan int
DECLARE @geomCan geometry
DECLARE cursorCan CURSOR FOR SELECT cod_can, geom FROM cantones
OPEN cursorCan 
FETCH NEXT FROM cursorCan INTO @codCan, @geomCan
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @interTable (cod_prov, intersection)
		SELECT c.cod_prov, @geomCan.STIntersection(c.geom) FROM provincias c WHERE @geomCan.STIntersects(c.geom) = 1 
		UPDATE @interTable
		SET area = intersection.STArea();
		UPDATE cantones 
		SET cod_prov = ( SELECT c.cod_prov FROM @interTable c WHERE c.area = (SELECT MAX(area) from @interTable) )
		WHERE cod_can = @codCan
		DELETE FROM @interTable WHERE 1=1
		FETCH NEXT FROM cursorCan INTO @codCan, @geomCan
	END
CLOSE cursorCan
DEALLOCATE cursorCan

-- Verificamos que la llave for�nea se actualizara correctamente.
-- select * from cantones;

---------------------------- Recuperaci�n de Datos (CENTROS DE SALUD) ----------------------------

-- Primero creo las tablas "area_salud", "centro_medico", "hospitales" y "clinicas".

CREATE TABLE areas_salud(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre_as VARCHAR(30),
	total_consultas FLOAT,
	consultas_urgencia FLOAT,
	cosultas_hora FLOAT,
	consultas_dia FLOAT,
	area FLOAT,
	cant_ebais FLOAT,
	habitantes_ebais FLOAT,
	geom geometry
); 

CREATE TABLE centros_medicos(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(30),
	id_as INT,
	geom geometry,
	FOREIGN KEY (id_as) REFERENCES areas_salud(id)
); 

CREATE TABLE hospitales(
	id_cm INT PRIMARY KEY,
	FOREIGN KEY (id_cm) REFERENCES centros_medicos(id)
); 

CREATE TABLE clinicas(
	id_cm INT PRIMARY KEY,
	tipo VARCHAR(30), 
	FOREIGN KEY (id_cm) REFERENCES centros_medicos(id)
); 

-- drop table centro_inun, centro_incen, clinicas, hospitales, centros_medicos, areas_salud;

-- Ahora cargo los shape de "hospitales" y "clinicas"
select * from hospitales2008crtm05;
select distinct NOMBRE from hospitales2008crtm05;
select * from clinicas2008crtm05;
select distinct NOMBRE, TIPO, RECURSOS, PROVINCIA, CANTON, DISTRITO from clinicas2008crtm05;

-- Ahora inserto en la tabla de "centro_medico", "hospitales" y "clinicas" los datos
-- de los shape de "hospitales" y "clinicas"

-- HOSPITALES
DECLARE @idGen INT
DECLARE @idHospi INT
DECLARE @nomHospi VARCHAR(30)
DECLARE @geomHospi geometry
DECLARE cursorHospi CURSOR FOR SELECT ID, NOMBRE, geom FROM hospitales2008crtm05
OPEN cursorHospi
FETCH NEXT FROM cursorHospi INTO @idHospi, @nomHospi, @geomHospi
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO centros_medicos (nombre, geom) values (@nomHospi, @geomHospi)
		SET @idGen  = (SELECT MAX(id) FROM centros_medicos)
		INSERT INTO hospitales (id_cm) values (@idGen)
		FETCH NEXT FROM cursorHospi INTO @idHospi, @nomHospi, @geomHospi
	END
CLOSE cursorHospi
DEALLOCATE cursorHospi

select * from centros_medicos;
select * from hospitales;

-- CLINICAS
DECLARE @idGen INT
DECLARE @idClin INT
DECLARE @nomClin VARCHAR(30)
DECLARE @tipoClin VARCHAR(30)
DECLARE @geomClin geometry
DECLARE cursorClin CURSOR FOR SELECT ID, NOMBRE, TIPO, geom FROM clinicas2008crtm05
OPEN cursorClin 
FETCH NEXT FROM cursorClin INTO @idClin, @nomClin, @tipoClin, @geomClin
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO centros_medicos (nombre, geom) values (@nomClin, @geomClin)
		SET @idGen  = (SELECT MAX(id) FROM centros_medicos)
		INSERT INTO clinicas(id_cm, tipo) values (@idGen, @tipoClin)
		FETCH NEXT FROM cursorClin INTO @idClin, @nomClin, @tipoClin, @geomClin
	END
CLOSE cursorClin
DEALLOCATE cursorClin

-- select * from centros_medicos;
-- select * from clinicas;

-- Ahora queda trabajar las areas de salud y las zonas de riesgo.

-- Cargo los shape de "riesgo_incendio" y "riesgo_inundacion".
select * from riesgoincendiocrtm05;
select distinct MESSEC, CLASIFICAC, RIESGO from riesgoincendiocrtm05;
select * from riesgos_incen;

select * from riesginundacionrtm05;
select distinct NOMBRE, TIPO, CLASIFICAC from riesginundacionrtm05;
select * from riesgos_inun;

-- Valido las geometr�as de los riesgos.
UPDATE riesgoincendiocrtm05
SET geom = geom.MakeValid();

UPDATE riesgoincendiocrtm05
SET geom = geom.STUnion(geom.STStartPoint());

UPDATE riesgoincendiocrtm05
SET geom = geom.STBuffer(0.00001).STBuffer(-0.00001);

UPDATE riesginundacionrtm05
SET geom = geom.MakeValid();

UPDATE riesginundacionrtm05
SET geom = geom.STUnion(geom.STStartPoint());

UPDATE riesginundacionrtm05
SET geom = geom.STBuffer(0.00001).STBuffer(-0.00001);

-- Ahora creo las tablas de "riesgos_inun" y "riesgo_incen".
CREATE TABLE riesgos_inun(
id INT IDENTITY(1,1) PRIMARY KEY,
nombre VARCHAR(30),
tipo VARCHAR(30),
clasificacion VARCHAR(30),
longitud FLOAT,
geom geometry
); 

CREATE TABLE riesgos_incen(
id INT IDENTITY(1,1) PRIMARY KEY,
messec INT NOT NULL, 
clasificacion VARCHAR(30),
riesgo VARCHAR(30),
area FLOAT,
geom geometry
); 

CREATE TABLE centro_inun(
id_cm INT NOT NULL,
id_riesInun INT NOT NULL,
PRIMARY KEY (id_cm, id_riesInun),
FOREIGN KEY (id_cm) REFERENCES centros_medicos(id),
FOREIGN KEY (id_riesInun) REFERENCES riesgos_inun(id)
); 

CREATE TABLE centro_incen(
id_cm INT NOT NULL,
id_riesIncen INT NOT NULL,
PRIMARY KEY (id_cm, id_riesIncen),
FOREIGN KEY (id_cm) REFERENCES centros_medicos(id),
FOREIGN KEY (id_riesIncen) REFERENCES riesgos_incen(id)
);

-- drop table centro_incen, centro_inun, riesgos_inun, riesgos_incen;

-- Ahora voy a agrupar las zonas de riesgo de acuerdo a todas las caracter�sticas que no son la geometr�a.

-- INCENDIO
DECLARE @interTable TABLE (messec int, clasificac varchar(30), riesgo varchar(30))
INSERT INTO @interTable select distinct MESSEC, CLASIFICAC, RIESGO FROM riesgoincendiocrtm05

DECLARE @idGen INT
DECLARE @idCmAs INT

DECLARE @GeomComp geometry
SET @GeomComp = geometry::Parse('MULTIPOLYGON EMPTY')
DECLARE @messecInc int 
DECLARE @clasInc VARCHAR(30)
DECLARE @riesInc VARCHAR(30)
DECLARE cursorInc CURSOR FOR SELECT messec, clasificac, riesgo FROM @interTable
-- DECLARE cursorMN CURSOR FOR SELECT cm.id FROM centros_medicos cm WHERE @GeomComp.STContains(cm.geom) = 1
OPEN cursorInc 
FETCH NEXT FROM cursorInc INTO @messecInc, @clasInc, @riesInc
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @GeomComp = @GeomComp.STUnion(r.geom)
		FROM riesgoincendiocrtm05 r
		WHERE r.MESSEC = @messecInc
		AND r.CLASIFICAC = @clasInc
		AND r.RIESGO = @riesInc
		INSERT INTO riesgos_incen (messec, clasificacion, riesgo, geom) VALUES (@messecInc, @clasInc, @riesInc, @GeomComp)
		SET @idGen = (SELECT MAX(id) FROM riesgos_incen)
		DECLARE cursorMN CURSOR FOR SELECT cm.id FROM centros_medicos cm WHERE @GeomComp.STContains(cm.geom) = 1
		OPEN cursorMN
		FETCH NEXT FROM cursorMN INTO @idCmAs
		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO centro_incen values (@idCmAs, @idGen)
				FETCH NEXT FROM cursorMN INTO @idCmAs
			END
		CLOSE cursorMN
		DEALLOCATE cursorMN	
		SET @GeomComp = geometry::Parse('MULTIPOLYGON EMPTY')
		FETCH NEXT FROM cursorInc INTO @messecInc, @clasInc, @riesInc
	END
CLOSE cursorInc 
DEALLOCATE cursorInc 

select * from centros_medicos;
select * from riesgos_incen;
select * from centro_incen;

-- INUNDACI�N 

DECLARE @interTable TABLE (nombre varchar(30), tipo varchar(30), clasificac varchar(30))
INSERT INTO @interTable select distinct NOMBRE, TIPO, CLASIFICAC FROM riesginundacionrtm05

DECLARE @idGen INT
DECLARE @idCmAs INT

DECLARE @GeomComp geometry
SET @GeomComp = geometry::Parse('MULTIPOLYGON EMPTY')
DECLARE @nombreInun VARCHAR(30)
DECLARE @tipoInun VARCHAR(30)
DECLARE @clasInun VARCHAR(30)
DECLARE cursorInun CURSOR FOR SELECT nombre, tipo, clasificac FROM @interTable
OPEN cursorInun
FETCH NEXT FROM cursorInun INTO @nombreInun, @tipoInun, @clasInun
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @GeomComp = @GeomComp.STUnion(i.geom)
		FROM riesginundacionrtm05 i
		WHERE i.NOMBRE = @nombreInun
		AND i.TIPO = @tipoInun
		AND i.CLASIFICAC = @clasInun
		INSERT INTO riesgos_inun (nombre, tipo, clasificacion, geom) VALUES (@nombreInun, @tipoInun, @clasInun, @GeomComp)
		SET @idGen = (SELECT MAX(id) FROM riesgos_inun)
		DECLARE cursorMN CURSOR FOR SELECT cm.id FROM centros_medicos cm WHERE @GeomComp.STIntersects(cm.geom) = 1
		OPEN cursorMN
		FETCH NEXT FROM cursorMN INTO @idCmAs
		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO centro_inun values (@idCmAs, @idGen)
				FETCH NEXT FROM cursorMN INTO @idCmAs
			END
		CLOSE cursorMN
		DEALLOCATE cursorMN	
		SET @GeomComp = geometry::Parse('MULTIPOLYGON EMPTY')
		FETCH NEXT FROM cursorInun INTO @nombreInun, @tipoInun, @clasInun
	END
CLOSE cursorInun 
DEALLOCATE cursorInun

-- select * from centros_medicos;
-- select * from riesgos_inun;
-- select * from centro_inun;