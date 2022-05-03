--Lua Api for MoreShapes, see readme.adoc in this folder

--api table
shapes = {}

-- utility functions
dofile("lua_api/lib/util.lua")

-- vector math lib
dofile("lua_api/lib/vector.lua")

-- Cube, quad, etc
dofile("lua_api/lib/common_shape_functions.lua")

-- superellipse stuff
dofile("lua_api/lib/2d_point_generation_functions.lua")

-- offset, rotation, mirror, length etc.
dofile("lua_api/lib/2d_point_functions.lua")

-- 1curve, 2curve, etc.
dofile("lua_api/lib/2d_curve_functions.lua")

-- tbd
-- dofile("lib/3d_curve_functions.lua")