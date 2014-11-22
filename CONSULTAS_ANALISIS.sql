-- CONSULTAS PARA EL ANÁLISIS 

-- CONSULTA #1 (SOLO LLAVES FORÁNEAS) 
-- cada distrito y su cantón asociado

-- normal 
select d.cod_dis, d.nombre_dis, c.cod_can, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can;
-- con nested loop join.
select d.cod_dis, d.nombre_dis, c.cod_can, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
OPTION (LOOP JOIN);
-- con nested merge join.
select d.cod_dis, d.nombre_dis, c.cod_can, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
OPTION (MERGE JOIN);
-- con nested hash joins.
select d.cod_dis, d.nombre_dis, c.cod_can, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
OPTION (HASH JOIN);
-- 10 distritos con códigos entre 10101-10110 y el cantón al que pertenece (MODIFICADA PARA IN VS OR)
-- con IN
select d.cod_dis, d.nombre_dis, c.cod_can, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
and d.cod_dis IN (10101, 10102, 10103, 10104, 10105, 10107, 10108, 10109, 10110);
-- con OR
select d.cod_dis, d.nombre_dis, c.cod_can, c.nombre_can
from distritos d, cantones c
where d.cod_can = c.cod_can
and d.cod_dis = 10101
OR d.cod_dis = 10102
OR d.cod_dis = 10103
OR d.cod_dis = 10104
OR d.cod_dis = 10105
OR d.cod_dis = 10107
OR d.cod_dis = 10108
OR d.cod_dis = 10109
OR d.cod_dis = 10110;

-- CONSULTA #2 (LLAVES FORÁNEAS Y RELACIONES TOPOLÓGICAS)

-- cada distrito en riesgo de incendio y el cantón al que pertenece 
select distinct d.cod_dis, d.nombre_dis, c.cod_can, c.nombre_can
from distritos d, cantones c, riesgos_incen ri
where d.cod_can = c.cod_can
and ri.geom.STIntersects(d.geom) = 1;

-- CONSULTA #2 (SOLO RELACIONES TOPOLÓGICAS)
-- áreas de salud que se encuentran en riesgos de incendio alto
-- (solo relaciones topológicas)
select ri.id, a.nombre_as, a.id , a.geom.STIntersection(ri.geom) as geomRiesgo
from riesgos_incen as ri, areas_salud as a
where ri.riesgo = 'ALTO'
and a.geom.STIntersection(ri.geom).STArea() > 0;

-- CON ESTO LIMPIA EL BUFFER Y EL CACHÉ
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE; 

-- CON ESTO ENCIENDE LAS ESTADÍSTICAS COMO PARTE DE LOS RESULTADOS DE LA EJECUCIÓN
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
