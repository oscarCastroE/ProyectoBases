USE [Proyecto]
GO

CREATE TABLE region(
id INT IDENTITY(1,1) PRIMARY KEY,
nombre_re VARCHAR(100),
geom geometry DEFAULT NULL
);

SET IDENTITY_INSERT dbo.region ON;

INSERT INTO region(id,nombre_re)
VALUES(1,'Region Central Norte');

INSERT INTO region(id,nombre_re)
VALUES(2,'Region Central Sur');

INSERT INTO region(id,nombre_re)
VALUES(3,'Region Chorotega');

INSERT INTO region(id,nombre_re)
VALUES(4,'Region Pacifico Central');

INSERT INTO region(id,nombre_re)
VALUES(5,'Region Brunca');

INSERT INTO region(id,nombre_re)
VALUES(6,'Region Huetar Atlantica');

INSERT INTO region(id,nombre_re)
VALUES(7,'Region Huetar Norte');
