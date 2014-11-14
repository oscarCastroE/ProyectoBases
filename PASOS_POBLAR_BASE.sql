-- Primero que todo, nos traemos el shape de "distritos" a la tabla "distritos2008crtm05"

-- Luego, arreglamos las geometrías de la tabla "distritos2008crtm05"

SELECT NDISTRITO, geom.STIsValid()
FROM distritos2008crtm05;

UPDATE distritos2008crtm05
SET geom = geom.MakeValid();

UPDATE distritos2008crtm05
SET geom = geom.STUnion(geom.STStartPoint());

UPDATE distritos2008crtm05
SET geom = geom.STBuffer(0.00001).STBuffer(-0.00001);

-- Ahora creo las tablas de "provincias", "cantones" y "distritos"

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

-- Inserto en la tabla de "distritos", los datos del shape de "distritos"

INSERT INTO distritos(cod_dis, nombre_dis)
SELECT DISTINCT CODDIST, NDISTRITO
FROM distritos2008crtm05;

DECLARE @codDist int
DECLARE @GeomComp geometry
SET @GeomComp = geometry::Parse('MULTIPOLYGON EMPTY')
DECLARE cursorCodDist CURSOR FOR SELECT cod_dis FROM distritos 
OPEN cursorCodDist 
FETCH NEXT FROM cursorCodDist INTO @codDist
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @GeomComp = @GeomComp.STUnion(d.geom)
		FROM distritos2008crtm05 d
		WHERE d.CODDIST = @codDist
		UPDATE distritos  SET geom = @GeomComp
		WHERE cod_dis = @codDist
		SET @GeomComp = geometry::Parse('MULTIPOLYGON EMPTY')
		FETCH NEXT FROM cursorCodDist INTO @codDist
	END
CLOSE cursorCodDist
DEALLOCATE cursorCodDist

-- Ahora inserto en la tabla "distritos" los datos (nacimientoT, nacimientoH, nacimientoM)
-- de la hoja de excel de "distritos".

						-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- Ahora calculo el área de los distritos y la inserto en la tabla "distritos"

UPDATE distritos 
SET area_dis = geom.STArea();

-- Ahora calculo la llave foránea de los distritos usando relaciones topológicas

						-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
						
-- Insertar el shape de "cantones" en la tabla "cantones"

-- Luego, arreglamos las geometrías de la tabla "cantones2008ctm05"

SELECT NCANTON, geom.STIsValid()
FROM cantones2008ctm05;

UPDATE cantones2008ctm05
SET geom = geom.MakeValid();

UPDATE cantones2008ctm05
SET geom = geom.STUnion(geom.STStartPoint());

UPDATE cantones2008ctm05
SET geom = geom.STBuffer(0.00001).STBuffer(-0.00001);

-- Arreglo el null de la tabla de "cantones2008ctm05"

UPDATE cantones2008ctm05
SET CODNUM = -9999
WHERE NCANTON = 'NA';

-- Inserto en la tabla de "cantones", los datos del shape de "cantones"

INSERT INTO cantones (cod_can, nombre_can, geom)
SELECT CODNUM, NCANTON, geom
FROM cantones2008ctm05;

-- Ahora calculo el área de los cantones y la inserto en la tabla "cantones"

UPDATE cantones
SET area_can = geom.STArea();

-- Insertar el shape de "provincias" en la tabla "provincias"

-- Luego, arreglamos las geometrías de la tabla "provincias2008crtm05"

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

-- Ahora calculo el área de las provincias y la inserto en la tabla "provincias"

UPDATE provincias
SET area_prov = geom.STArea();

-- Ahora, queda calcular las llaves primarias de "distritos" y "cantones" usando relaciones topológicas.
-- Ahora hay que arreglar la consulta porque el STIntersects() me devuelve varios.

DECLARE @geomDis geometry 
SET @geomDis = (SELECT geom from distritos where cod_dis = 10103)
SELECT c.nombre_can FROM cantones c WHERE c.geom.STIntersects(@geomDis) = 1;

UPDATE distritos 
SET cod_can = ( SELECT c.cod_can FROM cantones c WHERE c.geom.STIntersects(geom) = 1 );

-- Plan B es tomar el cantón con el que más interseca cada distrito. 

DECLARE @interTable TABLE (cod_can int, intersection geometry, area float)
DECLARE @codDist int 
DECLARE @geomDist geometry
DECLARE cursorDist CURSOR FOR SELECT cod_dis, geom FROM distritos 
OPEN cursorDist 
FETCH NEXT FROM cursorDist INTO @codDist, @geomDist
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @interTable (cod_can, intersection)
		SELECT c.cod_can, @geomDist.STIntersection(c.geom) FROM cantones c WHERE @geomDist.STIntersects(c.geom) = 1 
		UPDATE @interTable
		SET area = intersection.STArea();
		UPDATE distritos 
		SET cod_can = ( SELECT c.cod_can FROM @interTable c WHERE c.area = (SELECT MAX(area) from @interTable) )
		WHERE cod_dis = @codDist
		DELETE FROM @interTable WHERE 1=1
		FETCH NEXT FROM cursorDist INTO @codDist, @geomDist
	END
CLOSE cursorDist
DEALLOCATE cursorDist

select * from distritos;

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

select * from cantones;

-- Ahora ya están las tablas de distritos, cantones y provincias totalmente pobladas. 

-- Empezamos entonces poblando los hospitales y clínicas. 
-- Primero creo las tablas "hospitales" y "clinicas"

CREATE TABLE area_salud(
nombre_as VARCHAR(30) PRIMARY KEY,
total_consultas FLOAT (8,1) UNSIGNED,
consultas_urgencia FLOAT (8,1) UNSIGNED,
cosultas_hora FLOAT (8,1) UNSIGNED,
consultas_dia FLOAT (8,1) UNSIGNED,
area FLOAT (8,3) UNSIGNED,
cant_ebais FLOAT (8,1) UNSIGNED,
habitantes_ebais FLOAT (8,1) UNSIGNED,
geom SDO_GEOMETRY
); 

CREATE TABLE centro_medico(
nombre VARCHAR(30) PRIMARY KEY,
nombre_as VARCHAR(30) NOT NULL,
geom SDO_GEOMETRY,
FOREIGN KEY (nombre_as) REFERENCES area_salud(nombre_as)
); 

CREATE TABLE hospital(
nombre_cm VARCHAR(30) PRIMARY KEY,
FOREIGN KEY (nombre_cm) REFERENCES centro_medico(nombre)
); 

CREATE TABLE clinica(
nombre_cm VARCHAR(30) PRIMARY KEY,
tipo VARCHAR(30), 
FOREIGN KEY (nombre_cm) REFERENCES centro_medico(nombre)
); 




