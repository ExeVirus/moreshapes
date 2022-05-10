-- Common Shape Functions

local vector = shapes.vector

--Single normal used for all pieces
function shapes.corner_curve_c_clockwise(corner, segments, normal, group)
    ---Validation---
    if type(segments) ~= "table" then shapes.error("Segements is not a table") end
    if #segments < 2 then shapes.error("Segements has fewer than 2 points") end
    local validate_vector = vector.validate_vector
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    validate_vector(corner)
    if type(group) ~= "number" then shapes.error("4th arg: expected number, got "..type(group)) end
    ---Creation---
    for i=1,#segments-1,1 do
        local first = segments[i]
        local second = segments[i+1]
        add_triangle(
            corner.x, corner.y, corner.z,
            first.x, first.y, first.z,
            second.x, second.y, second.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            corner.tx, corner.ty,
            first.tx, first.ty,
            second.tx, second.ty,
            group
        )
    end
end

--Single normal used for all pieces
function shapes.corner_curve_clockwise(corner, segments, normal, group)
    ---Validation---
    if type(segments) ~= "table" then shapes.error("Segements is not a table") end
    if #segments < 2 then shapes.error("Segements has fewer than 2 points") end
    local validate_vector = vector.validate_vector
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    validate_vector(corner)
    if type(group) ~= "number" then shapes.error("4th arg: expected number, got "..type(group)) end
    ---Creation---
    for i=1,#segments-1,1 do
        local first = segments[i]
        local second = segments[i+1]
        add_triangle(
            first.x, first.y, first.z,
            corner.x, corner.y, corner.z,
            second.x, second.y, second.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            first.tx, first.ty,
            corner.tx, corner.ty,
            second.tx, second.ty,
            group
        )
    end
end

--These segements shouldn't cross... and start at the front and work their way backwards (z to -z)
function shapes.curve_segements(left_segment, right_segment, normal, group)
    ---Validation---
    local validate_vector = vector.validate_vector
    local function validate_segments(seg)
        if type(seg) ~= "table" then shapes.error("Segment is not a table") end
        if #seg < 2 then shapes.error("Segment has fewer than 2 points") end
        for i=1,#seg,1 do
            validate_vector(seg[i])
        end
    end
    validate_segments(left_segment)
    validate_segments(right_segment)
    if #left_segment ~= #right_segment then shapes.error("Segments must have equal numbers of points") end
    validate_vector(normal)
    if type(group) ~= "number" then shapes.error("4th arg: expected number, got "..type(group)) end
    ---Creation---
    local tri = shapes.tri
    for i=1,#left_segment-1,1 do
        local bl = shapes.util.deepcopy(left_segment[i])
        local tl = shapes.util.deepcopy(left_segment[i+1])
        local tr = shapes.util.deepcopy(right_segment[i+1])
        local br = shapes.util.deepcopy(right_segment[i])
        print(i,bl.x,bl.y,bl.z)
        tri(bl,tl,tr,group)
        tri(bl,tr,br,group)
    end

    
end

function shapes.wall(segments, height, texHeight, group)
    ---Validation---
    if type(segments) ~= "table" then shapes.error("Segements is not a table") end
    if #segments < 2 then shapes.error("Segements has fewer than 2 points") end
    local validate_vector = vector.validate_vector
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    if type(height) ~= "number" then shapes.error("2nd arg: expected number, got "..type(height)) end
    if type(texHeight) ~= "number" then shapes.error("2nd arg: expected number, got "..type(texHeight)) end
    if type(group) ~= "number" then shapes.error("3rd arg: expected number, got "..type(group)) end
    ---Creation---
    local quad = shapes.quad
    local function top(v, h, th)
        return vector.new(v.x,v.y+h,v.z,v.nx,v.ny,v.nz,v.tx,v.ty+th)
    end

    for i=1,#segments-1,1 do
        local bl = shapes.util.deepcopy(segments[i])
        local br = shapes.util.deepcopy(segments[i+1])
        local tl = top(bl, height, texHeight)
        local tr = top(br, height, texHeight)
        
        quad(bl,tl,tr,br,group)
    end
end