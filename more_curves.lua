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

local function v3(x,y,z)
    return v(x,y,z,0,0,0,0,0)
end

-- shapes.rect(    v5(0,0,0,0,0),
--                 v5(1,0,0,0,1),
--                 v5(1,0,1,1,1),    1)
-- shapes.rect(    v5(2,0,0,0,0),
--                 v5(3,0,0,0,1),
--                 v5(3,0,.5,1,1),    1)

local aarp = shapes.axis_aligned_rectangular_prism
aarp(v3(-5,0,0),v3(1.5,1.5,1.5), true)

local quad = shapes.quad
 quad(   v5(4,   0,  0,   0,0),
         v5(4,   1.5,0,   0,1.5),
         v5(4,   1,  1,   1,1),    
         v5(4,   0,  1,   1,0),  1)

shapes.corner_curve_c_clockwise(v5(0,0,4,0,0), {v5(1,0,4,0,1),v5(0.95,0,3.9,0.1,0.95),v5(0.85,0,3.8,0.2,0.9)}, v3(0,1,0), 1)
local seg1 = {  v( 0.0, 0.0, 0.0,    1.0, 0.0, 0.0,     0.0, 0.0),
                v( 0.1, 0.0,-0.5,    1.0, 0.0, 0.0,     0.5, 0.1),
                v(0.25, 0.0,-1.0,    1.0, 0.0, 0.0,     1.0, 0.25),
                v(0.05, 0.0,-1.5,    1.0, 0.0, 0.0,     1.5, 0.05)
            }

local seg2 = {  v( 1.0, 0.0, 0.0,    1.0, 0.0, 0.0,     0.0, 1.0),
                v( 0.9, 0.0,-0.4,    1.0, 0.0, 0.0,     0.5, 0.9),
                v(0.75, 0.0,-0.8,    1.0, 0.0, 0.0,     1.0, 0.75),
                v(0.60, 0.0,-1.2,    1.0, 0.0, 0.0,     1.5, 0.60)
            }

shapes.curve_segements(seg1, seg2, v3(0, 1,0), 1)
shapes.curve_segements(seg2, seg1, v3(0,-1,0), 2)

for i=1,#seg1, 1 do
    seg1[i] = shapes.vector.add(seg1[i], v3(-3,2,0))
end

shapes.wall(seg1, 1, 1, 1)

export_mesh("example-a.obj")
reset_mesh()

----------------------------------------------------------------
--------------------------Mesh "a"------------------------------
----------------------------------------------------------------

local outer = shapes.points.super_e_curve(math.pi*0/4, math.pi*1/4, 5, 1.5, 1, 1, 1.71, 1.71)
--generate mirror copies of the core curve on the right spot around origin
for i=1,#outer, 1 do
    outer[i] = shapes.vector.add(shapes.vector.multiply(outer[i], shapes.vector.new(1,1,-1,1,1,1,0,0)), v3(-1.5,0,0))
end
local inner = {}
for i=1,#outer, 1 do
    inner[#outer+1-i] = outer[i]
end

for i=1,#outer, 1 do
    outer[i] = shapes.vector.multiply(outer[i], shapes.vector.new(1,1,1,-1,-1,-1,1,1))
    outer[i] = shapes.vector.add(outer[i], shapes.vector.multiply(v3(outer[i].nx,0,-outer[i].nz), 0.5))
end
for i=1,#inner, 1 do
    inner[i] = shapes.vector.add(inner[i], shapes.vector.multiply(v3(inner[i].nx,0,-inner[i].nz), 0.5))
end

shapes.wall(inner, 1, 1, 1)
shapes.wall(outer, 1, 1, 1)

export_mesh("a.obj")
