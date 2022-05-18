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
local curve = points.super_e_curve(math.pi*0/4, math.pi*1/4, 5, 1.5, 1, 1, 1.71, 1.71)

--offset to center on minetest node
curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,0,0))
curve = p_manip.add(curve, v(-1.5,-0.5,0,0,0,0,0))

--inner will be listed in reverse order, to get correct winding
local inner = p_manip.reverse(curve)
inner = p_manip.func(inner, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+1), 0.5)) end)

local outer = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
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

curve = points.super_e_curve(math.pi*0/4, math.pi*2/4, 5, 1, 1, 1, 1.71, 1.71)
curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,1,1))
curve = p_manip.add(curve, v3(-0.5,-0.5,0.5))
calc_tx(curve)


shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50,-0.25, 0.00, 0.25,4, "models/b_1.obj")
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50, 0.00, 0.00, 0.50,4, "models/b_2.obj")
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50, 0.25, 0.25, 0.75,4, "models/b_3.obj")
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50, 0.50, 0.00, 1.00,4, "models/b_4.obj")

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

shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50,-0.25, 0.00, 0.25,4, "models/_b_1.obj")
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50, 0.00, 0.00, 0.50,4, "models/_b_2.obj")
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50, 0.25, 0.25, 0.75,4, "models/_b_3.obj")
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50, 0.50, 0.00, 1.00,4, "models/_b_4.obj")

