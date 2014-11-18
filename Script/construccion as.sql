select * from AreaSalud_crtm05;

SELECT cod_as, geom.STIsValid()
FROM AreaSalud_crtm05;

UPDATE AreaSalud_crtm05
SET geom = geom.MakeValid();


CREATE TABLE areas_salud(
id INT IDENTITY(1,1) PRIMARY KEY,
nombre_as VARCHAR(40),
total_consultas FLOAT,
consultas_urgencia FLOAT,
consultas_hora FLOAT,
consultas_dia FLOAT,
area FLOAT,
cant_ebais FLOAT,
habitantes_ebais FLOAT,
geom geometry
); 


SET IDENTITY_INSERT dbo.areas_salud ON;

INSERT INTO areas_salud(id,nombre_as)
SELECT DISTINCT cod_as,area_salud
FROM AreaSalud_crtm05;


UPDATE
     areas_salud 
SET
	areas_salud.geom = AreaSalud_crtm05.geom,
	areas_salud.total_consultas = area_con.total_consultas,
	areas_salud.consultas_urgencia = area_con.consultas_urgencia,
	areas_salud.consultas_hora = area_con.cosultas_hora,
	areas_salud.consultas_dia = area_con.consultas_dia,
	areas_salud.cant_ebais= area_con.cant_ebais,
	areas_salud.habitantes_ebais = area_con.habitantes_ebais
FROM
     areas_salud 
INNER JOIN     
     area_con
ON     
     areas_salud.id = area_con.codigo
INNER JOIN
	AreaSalud_crtm05
ON
	areas_salud.id = AreaSalud_crtm05.cod_as;

update areas_salud
set area = geom.STArea()
     
select * from areas_salud;

