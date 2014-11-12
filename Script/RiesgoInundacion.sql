-- Primero que todo, nos traemos el shape de "riesgoInundaciones" a la tabla "riesginundacionrtm05"

-- Luego, arreglamos las geometrías de la tabla "riesginundacionrtm05"

SELECT NOMBRE, geom.STIsValid()
FROM riesginundacionrtm05;

UPDATE riesginundacionrtm05
SET geom = geom.MakeValid();

UPDATE riesginundacionrtm05
SET geom = geom.STUnion(geom.STStartPoint());

UPDATE riesginundacionrtm05
SET geom = geom.STBuffer(0.00001).STBuffer(-0.00001);

SELECT DISTINCT NOMBRE FROM riesginundacionrtm05
select geom from riesginundacionrtm05

-- Inserto en la tabla de "riesgo_inun", los datos del shape de "riesgo_inun"

CREATE TABLE riesgo_inun(
nombre VARCHAR(100),
tipo VARCHAR(100),
clasificacion VARCHAR(100),
longitud FLOAT(3) DEFAULT NULL,
geom geometry
);

-- Se insertan los datos de la tabla temporal a la tabla creada para el proyecto.
INSERT INTO riesgo_inun(nombre, tipo, clasificacion, geom)
SELECT NOMBRE, TIPO, CLASIFICAC, geom
FROM riesginundacionrtm05;

-- Ahora calculo la longitud de cada río de la tabla "riesgo_inun"

UPDATE riesgo_inun
SET longitud = geom.STLength();

-- Select * from riesginundacionrtm05
-- Select * from riesgo_inun
-- drop table riesgo_inun

-- declaro una geomTotal que guarda la union de una geometría de rio con igual (NOMBRE, TIPO, CLASIFICAC)
-- meto en tabla_distinta un distinct de (NOMBRE, TIPO, CLASIFICAC) de tabla_original
	-- for cada tupla en tabla_distinta
		-- for cada tupla en tabla_original
			-- if la tupla en tabla_original = tupla en tabla_distinta
				-- una la geometria con geomTotal
			-- end if
		-- end for
		-- limpie geomTotal
	-- end for