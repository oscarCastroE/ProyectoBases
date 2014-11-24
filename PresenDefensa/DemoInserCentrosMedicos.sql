-- Si inserto un polígono no hace la inserción, pues solo se permiten puntos.
insert 
into centros_medicos (nombre, geom)
values ('polígono', 'POLYGON((-20 -20, -20 20, 20 20, 20 -20, -20 -20))');

select * from centros_medicos where nombre = 'polígono';

-- Si inserto un punto no contenido dentro de un área de salud, 
-- no se puede porque viola la participación total.
select geom.STX, geom.STY from centros_medicos;

insert 
into centros_medicos (nombre, geom)
values ('punto mal ubicado', geometry::STPointFromText('POINT(0 10)',0));

select * from centros_medicos where nombre = 'punto mal ubicado';

-- Si inserto un hospital del shape (válido) 
insert 
into centros_medicos (nombre, geom)
values ('centro medico valido', (select top 1 geom from clinicas2008crtm05) );

select * from centros_medicos where nombre = 'centro medico valido';
delete from centros_medicos where nombre = 'centro medico valido';



