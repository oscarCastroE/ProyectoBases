--CONSULTAS DEFENSA

---Consulta #1
--Dado un buffer a los rios determina los centros medicos afectados

select 
	ri.nombre, 
	cm.nombre ,
	ri.geom.STBuffer(1000) as ZonaInundacion
from 
	riesgos_inun ri,
	centros_medicos cm
where 
	ri.geom.STBuffer(1000).STContains(cm.geom) = 1;

---Consulta #2
--Porcentaje de una region cubierto por una zona hospitalaria dada

select 
	r.nombre_re,
	(s.AreaCubierta*100)/r.geom.STArea()  as Porcentaje
from 
	region r, 
	(
		select 
			r.id,
			sum(sa.geom.STIntersection(cm.geom.STBuffer(20000)).STArea()) as AreaCubierta
		from 
			hospitales h,
			centros_medicos cm,
			areas_salud sa,
			region r
		where	
			sa.id_region = r.id
		and 
			cm.id_as = sa.id  
		and 
			cm.id = h.id_cm
		group by 
			r.id
	) s
where r.id = s.id;

-- Consulta #3
-- Cuáles son los centros médicos no cubiertos por ningún riesgo de inundación o de incendio?
SELECT cm.nombre, asa.nombre_as, cm.geom, d.nombre_dis, c.nombre_can, p.nombre_prov, CASE WHEN cm.id in (select id_cm from hospitales) THEN 'HOSPITAL' ELSE 'CLINICA' END as TIPO
FROM centros_medicos as cm, areas_salud as asa, distritos d, cantones c, provincias p
WHERE cm.id in (SELECT id 
				FROM centros_medicos
				EXCEPT
					(SELECT distinct cm.id
					 from centros_medicos as cm, riesgos_incen as ri, riesgos_inun as ri2
					 where ri.geom.STIntersects(cm.geom) = 'TRUE' 
					 or ri2.geom.STIntersects(cm.geom) = 'TRUE'
					) 
			) 
AND cm.id_as = asa.id
AND d.geom.STContains(cm.geom) = 1 
AND c.cod_can = d.cod_can
AND p.cod_prov = c.cod_prov;

-- Consulta #4
-- seleccionar el centro de uno de los cantones con menos centros médicos
select can.geom.STCentroid() as centro, can.nombre_can as nombre_canton
from cantones can
where can.cod_can = (	
						select top 1 A.cc
						from 
							(
								select top 1 c.cod_can as cc, COUNT(distinct cm.id) as cms
								from centros_medicos as cm, cantones as c
								where cm.geom.STIntersects(c.geom) = 1 
								group by c.cod_can
								order by COUNT(distinct cm.id)
							) as A
					) 

-- Consulta #5
-- Encontrar los 4 hospitales más cercanos a una clínica en un rango de 25 Kilómetros.
-- Utiliza 'Vecinos Más Cercanos' y 'Buffer'.
-- Encontramos la geometría de la clínica que deseamos evaluar.
DECLARE @Clinica geometry
SELECT @Clinica = geom FROM
							centros_medicos
							RIGHT JOIN clinicas
							ON clinicas.id_cm = centros_medicos.id
						WHERE nombre = 'CLINICA PALMARES';

-- Creamos un buffer de búsqueda para la clínica que evaluamos.
DECLARE @BUFFER geometry
SET @BUFFER = @Clinica.STBuffer(25000)

SELECT TOP 4
	nombre,
	geom.STDistance(@Clinica) AS distancia
FROM
	centros_medicos cm
	RIGHT JOIN hospitales h
	ON h.id_cm = cm.id
WHERE geom.Filter(@BUFFER) = 1
ORDER BY
	geom.STDistance(@Clinica) ASC

-- Consulta #6
-- Porcentaje de área cubierta por un riesgo de incendio
-- dentro de un área de salud.
select 
	ri.id,
	sa.nombre_as, 
	ri.geom as ZonaEnPeligro,
	(sa.geom.STIntersection(ri.geom.STUnion(ri.geom)).STArea()*100)/sa.geom.STArea() as Porcentaje
from 
	areas_salud sa,
	riesgos_incen ri
where 
	sa.geom.STIntersection(ri.geom).STArea() > 0
order by
	ri.id
					