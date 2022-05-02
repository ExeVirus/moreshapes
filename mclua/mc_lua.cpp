#include "mc_lua.h"
#include <iostream>

Mesh& MC_LUA::get_mesh() {
    static Mesh mesh;
    return mesh;
}

int MC_LUA::l_reset_mesh(lua_State* L) {
    get_mesh().reset_mesh();
    return 0; // Count of returned values
}

int MC_LUA::l_export_mesh(lua_State* L) {
    get_mesh().test_export_mesh();
    return 0; // Count of returned values
}

int MC_LUA::l_add_triangle(lua_State* L) {
    int n = lua_gettop(L);
    if(n != 25) {
        luaL_error(L, (("add_triangle(): Too Few arguments provided, expected 25, you gave ")+std::to_string(n)+"\n").c_str() );
    }
    for(int i = 1; i < 26;i++) {
        if( !lua_isnumber(L, i) ) {
            luaL_error(L, (std::string("add_triangle(): Argument ")+std::to_string(i)+" is not a number \n").c_str());
        }
    }
    get_mesh().add_triangle({
        {0,0,0},
        {0,0,1},
        {1,0,0}
    }, {
        {0,0,0},
        {0,0,0},
        {0,0,1}
    }, {
        {0,0},
        {0,1},
        {1,0}
    }, 1);
    return 0; // Count of returned values
}

void MC_LUA::register_functions(lua_State* L)
{
    lua_pushcfunction(L, l_reset_mesh);
    lua_setglobal(L, "reset_mesh");
    lua_pushcfunction(L, l_export_mesh);
    lua_setglobal(L, "export_mesh");
    lua_pushcfunction(L, l_add_triangle);
    lua_setglobal(L, "add_triangle");
}
