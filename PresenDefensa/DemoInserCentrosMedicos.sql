-- Si inserto un pol�gono no hace la inserci�n, pues solo se permiten puntos.
insert 
into centros_medicos (nombre, geom)
values ('pol�gono', 'POLYGON((-20 -20, -20 20, 20 20, 20 -20, -20 -20))');

select * from centros_medicos where nombre = 'centro m�dico con pol�gono';

-- Si inserto un pol�gono no hace la inserci�n, pues solo se permiten puntos.
insert 
into centros_medicos (nombre, geom)
values ('punto fuera del pa�s', geometry::STPointFromText('POINT(0 10)',0));

select * from centros_medicos where nombre = 'punto fuera del pa�s';

-- Si inserto un hospital del shape (v�lido) 
insert 
into centros_medicos (nombre, geom)
values ('centro medico valido', (select top 1 geom from clinicas2008crtm05) );

select * from centros_medicos where nombre = 'centro medico valido';

