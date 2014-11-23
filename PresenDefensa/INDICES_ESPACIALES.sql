-- Creaci�n de �ndices Espaciales.
CREATE SPATIAL INDEX [distritos_idx] ON [dbo].[distritos] 
(
	[geom]
)USING  GEOMETRY_GRID 
WITH (
BOUNDING_BOX =(283584.5, 889274.625, 658968.875, 1241133.875), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

CREATE SPATIAL INDEX [cantones_idx] ON [dbo].[cantones] 
(
	[geom]
)USING  GEOMETRY_GRID 
WITH (
BOUNDING_BOX =(283584.5, 889274.625, 658968.875, 1241133.875), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

CREATE SPATIAL INDEX [provincias_idx] ON [dbo].[provincias] 
(
	[geom]
)USING  GEOMETRY_GRID 
WITH (
BOUNDING_BOX =(283584.5, 889274.625, 658968.875, 1241133.875), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

CREATE SPATIAL INDEX [areas_salud_idx] ON [dbo].[areas_salud] 
(
	[geom]
)USING  GEOMETRY_GRID 
WITH (
BOUNDING_BOX =(283584.5, 889274.625, 658968.875, 1241133.875), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

CREATE SPATIAL INDEX [region_idx] ON [dbo].[region] 
(
	[geom]
)USING  GEOMETRY_GRID 
WITH (
BOUNDING_BOX =(283584.5, 889274.625, 658968.875, 1241133.875), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

CREATE SPATIAL INDEX [centros_medicos_idx] ON [dbo].[centros_medicos] 
(
	[geom]
)USING  GEOMETRY_GRID 
WITH (
BOUNDING_BOX =(283584.5, 889274.625, 658968.875, 1241133.875), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

CREATE SPATIAL INDEX [riesgos_inun_idx] ON [dbo].[riesgos_inun] 
(
	[geom]
)USING  GEOMETRY_GRID 
WITH (
BOUNDING_BOX =(283584.5, 889274.625, 658968.875, 1241133.875), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

CREATE SPATIAL INDEX [riesgos_incen_idx] ON [dbo].[riesgos_incen] 
(
	[geom]
)USING  GEOMETRY_GRID 
WITH (
BOUNDING_BOX =(283584.5, 889274.625, 658968.875, 1241133.875), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)

DROP INDEX [distritos_idx] ON [dbo].[distritos] ;
DROP INDEX [cantones_idx] ON [dbo].[cantones];
DROP INDEX [provincias_idx] ON [dbo].[provincias] ;
DROP INDEX [areas_salud_idx] ON [dbo].[areas_salud] ;
DROP INDEX [region_idx] ON [dbo].[region] ;
DROP INDEX [centros_medicos_idx] ON [dbo].[centros_medicos] ;
DROP INDEX [riesgos_inun_idx] ON [dbo].[riesgos_inun] ;
DROP INDEX [riesgos_incen_idx] ON [dbo].[riesgos_incen];