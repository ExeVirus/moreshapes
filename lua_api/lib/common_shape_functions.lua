-- Common Shape Functions

local vector = shapes.vector

shapes.quad = function(bottom_left_corner, top_left_corner, top_right_corner, group)
    vector.validate_vector(bottom_left_corner)
    vector.validate_vector(top_left_corner)
    vector.validate_vector(top_right_corner)
    if type(group) ~= "number" then shapes.error("4th arg: expected number, got "..type(group)) end

    local bl = bottom_left_corner --0,0,0, 0,0
    local tl = top_left_corner --0,0,1, 0,1
    local tr = top_right_corner --1,0,0, 1,1
    local br = vector.add(vector.subtract(bl,tl),tr)
    local n = vector.cross(vector.subtract(bl,tl),vector.subtract(bl,tr))
    
    add_triangle(
        tl.x, tl.y, tl.z,
        bl.x, bl.y, bl.z,
        tr.x, tr.y, tr.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        tl.tx, tl.ty,
        bl.tx, bl.ty,
        tr.tx, tr.ty,
        group
    )

    add_triangle(
        br.x, br.y, br.z,
        tr.x, tr.y, tr.z,
        bl.x, bl.y, bl.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        br.tx, br.ty,        
        tr.tx, tr.ty,
        bl.tx, bl.ty,
        group
    )
end