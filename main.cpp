#include "mc_lib.h"
#include "mc_lua.h"
#include <iostream>

int main(int argc, char** argv)
{
    if(!parseInputs(argc, argv)) return 0;

    lua_State* lua = lua_open();  // Open Lua
    luaL_openlibs(lua);
    MC_LUA::register_functions(lua);

    if(luaL_dofile(lua, "run.lua")) {
        std::cerr << "-- " << lua_tostring(lua, -1) << std::endl;
        lua_pop(lua, 1);
    };
    
    lua_close(lua);

    return 0;
}