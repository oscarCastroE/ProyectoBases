-- CONSULTAS PARA EL AN�LISIS 

-- CONSULTA #1 (SOLO LLAVES FOR�NEAS) 
-- c�digo de distrito y cant�n al que pertenecen los distritos de nombres HOSPITAL, ALAJUELA Y PALMARES.

-- con �ndice sobre nombre_dis
CREATE NONCLUSTERED INDEX index_nd
ON distritos (nombre_dis);
DROP INDEX index_nd ON distritos;
-- normal 
select d.cod_dis, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
and d.nombre_dis = 'HOSPITAL'
or d.nombre_dis = 'ALAJUELA'
or d.nombre_dis = 'PALMARES';
-- con IN
select d.cod_dis, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
and d.nombre_dis in ('HOSPITAL', 'ALAJUELA','PALMARES');
-- con nested loop join.
select d.cod_dis, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
and d.nombre_dis = 'HOSPITAL'
or d.nombre_dis = 'ALAJUELA'
or d.nombre_dis = 'PALMARES'
OPTION (LOOP JOIN);
-- con nested merge join.
select d.cod_dis, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
and d.nombre_dis = 'HOSPITAL'
or d.nombre_dis = 'ALAJUELA'
or d.nombre_dis = 'PALMARES'
OPTION (MERGE JOIN);
-- con nested hash joins.
select d.cod_dis, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
and d.nombre_dis = 'HOSPITAL'
or d.nombre_dis = 'ALAJUELA'
or d.nombre_dis = 'PALMARES'
OPTION (HASH JOIN);
-- CONSULTA #2 (LLAVES FOR�NEAS Y RELACIONES TOPOL�GICAS)

-- cada distrito en riesgo de incendio y el cant�n al que pertenece 
select distinct d.cod_dis, d.nombre_dis, c.cod_can, c.nombre_can
from distritos d, cantones c, riesgos_incen ri
where d.cod_can = c.cod_can
and ri.geom.STIntersects(d.geom) = 1;

-- CONSULTA #3 (SOLO RELACIONES TOPOL�GICAS)
-- �reas de salud que se encuentran en riesgos de incendio alto
-- (solo relaciones topol�gicas)
select ri.id, a.nombre_as, a.id , a.geom.STIntersection(ri.geom) as geomRiesgo
from riesgos_incen as ri, areas_salud as a
where ri.riesgo = 'ALTO'
and a.geom.STIntersection(ri.geom).STArea() > 0;

-- CONSULTA 3 EMERGENCIA
-- �reas de salud afectadas por riesgos de incendio
select distinct d.id, d.nombre_as, ri.id
from areas_salud d, 
	riesgos_incen ri 
where d.geom.STIntersects(ri.geom) = 1

-- CON ESTO LIMPIA EL BUFFER Y EL CACH�
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE; 

-- CON ESTO ENCIENDE LAS ESTAD�STICAS COMO PARTE DE LOS RESULTADOS DE LA EJECUCI�N
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
