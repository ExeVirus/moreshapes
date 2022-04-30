#include "mc_lib.h"
#include <iostream>

bool Mesh::add_quad(double3x4 in_verticies, double2x4 in_tex_coords, uint64_t group)
{
    return
        add_triangle(
            double3x3({ in_verticies[0], in_verticies[3], in_verticies[1] }),
            double2x3({ in_tex_coords[0], in_tex_coords[3], in_tex_coords[1] }),
            group) &&
        add_triangle(
            double3x3({ in_verticies[2], in_verticies[1], in_verticies[3] }),
            double2x3({ in_tex_coords[2], in_tex_coords[1], in_tex_coords[3] }),
            group);
}

bool Mesh::export_mesh(char* filename) const
{
    std::string filename_str = filename;
    return export_mesh(filename_str);
}

bool Mesh::add_triangle(double3x3 in_verticies, double2x3 in_tex_coords, uint64_t group)
{
    faces.resize(std::max(faces.size(), group)); //ensure group vector is large enough
    faces[group - 1].push_back(Face(
        vert(in_verticies[0]),
        vert(in_verticies[1]),
        vert(in_verticies[2]),
        tex(in_tex_coords[0]),
        tex(in_tex_coords[1]),
        tex(in_tex_coords[2])
    ));
    return true;
}

uint64_t Mesh::vert(const double3& vertex)
{
    auto rounded = vertex * 1000 + 0.5; //shift decimal right three, add 0.5, then truncate to int - to round.
    uint64_t3 lookup{ u64(rounded.x), u64(rounded.y), u64(rounded.z) };
    auto found_vertex = vertex_map.find(lookup);
    if (found_vertex != vertex_map.end()) {
        return found_vertex->second; //reuse
    }
    else {
        verticies.push_back(vertex);
        vertex_map.insert(std::make_pair(lookup, verticies.size()));
    }
    return verticies.size();
}

uint64_t Mesh::tex(const double2& uv)
{
    auto rounded = uv * 1000 + 0.5; //shift decimal right three, add 0.5, then truncate to int - to round.
    uint64_t2 lookup{ u64(rounded.x), u64(rounded.y)};
    auto found_uv = uv_map.find(lookup);
    if (found_uv != uv_map.end()) {
        return found_uv->second; //reuse
    }
    else {
        uv_coords.push_back(uv);
        uv_map.insert(std::make_pair(lookup, uv_coords.size()));
    }
    return uv_coords.size();
}

bool Mesh::export_mesh(std::string& filename) const
{
    std::ofstream meshfile(filename, std::ios::out);
    if (meshfile.is_open()) {
        for (auto & vertex : verticies)
            write_vertex(vertex, meshfile);
        for (auto & uv : uv_coords)
            write_uv(uv, meshfile);
        for (int i = 0; i < faces.size(); i++) {
            meshfile << "g " << i + 1 << std::endl;
            for (auto & face : faces[i])
                write_face(face, meshfile);
        }
        meshfile.close();
        return true;
    }
    error("Unable to open file: " + filename);
    return false;
}

bool Mesh::test_export_mesh() const
{
    for (auto & vertex : verticies)
        write_vertex(vertex, std::cout);
    for (auto & uv : uv_coords)
        write_uv(uv, std::cout);
    for (int i = 0; i < faces.size(); i++) {
        std::cout << "g " << i + 1 << std::endl;
        for (auto & face : faces[i])
            write_face(face, std::cout);
    }
    return true;
}

void Mesh::write_vertex(const double3& vertex, std::ostream& file) const
{
    file << "v " << vertex.x << " " << vertex.y << " " << vertex.z << std::endl;
}

void Mesh::write_uv(const double2& uv, std::ostream& file) const
{
    file << "vt " << uv.x << " " << uv.y << std::endl;
}

void Mesh::write_face(const Face& face, std::ostream& file) const
{
    file << "f " <<
        face.v.x << "/" << face.vt.x << " " <<
        face.v.y << "/" << face.vt.y << " " <<
        face.v.z << "/" << face.vt.z << " " << std::endl;
}

void Mesh::error(const std::string& error) const
{
    std::cout << error << std::endl;
}