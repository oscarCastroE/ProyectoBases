-- Si inserto un pol�gono no hace la inserci�n, pues solo se permiten puntos.
insert 
into centros_medicos (nombre, geom)
values ('pol�gono', 'POLYGON((-20 -20, -20 20, 20 20, 20 -20, -20 -20))');

select * from centros_medicos where nombre = 'pol�gono';

-- Si inserto un punto no contenido dentro de un �rea de salud, 
-- no se puede porque viola la participaci�n total.
select geom.STX, geom.STY from centros_medicos;

insert 
into centros_medicos (nombre, geom)
values ('punto mal ubicado', geometry::STPointFromText('POINT(0 10)',0));

select * from centros_medicos where nombre = 'punto mal ubicado';

-- Si inserto un hospital del shape (v�lido) 
insert 
into centros_medicos (nombre, geom)
values ('centro medico valido', (select top 1 geom from clinicas2008crtm05) );

select * from centros_medicos where nombre = 'centro medico valido';
delete from centros_medicos where nombre = 'centro medico valido';



