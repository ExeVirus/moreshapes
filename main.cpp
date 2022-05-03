#include "mc_lib.h"
#include "mc_lua.h"
#include <iostream>
#include <string>

int main(int argc, char** argv)
{
    std::string filename = parseInputs(argc, argv);
    if(filename == "") return 0;

    lua_State* lua = lua_open();  // Open Lua
    luaL_openlibs(lua);
    MC_LUA::register_functions(lua);
    //load lua library
    if(luaL_dofile(lua, "lua_api/init.lua")) {
        std::cerr << lua_tostring(lua, -1) << std::endl;
        lua_pop(lua, 1);
    };

    if(luaL_dofile(lua, filename.c_str())) {
        std::cerr << lua_tostring(lua, -1) << std::endl;
        lua_pop(lua, 1);
    };
    
    lua_close(lua);
    system("PAUSE");

    return 0;
}