#pragma once

#include "mc_lib.h"

#ifndef __LUA_INC_H__
#define __LUA_INC_H__
extern "C"
{
   #include "lua.h"
   #include "lauxlib.h"
   #include "lualib.h"
}
#endif // __LUA_INC_H__

namespace MC_LUA {

Mesh& get_mesh();

extern "C"
{
   static int l_reset_mesh(lua_State* L);
   static int l_export_mesh(lua_State* L);
   static int l_add_triangle(lua_State* L);
}

void register_functions(lua_State* L);

}
