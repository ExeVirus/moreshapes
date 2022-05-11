-----Preloaded locals-----
local points = shapes.points
local vector = shapes.vector
local p_manip = shapes.p_manip
local v = vector.new
local function v3(x,y,z)
    return v(x,y,z,0,0,0,0,0)
end

----------------------------------------------------------------
------------------------------Mesh 1----------------------------
-- Object A
-- 1.2 nodes tall
-- vertical to 45° left curve
-- 1-node width
--
--   /^-.   
--  /    \  
--  -.   |
--   -   |
--   +---+
--
----------------------------------------------------------------

--Calculate the center line of the curve
local center = points.super_e_curve(math.pi*0/4, math.pi*1/4, 5, 1.5, 1, 1, 1.71, 1.71)

--offset to center on minetest node
center = p_manip.multiply(center, v(1,1,-1,1,1,1,0,0))
center = p_manip.add(center, v(-1.5,-0.5,0,0,0,0,0))

--inner will be listed in reverse order, to get correct winding
local inner = p_manip.reverse(center)
inner = p_manip.func(inner, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+1), 0.5)) end)

local outer = p_manip.multiply(center, v(1,1,1,-1,-1,-1,1,1))
outer = p_manip.func(outer, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+1), 0.5)) end)

local function calc_tx(seg)
    points.validate_segment(seg)
    local tx = 0
    seg[1].tx = 0
    for i=2,#seg,1 do
        tx = tx + vector.distance(seg[i],seg[i-1])
        seg[i].tx = tx
    end
end
calc_tx(inner)
calc_tx(outer)

local rev_inner = p_manip.multiply(outer, v(-1,1,1,-1,1,1,0,0))
rev_inner = p_manip.reverse(rev_inner)
calc_tx(rev_inner)

local rev_outer = p_manip.multiply(inner, v(-1,1,1,-1,1,1,0,0))
rev_outer = p_manip.reverse(rev_outer)
calc_tx(rev_outer)

shapes.curve3d.curve2_closed(inner, outer, -0.50,-0.25, 0.00, 0.25,"models/a_1.obj")
shapes.curve3d.curve2_closed(inner, outer, -0.50, 0.00, 0.00, 0.50,"models/a_2.obj")
shapes.curve3d.curve2_closed(inner, outer, -0.50, 0.25, 0.25, 0.75,"models/a_3.obj")
shapes.curve3d.curve2_closed(inner, outer, -0.50, 0.50, 0.00, 1.00,"models/a_4.obj")
shapes.curve3d.curve2_closed(rev_inner, rev_outer, -0.50,-0.25, 0.00, 0.25,"models/a_1r.obj")
shapes.curve3d.curve2_closed(rev_inner, rev_outer, -0.50, 0.00, 0.00, 0.50,"models/a_2r.obj")
shapes.curve3d.curve2_closed(rev_inner, rev_outer, -0.50, 0.25, 0.25, 0.75,"models/a_3r.obj")

----------------------------------------------------------------
------------------------------Mesh 2----------------------------
-- Object B
-- 1 nodes tall
-- 90° left curve
--  ---. 
--  |   ^
--  |    \  
--  +----+
--
----------------------------------------------------------------

local curve = points.super_e_curve(math.pi*0/4, math.pi*2/4, 5, 1, 1, 1, 1.71, 1.71)
curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,1,1))
curve = p_manip.add(curve, v3(-0.5,-0.5,0.5))

shapes.curve3d.point_curve(v3(-0.5,-0.5,0.5), curve, -0.50,-0.25, 0.00, 0.25, "models/b_1.obj")
shapes.curve3d.point_curve(v3(-0.5,-0.5,0.5), curve, -0.50, 0.00, 0.00, 0.50, "models/b_2.obj")
shapes.curve3d.point_curve(v3(-0.5,-0.5,0.5), curve, -0.50, 0.25, 0.25, 0.75, "models/b_3.obj")
shapes.curve3d.point_curve(v3(-0.5,-0.5,0.5), curve, -0.50, 0.50, 0.00, 1.00, "models/b_4.obj")

----------------------------------------------------------------
------------------------------Mesh 3----------------------------
-- Object B`
-- 1 nodes tall
-- 90° left curve
--  -._--+ 
--     ^.|
--      ^|  
--  
----------------------------------------------------------------
curve = p_manip.reverse(curve)
curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))

shapes.curve3d.point_curve(v3(0.5,-0.5,-0.5), curve, -0.50,-0.25, 0.00, 0.25, "models/b`_1.obj")
shapes.curve3d.point_curve(v3(0.5,-0.5,-0.5), curve, -0.50, 0.00, 0.00, 0.50, "models/b`_2.obj")
shapes.curve3d.point_curve(v3(0.5,-0.5,-0.5), curve, -0.50, 0.25, 0.25, 0.75, "models/b`_3.obj")
shapes.curve3d.point_curve(v3(0.5,-0.5,-0.5), curve, -0.50, 0.50, 0.00, 1.00, "models/b`_4.obj")