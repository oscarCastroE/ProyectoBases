-- Primero que todo, nos traemos el shape de "riesgoincendio" a la tabla "riesgoincendiocrtm05"

-- Luego, arreglamos las geometrías de la tabla "riesgoincendiocrtm05"

Select * from riesgoincendiocrtm05;

SELECT geom.STIsValid()
FROM riesgoincendiocrtm05;

UPDATE riesgoincendiocrtm05
SET geom = geom.MakeValid();

UPDATE riesgoincendiocrtm05
SET geom = geom.STUnion(geom.STStartPoint());

UPDATE riesgoincendiocrtm05
SET geom = geom.STBuffer(0.00001).STBuffer(-0.00001);

-- Ahora creo la tabla "riesgo_incen"

CREATE TABLE riesgo_incen(
messec INT NOT NULL, 
clasificacion VARCHAR(100),
riesgo VARCHAR(100),
area FLOAT(3),
geom geometry
); 

SELECT * FROM riesgo_incen;

-- Inserto en la tabla de "riesgo_incen", los datos del shape de "riesgoincendio"

INSERT INTO riesgo_incen(messec, clasificacion, riesgo, geom)
SELECT MESSEC, CLASIFICAC, RIESGO, geom
FROM riesgoincendiocrtm05;


-- Ahora calculo el área de las zonas de incendio y la inserto en la tabla "riesgo_incen"

UPDATE riesgo_incen
SET area = geom.STArea();