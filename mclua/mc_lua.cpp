#include "mc_lua.h"
#include "lua.h"
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
    int n = lua_gettop(L);
    if(n != 1 && n != 2) {
        luaL_error(L, (("export_mesh(): Wrong number of arguments provided, expected 1 string or 1 string and a boolean, you gave ")+std::to_string(n)+" arguments.\n").c_str() );
    }
    if( !lua_isstring(L, 1) ) {
        luaL_error(L, std::string("export_mesh(): Argument 1 is not a string \n").c_str());
    }
    bool export_normals = true;
    if( n==2 && !lua_isboolean(L, 2)) {
        luaL_error(L, std::string("export_mesh(): Argument 2 is not a boolean \n").c_str());
    } else if(n == 2) {
        export_normals = lua_toboolean(L, 2);
    }
    std::string filename = luaL_checkstring(L, 1);
    std::ofstream testfile(filename, std::ios::out);
    if(!testfile.is_open()) {
        luaL_error(L, (filename + " is invalid and cannot be opened.").c_str());
        return 0;
    }else{
        testfile.close();
    }
    get_mesh().export_mesh((char *)filename.c_str(), export_normals);
    return 0; // Count of returned values
}

int MC_LUA::l_add_triangle(lua_State* L) {
    int n = lua_gettop(L);
    if(n != 25) {
        luaL_error(L, (("add_triangle(): Wrong number of arguments provided, expected 25, you gave ")+std::to_string(n)+"\n").c_str() );
    }
    for(int i = 1; i < 26;i++) {
        if( !lua_isnumber(L, i) ) {
            luaL_error(L, (std::string("add_triangle(): Argument ")+std::to_string(i)+" is not a number \n").c_str());
        }
    }
    get_mesh().add_triangle({
        {lua_tonumber(L, 1),lua_tonumber(L, 2),lua_tonumber(L, 3)},
        {lua_tonumber(L, 4),lua_tonumber(L, 5),lua_tonumber(L, 6)},
        {lua_tonumber(L, 7),lua_tonumber(L, 8),lua_tonumber(L, 9)},
    }, {
        {lua_tonumber(L, 10),lua_tonumber(L, 11),lua_tonumber(L, 12)},
        {lua_tonumber(L, 13),lua_tonumber(L, 14),lua_tonumber(L, 15)},
        {lua_tonumber(L, 16),lua_tonumber(L, 17),lua_tonumber(L, 18)},
    }, {
        {lua_tonumber(L, 19),lua_tonumber(L, 20)},
        {lua_tonumber(L, 21),lua_tonumber(L, 22)},
        {lua_tonumber(L, 23),lua_tonumber(L, 24)},
    }, lua_tonumber(L, 25));
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
