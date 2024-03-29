#pragma once
#include <vector>
#include <unordered_map>
#include <string>
#include <cstdint>
#include <fstream>
#include "linalg.h"

using namespace linalg::aliases;

class Mesh {
    public:
        bool add_triangle(double3x3 in_verticies, double3x3 in_normal_coords, double2x3 in_tex_coords, uint64_t group); //provided in counter-clockwise winding, group numbers start at 1, not 0.
        bool export_mesh(char* filename, bool export_normals=true) const; //will append .obj to the file for you, if omitted
        void reset_mesh(); //clears all vectors and internal data
        bool test_export_mesh() const;

    protected:
        typedef linalg::vec<int64_t, 3> int64_t3;
        typedef linalg::vec<int64_t, 2> int64_t2;

        struct Face {
            Face(int64_t v1, int64_t v2, int64_t v3, int64_t vt1, int64_t vt2, int64_t vt3, int64_t vn1, int64_t vn2,  int64_t vn3) : v{ v1, v2, v3 }, vt{ vt1, vt2 , vt3 }, vn{ vn1, vn2, vn3 } {}
            linalg::vec<int64_t, 3> v;
            linalg::vec<int64_t, 3> vt;
            linalg::vec<int64_t, 3> vn;
        };
        void error(const std::string& error) const;
        int64_t vert(const double3& vertex);
        int64_t uv(const double2& uv);
        int64_t norm(const double3& normal);
        void write_vertex(const int64_t3& vertex, std::ostream& file) const;
        void write_uv(const int64_t2& uv, std::ostream& file) const;
        void write_normal(const int64_t3& normal, std::ostream& file) const;
        void write_face(const Face& face, std::ostream& file, bool export_normals=true) const;
        int64_t i64(const double& d) const { return static_cast<int64_t>(d); }
        double d(const int64_t& i) const { return (i)/1000.0; }

        std::vector<int64_t3> verticies;
        std::unordered_map<int64_t3, int64_t> vertex_map; //each double is represented as an int, with 1 == 0.001 (3 decimal precision)
        std::vector<int64_t2> uv_coords;
        std::unordered_map<int64_t2, int64_t> uv_map; //each double is represented as an int, with 1 == 0.001 (3 decimal precision)
        std::vector<int64_t3> normal_coords;
        std::unordered_map<int64_t3, int64_t> normal_map; //each double is represented as an int, with 1 == 0.001 (3 decimal precision)
        std::vector<std::vector<Face>> faces; //first index is group number
};

std::string parseInputs(int argc, char** argv);