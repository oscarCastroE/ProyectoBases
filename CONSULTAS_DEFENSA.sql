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