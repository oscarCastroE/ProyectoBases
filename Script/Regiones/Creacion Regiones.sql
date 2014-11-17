---Creamos la tabla as_region (archivo regiones-areasalud) este trae el id de region relacionado a cada area de salud
---Primero alteramos la tabla areas_salud para agregarle la columna correspondiente al id_region
USE [Proyecto]
GO
ALTER TABLE areas_salud
ADD id_region int;

--agregamos la region correspondiente a cada area
 
UPDATE
     areas_salud 
SET
     areas_salud.id_region = as_region.codigo_region
FROM
     areas_salud 
INNER JOIN     
     as_region 
ON     
     areas_salud.id = as_region.codigo_as;
     
--Creamos la geometria de las regiones a partir de la geometria de las areas de salud

DECLARE @codRegion int
DECLARE @GeomRegion geometry
SET @GeomRegion = geometry::Parse('MULTIPOLYGON EMPTY')
DECLARE cursorCodRegion CURSOR FOR SELECT id FROM region 
OPEN cursorCodRegion
FETCH NEXT FROM cursorCodRegion INTO @codRegion
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @GeomRegion = @GeomRegion.STUnion(ar.geom)
		FROM areas_salud ar
		WHERE ar.id_region = @codRegion
		UPDATE region  SET geom = @GeomRegion
		WHERE id = @codRegion
		SET @GeomRegion = geometry::Parse('MULTIPOLYGON EMPTY')
		FETCH NEXT FROM cursorCodRegion INTO @codRegion
	END
CLOSE cursorCodRegion
DEALLOCATE cursorCodRegion
