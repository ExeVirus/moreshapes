-- Common Shape Functions
local curve3d = {}

local vector = shapes.vector
local validate_vector = vector.validate_vector
local error = shapes.error
local istable = shapes.util.istable
local isnumber = shapes.util.isnumber
local validnumber = shapes.util.validnumber
local validstring = shapes.util.validstring
local validate_segment = shapes.points.validate_segment

function curve3d.curve2_closed(left_in, right_in, bottomh, toph, bottom_ty, top_ty, name)
    reset_mesh()
    validate_segment(left_in)
    validate_segment(right_in)
    validnumber(bottomh)
    validnumber(toph)
    validnumber(bottom_ty)
    validnumber(top_ty)
    validstring(name)
    local left = shapes.util.copy(left_in)
    local right = shapes.util.copy(right_in)

    shapes.curve2d.wall(left, toph-bottomh, top_ty, 3)
    shapes.curve2d.wall(right, toph-bottomh, top_ty, 4)

--calculate the front and back
    local bl, tl, tr, br = 0,0,0,0
    bl = vector.new(left[#left].x,bottomh,left[#left].z,0,0,0,0,bottom_ty)
    br = vector.new(right[1].x,bottomh,right[1].z,0,0,0,1,bottom_ty)
    tr = vector.new(br); tr.y = toph; tr.ty = top_ty
    tl = vector.new(bl); tl.y = toph; tl.ty = top_ty
    shapes.common.quad(bl,tl,tr,br,5)

    bl = vector.new(left[1].x,bottomh,left[1].z,0,0,0,1,bottom_ty)
    br = vector.new(right[#right].x,bottomh,right[#right].z,0,0,0,0,bottom_ty)
    tr = shapes.vector.new(br); tr.y = toph; tr.ty = top_ty
    tl = shapes.vector.new(bl); tl.y = toph; tl.ty = top_ty
    shapes.common.quad(br,tr,tl,bl,6)

--Calculate the top and bottoms
    --reorder
    local rev = {}
    for i=#left, 1, -1 do
	    rev[#rev+1] = left[i]
    end
    left = rev

    --Top
    local tx_offset = left[1].x
    local ty_offset = left[1].z
    for i=1,#left,1 do
        left[i].y = toph
        left[i].tx = left[i].x - tx_offset
        left[i].ty = left[i].z - ty_offset
    end

    for i=1,#right,1 do
        right[i].y = toph
        right[i].tx = right[i].x - tx_offset
        right[i].ty = right[i].z - ty_offset
    end
    shapes.curve2d.curve_segements(left, right, vector.new(0,1,0,0,0,0,0,0), 1)

    --Bottom
    local tx_offset = right[1].x
    local ty_offset = right[1].z
    for i=1,#left,1 do
        left[i].y = bottomh
        left[i].tx = left[i].x - tx_offset
        left[i].ty = left[i].z - ty_offset
    end

    for i=1,#right,1 do
        right[i].y = bottomh
        right[i].tx = right[i].x - tx_offset
        right[i].ty = right[i].z - ty_offset
    end

    shapes.curve2d.curve_segements(right, left, vector.new(0,-1,0,0,0,0,0,0), 2)

    export_mesh(name)
end

function curve3d.point_curve(left_point_in, right_in, bottomh, toph, bottom_ty, top_ty, name)
    reset_mesh()
    validate_vector(left_point_in)
    validate_segment(right_in)
    validnumber(bottomh)
    validnumber(toph)
    validnumber(bottom_ty)
    validnumber(top_ty)
    validstring(name)
    local left = shapes.util.copy(left_point_in)
    local right = shapes.util.copy(right_in)

    --Outer Curve
    shapes.curve2d.wall(right, toph-bottomh, top_ty, 4)

    --Front and Back
    local bl, tl, tr, br = 0,0,0,0
    bl = vector.new(left.x,bottomh,left.z,0,0,0,0,bottom_ty)
    br = vector.new(right[1].x,bottomh,right[1].z,0,0,0,1,bottom_ty)
    tr = vector.new(br); tr.y = toph; tr.ty = top_ty
    tl = vector.new(bl); tl.y = toph; tl.ty = top_ty
    shapes.common.quad(bl,tl,tr,br,5)

    bl = vector.new(right[#right].x,bottomh,right[#right].z,0,0,0,0,bottom_ty)
    br = vector.new(left.x,bottomh,left.z,0,0,0,1,bottom_ty)
    tr = shapes.vector.new(br); tr.y = toph; tr.ty = top_ty
    tl = shapes.vector.new(bl); tl.y = toph; tl.ty = top_ty
    shapes.common.quad(bl,tl,tr,br,6)

    --Top
    local tx_offset = left.x
    local ty_offset = left.z
    left.y = toph

    for i=1,#right,1 do
        right[i].y = toph
        right[i].tx = right[i].x - tx_offset
        right[i].ty = right[i].z - ty_offset
    end

    shapes.curve2d.corner_curve_c_clockwise(left, right, vector.new(0,1,0,0,0,0,0,0), 1)

    --Bottom
    local tx_offset = right[1].x
    local ty_offset = right[1].z
    left.y = bottomh

    for i=1,#right,1 do
        right[i].y = bottomh
        right[i].tx = right[i].x - tx_offset
        right[i].ty = right[i].z - ty_offset
    end

    shapes.curve2d.corner_curve_clockwise(left, right, vector.new(0,-1,0,0,0,0,0,0), 2)

    export_mesh(name)
end

return curve3d