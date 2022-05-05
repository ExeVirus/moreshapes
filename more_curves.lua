-- Object A
-- 1.2 nodes tall
-- vertical to 45° right curve
-- 1-node width
--
--    .-^\
--   /    \
--  /    .-
--  |   -
--  |   |
--  +---+
--
------------------------------

-- line1 = outer_curve_points (starts at 0,0 ends at 0.646, 1.354)
-- line2 = inner_curve_points (starts at 1,0 ends at 1.354, 0.646)
--math to describe:
-- midpoint starts at 0.5,0, and ends at 0,1. 

-- 2d_2curve_closed(line1, line2)
-- export_mesh("a.obj")


-- # cube.obj
-- #

-- v  0.0  0.0  0.0
-- v  0.0  0.0  1.0
-- v  0.0  1.0  0.0
-- v  0.0  1.0  1.0
-- v  1.0  0.0  0.0
-- v  1.0  0.0  1.0
-- v  1.0  1.0  0.0
-- v  1.0  1.0  1.0

-- vn  0.0  0.0  1.0
-- vn  0.0  0.0 -1.0
-- vn  0.0  1.0  0.0
-- vn  0.0 -1.0  0.0
-- vn  1.0  0.0  0.0
-- vn -1.0  0.0  0.0

-- g cube 
-- f  1//2  7//2  5//2
-- f  1//2  3//2  7//2 
-- f  1//6  4//6  3//6 
-- f  1//6  2//6  4//6 
-- f  3//3  8//3  7//3 
-- f  3//3  4//3  8//3 
-- f  5//5  7//5  8//5 
-- f  5//5  8//5  6//5 
-- f  1//4  5//4  6//4 
-- f  1//4  6//4  2//4 
-- f  2//1  6//1  8//1 
-- f  2//1  8//1  4//1 

local v = shapes.vector.new
local function v5(x,y,z,tx,ty)
    return v(x,y,z,0,0,0,tx,ty)
end

shapes.quad(
    v5(0,0,0,0,0),
    v5(0,0,-1,0,1),
    v5(1,0,-1,1,1),
    1
)
export_mesh("a.obj")