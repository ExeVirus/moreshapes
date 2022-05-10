-- Common Shape Functions
local curve3d = {}

local vector = shapes.vector
local validate_vector = vector.validate_vector
local error = shapes.error
local istable = shapes.util.istable
local isnumber = shapes.util.isnumber

function curve3d.curve2(left, right, bottomh, toph, bottom_ty, top_ty, name)
    reset_mesh()

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

function curve3d.point_curve(left_point, right, bottomh, toph, bottom_ty, top_ty)

end

return curve3d