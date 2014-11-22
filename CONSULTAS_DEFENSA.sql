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