----------------------------------------------------------------
------------------------------Mesh 4----------------------------
-- Object A1`
-- 1 nodes tall
-- 90° inverse corner of a A piece and an Ar piece
--  +------+
--  |      |
--  +-_    |
--     \   |
--     +---+
----------------------------------------------------------------
--Create a special function for this pieces
local curve_A1 = function(bottomh,toph,bottom_ty,top_ty,name)
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2 -- Yes, there is some magical number being used for the angles, no I didn't do the math
    local curve = points.super_e_curve(math.pi/4-magic_number, math.pi/4+magic_number, 5, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    curve = p_manip.add(curve, v3(-1.5,bottomh,-1.5))
    curve = p_manip.multiply(curve, v(1,1,-1,-1,1,1,1,1))
    curve = p_manip.reverse(curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        local tx = -0.073
        seg[1].tx = tx
        for i=2,#seg,1 do
            tx = tx + vector.distance(seg[i],seg[i-1])
            seg[i].tx = tx
        end
    end
    calc_tx(curve)

    local curve_open = function(curve)
        shapes.curve3d.point_curve_open(v3(0.5,bottomh,-0.5), curve, bottomh, toph, bottom_ty, top_ty,3,"no_export")
    end

    curve_open({ v(-0.5,bottomh,-0.5,-1,0,0,0,0), v(curve[1].x, curve[1].y, curve[1].z,-1,0,0,curve[1].z+0.5,0) })    -- left
    curve_open(curve)                                                                                                 -- curve
    curve_open({ v(curve[5].x, curve[5].y, curve[5].z,0,0,1,curve[5].x+0.5,0), v(0.5,bottomh,0.5,0,0,1,1,0) })        -- front
    shapes.curve2d.wall({ v(0.5,bottomh,-0.5,0,0,-1,0,0), v(-0.5,bottomh,-0.5,0,0,-1,1,0) }, toph-bottomh, top_ty, 6) -- back
    shapes.curve2d.wall({ v(0.5,bottomh,0.5,0,0,-1,0,0), v(0.5,bottomh,-0.5,0,0,-1,1,0) }, toph-bottomh, top_ty, 6)   -- right
    
    export_mesh(name)
end

curve_A1(-0.50,-0.25, 0.00, 0.25, "models/a1_1.obj")
curve_A1(-0.50, 0.00, 0.00, 0.50, "models/a1_2.obj")
curve_A1(-0.50, 0.25, 0.25, 0.75, "models/a1_3.obj")
curve_A1(-0.50, 0.50, 0.00, 1.00, "models/a1_4.obj")

----------------------------------------------------------------
------------------------------Mesh 5----------------------------
-- Object A1`
-- 1 nodes tall
-- 90° inverse of start of an A piece 
--       --+
--       ^.|
--        -|
--        \|
--         +
----------------------------------------------------------------
local curve_A2 = function(bottomh,toph,bottom_ty,top_ty,name)
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2 -- Yes, there is some magical number being used for the angles, no I didn't do the math
    local curve = points.super_e_curve(0, math.pi/4-magic_number, 5, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    curve = p_manip.add(curve, v3(-1.5,bottomh,-0.5))
    curve = p_manip.multiply(curve, v(1,1,-1,-1,1,1,1,1))
    curve = p_manip.reverse(curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        local tx = 1
        seg[#seg].tx = tx
        for i=#seg-1,1,-1 do
            tx = tx - vector.distance(seg[i+1],seg[i])
            seg[i].tx = tx
        end
    end
    calc_tx(curve)

    shapes.curve3d.point_curve_open(v3(0.5,bottomh,-0.5), curve, bottomh, toph, bottom_ty, top_ty,3,"no_export") --top, bottom, left
    shapes.curve2d.wall({ v(0.5,bottomh,-0.5,0,0,-1,0,0), v(curve[1].x,bottomh,-0.5,0,0,-1,0.5-curve[1].x,0) }, toph-bottomh, top_ty, 6) -- back
    shapes.curve2d.wall({ v(0.5,bottomh,0.5,1,0,0,0,0), v(0.5,bottomh,-0.5,1,0,0,1,0) }, toph-bottomh, top_ty, 4) -- right

    export_mesh(name)
end

curve_A2(-0.50,-0.25, 0.00, 0.25, "models/a2_1.obj")
curve_A2(-0.50, 0.00, 0.00, 0.50, "models/a2_2.obj")
curve_A2(-0.50, 0.25, 0.25, 0.75, "models/a2_3.obj")
curve_A2(-0.50, 0.50, 0.00, 1.00, "models/a2_4.obj")

local curve_A2R = function(bottomh,toph,bottom_ty,top_ty,name)
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2 -- Yes, there is some magical number being used for the angles, no I didn't do the math
    local curve = points.super_e_curve(math.pi/4+magic_number, math.pi/2, 5, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    curve = p_manip.add(curve, v3(-0.5,bottomh,-1.5))
    curve = p_manip.multiply(curve, v(1,1,-1,-1,1,1,1,1))
    curve = p_manip.reverse(curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        local tx = 0.847
        seg[#seg].tx = tx
        for i=#seg-1,1,-1 do
            tx = tx - vector.distance(seg[i+1],seg[i])
            seg[i].tx = tx
        end
    end
    calc_tx(curve)

    shapes.curve3d.point_curve_open(v3(0.5,bottomh,-0.5), curve, bottomh, toph, bottom_ty, top_ty,3,"no_export") --top, bottom, left
    shapes.curve2d.wall({ v(0.5,bottomh,-0.5,0,0,-1,0,0), v(-0.5,bottomh,-0.5,0,0,-1,1,0) }, toph-bottomh, top_ty, 6) -- back
    shapes.curve2d.wall({ v(0.5,bottomh,curve[5].z,1,0,0,0.5-curve[5].z,0), v(0.5,bottomh,-0.5,1,0,0,1,0) }, toph-bottomh, top_ty, 4) -- right

    export_mesh(name)
end

curve_A2R(-0.50,-0.25, 0.00, 0.25, "models/a2_1r.obj")
curve_A2R(-0.50, 0.00, 0.00, 0.50, "models/a2_2r.obj")
curve_A2R(-0.50, 0.25, 0.25, 0.75, "models/a2_3r.obj")

----------------------------------------------------------------
------------------------------Mesh 6----------------------------
-- Object AF
-- 2 nodes tall, 2 nodes wide
-- Full 90° inverse of two A pieces
--  +_----------+
--    ^-_       |
--       ^-_    |
--          \   |
--           ^. |
--             -|
--             \|
--              +
----------------------------------------------------------------

local curve_AF = function(bottomh,toph,bottom_ty,top_ty,name)
    reset_mesh()
    local curve = points.super_e_curve(0, math.pi/2, 9, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    curve = p_manip.add(curve, v3(-1.5,bottomh,-1.5))
    curve = p_manip.multiply(curve, v(1,1,-1,-1,1,1,1,1))
    curve = p_manip.reverse(curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        local tx = 1
        seg[#seg].tx = tx
        for i=#seg-1,1,-1 do
            tx = tx - vector.distance(seg[i+1],seg[i])
            seg[i].tx = tx
        end
    end
    calc_tx(curve)

    shapes.curve3d.point_curve_open(v3(0.5,bottomh,-0.5), curve, bottomh, toph, bottom_ty, top_ty,3,"no_export") --top, bottom, left
    shapes.curve2d.wall({ v(0.5,bottomh,-0.5,0,0,-1,0,0), v(-1.5,bottomh,-0.5,0,0,-1,2,0) }, toph-bottomh, top_ty, 6) -- back
    shapes.curve2d.wall({ v(0.5,bottomh,1.5,1,0,0,0,0), v(0.5,bottomh,-0.5,1,0,0,2,0) }, toph-bottomh, top_ty, 4) -- right

    export_mesh(name)
end

curve_AF(-0.50,-0.25, 0.00, 0.25, "models/af_1.obj")
curve_AF(-0.50, 0.00, 0.00, 0.50, "models/af_2.obj")
curve_AF(-0.50, 0.25, 0.25, 0.75, "models/af_3.obj")
curve_AF(-0.50, 0.50, 0.00, 1.00, "models/af_4.obj")
