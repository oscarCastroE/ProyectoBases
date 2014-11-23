-- Si inserto un polígono no hace la inserción, pues solo se permiten puntos.
insert 
into centros_medicos (nombre, geom)
values ('polígono', 'POLYGON((-20 -20, -20 20, 20 20, 20 -20, -20 -20))');

select * from centros_medicos where nombre = 'centro médico con polígono';

-- Si inserto un polígono no hace la inserción, pues solo se permiten puntos.
insert 
into centros_medicos (nombre, geom)
values ('punto fuera del país', geometry::STPointFromText('POINT(0 10)',0));

select * from centros_medicos where nombre = 'punto fuera del país';

-- Si inserto un hospital del shape (válido) 
insert 
into centros_medicos (nombre, geom)
values ('centro medico valido', (select top 1 geom from clinicas2008crtm05) );

select * from centros_medicos where nombre = 'centro medico valido';

