local util = {}

function util.copy(orig)
    local orig_type = type(orig)
    local copyit
    if orig_type == 'table' then
        copyit = {}
        for orig_key, orig_value in next, orig, nil do
            copyit[util.copy(orig_key)] = util.copy(orig_value)
        end
        setmetatable(copyit, util.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copyit = orig
    end
    return copyit
end

util.inspect = dofile("lua_api/lib/inspect.lua")

function util.error(string)
    print(debug.traceback())
    error("---->" .. string)
end

function util.istable(v)
    return type(v) == "table"
end

function util.isnumber(v)
    return type(v) == "number"
end

return util