#include "mc_lib.h"
#include "mc_lua.h"
#include <iostream>

int main()
{
    // Mesh mesh;
    // mesh.add_quad({
    //         {0,0,0},
    //         {0,0,1},
    //         {1,0,1},
    //         {1,0,0}
    //     }, {
    //         {0,0},
    //         {0,1},
    //         {1,0},
    //         {1,1}
    //     }, 1);

    //mesh.export_mesh("test.obj");
    //mesh.test_export_mesh();

    lua_State* lua = lua_open();  // Open Lua
    luaL_openlibs(lua);
    luaL_dostring(lua, "io.write(\"Hello World\")");
    lua_close(lua);

    return 0;
}