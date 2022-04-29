#include "mc_lib.h"
#include <iostream>

int main()
{
    Mesh mesh;
    mesh.add_quad({
            {0,0,0},
            {0,0,1},
            {1,0,1},
            {1,0,0}
        }, {
            {0,0},
            {0,1},
            {1,0},
            {1,1}
        }, 1);

    mesh.export_mesh("test.obj");
    mesh.test_export_mesh();

    return true;
}