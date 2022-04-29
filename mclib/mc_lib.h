#include <vector>
#include <unordered_map>
#include <string>
#include <cstdint>
#include <fstream>
#include "linalg.h"

using namespace linalg::aliases;

class Mesh {
    public:
        bool add_triangle(double3x3 in_verticies, double2x3 in_tex_coords, uint64_t group); //provided in counter-clockwise winding, group numbers start at 1, not 0.
        bool add_quad(double3x4 in_verticies, double2x4 in_tex_coords, uint64_t group); // provided in "bottom left, top left, top right, bottom right" order
        bool export_mesh(char* filename) const; //will append .obj to the file for you, if omitted
        bool export_mesh(std::string& filename) const; //will append .obj to the file for you, if omitted
        bool test_export_mesh() const;

    protected:
        typedef linalg::vec<uint64_t, 3> uint64_t3;
        typedef linalg::vec<uint64_t, 2> uint64_t2;

        struct Face {
            Face(uint64_t v1, uint64_t v2, uint64_t v3, uint64_t vt1, uint64_t vt2, uint64_t vt3) : v{ v1, v2, v3 }, vt{ vt1, vt2 , vt3 } {}
            linalg::vec<uint64_t, 3> v;
            linalg::vec<uint64_t, 3> vt;
        };
        void error(const std::string& error) const;
        uint64_t vert(const double3& vertex);
        uint64_t tex(const double2& uv);
        void write_vertex(const double3& vertex, std::ostream& file) const;
        void write_uv(const double2& uv, std::ostream& file) const;
        void write_face(const Face& face, std::ostream& file) const;
        uint64_t u64(double& d) { return static_cast<uint64_t>(d); }

        std::vector<double3> verticies;
        std::unordered_map<uint64_t3, uint64_t> vertex_map; //each double is represented as an int, with 1 == 0.001 (3 decimal precision)
        std::vector<double2> uv_coords;
        std::unordered_map<uint64_t2, uint64_t> uv_map; //each double is represented as an int, with 1 == 0.001 (3 decimal precision)
        std::vector<std::vector<Face>> faces; //first index is group number
};