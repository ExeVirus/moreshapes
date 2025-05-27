#include "mc_lib.h"
#include <iostream>

bool Mesh::export_mesh(char* filename, bool export_normals) const
{
    std::ofstream meshfile(filename, std::ios::out);
    if (meshfile.is_open()) {
        for (auto & vertex : verticies)
            write_vertex(vertex, meshfile);
        for (auto & uv : uv_coords)
            write_uv(uv, meshfile);
        if(export_normals) {
            for (auto & norm : normal_coords)
                write_normal(norm, meshfile);
        }
        for (int i = 0; i < faces.size(); i++) {
            if(!faces[i].empty()) {
                meshfile << "g " << i + 1 << std::endl;
                for (auto face : faces[i])
                    write_face(face, meshfile, export_normals);
            } else { // empty group, but still needs defined as the next definable or if none are left, break twice, we're done here
                bool noMoreToFill = true;
                for(int j = i; j < faces.size(); j++) {
                    if(!faces[j].empty()) {
                        noMoreToFill = false;
                        meshfile << "g " << i + 1 << std::endl;
                        for(auto face : faces[j]) {
                            write_face(face, meshfile, export_normals); //only get the first face to reduce duplicates
                            break;
                        }
                        break; //found the next one, just break
                    }
                }
                if (noMoreToFill) break;
            }
        }
        meshfile.close();
        return true;
    }
    error("Unable to open file: " + std::string(filename));
    return false;
}

bool Mesh::add_triangle(double3x3 in_verticies, double3x3 in_normal_coords, double2x3 in_tex_coords, uint64_t group)
{
    faces.resize(std::max(faces.size(), group)); //ensure group vector is large enough
    faces[group - 1].push_back(Face(
        vert(in_verticies[0]),
        vert(in_verticies[1]),
        vert(in_verticies[2]),
        uv(in_tex_coords[0]),
        uv(in_tex_coords[1]),
        uv(in_tex_coords[2]),
        norm(in_normal_coords[0]),
        norm(in_normal_coords[1]),
        norm(in_normal_coords[2])
    ));
    return true;
}

int64_t Mesh::vert(const double3& vertex)
{
    //shift decimal right three, add 0.5, then truncate to int - to round.
    int64_t3 lookup{ 
        i64(vertex.x < 0 ? (vertex.x * 1000.0 - 0.5) : (vertex.x * 1000.0 + 0.5)), 
        i64(vertex.y < 0 ? (vertex.y * 1000.0 - 0.5) : (vertex.y * 1000.0 + 0.5)), 
        i64(vertex.z < 0 ? (vertex.z * 1000.0 - 0.5) : (vertex.z * 1000.0 + 0.5))
    };
    auto found_vertex = vertex_map.find(lookup);
    if (found_vertex != vertex_map.end()) {
        return found_vertex->second; //reuse
    }
    else {
        verticies.push_back(lookup);
        vertex_map.insert(std::make_pair(lookup, verticies.size()));
    }
    return verticies.size();
}

int64_t Mesh::uv(const double2& uv)
{
    //shift decimal right three, add 0.5
    int64_t2 lookup{ 
        i64(uv.x < 0 ? (uv.x * 1000.0 - 0.5) : (uv.x * 1000.0 + 0.5)), 
        i64(uv.y < 0 ? (uv.y * 1000.0 - 0.5) : (uv.y * 1000.0 + 0.5))
    };
    auto found_uv = uv_map.find(lookup);
    if (found_uv != uv_map.end()) {
        return found_uv->second; //reuse
    }
    else {
        uv_coords.push_back(lookup);
        uv_map.insert(std::make_pair(lookup, uv_coords.size()));
    }
    return uv_coords.size();
}

int64_t Mesh::norm(const double3& normal)
{
    double3 norm = normalize(normal);
    int64_t3 lookup{ 
        i64(norm.x < 0 ? (norm.x * 1000.0 - 0.5) : (norm.x * 1000.0 + 0.5)), 
        i64(norm.y < 0 ? (norm.y * 1000.0 - 0.5) : (norm.y * 1000.0 + 0.5)), 
        i64(norm.z < 0 ? (norm.z * 1000.0 - 0.5) : (norm.z * 1000.0 + 0.5))
    };
    auto found_normal = normal_map.find(lookup);
    if (found_normal != normal_map.end()) {
        return found_normal->second; //reuse
    }
    else {
        normal_coords.push_back(lookup);
        normal_map.insert(std::make_pair(lookup, normal_coords.size()));
    }
    return normal_coords.size();
}

bool Mesh::test_export_mesh() const
{
    for (auto & vertex : verticies)
        write_vertex(vertex, std::cout);
    for (auto & uv : uv_coords)
        write_uv(uv, std::cout);
    for (auto & norm : normal_coords)
        write_normal(norm, std::cout);
    for (int i = 0; i < faces.size(); i++) {
        std::cout << "g " << i + 1 << std::endl;
        for (auto & face : faces[i])
            write_face(face, std::cout, true);
    }
    return true;
}

void Mesh::write_vertex(const int64_t3& vertex, std::ostream& file) const
{
    file << "v " << d(vertex.x) << " " << d(vertex.y) << " " << d(vertex.z) << std::endl;
}

void Mesh::write_uv(const int64_t2& uv, std::ostream& file) const
{
    file << "vt " << d(uv.x) << " " << d(uv.y) << std::endl;
}

void Mesh::write_normal(const int64_t3& normal, std::ostream& file) const
{
    file << "vn " << d(normal.x) << " " << d(normal.y) << " " << d(normal.z) << std::endl;
}

void Mesh::write_face(const Face& face, std::ostream& file, bool export_normals) const
{
    if(export_normals) {
        file << "f " <<
            face.v.x << "/" << face.vt.x << "/" << face.vn.x << " " <<
            face.v.y << "/" << face.vt.y << "/" << face.vn.y << " " <<
            face.v.z << "/" << face.vt.z << "/" << face.vn.z << " " << std::endl;
    }else{
        file << "f " <<
            face.v.x << "/" << face.vt.x << " " <<
            face.v.y << "/" << face.vt.y << " " <<
            face.v.z << "/" << face.vt.z << " " << std::endl;
    }
}

void Mesh::reset_mesh()
{
    verticies.clear();
    vertex_map.clear();
    uv_coords.clear();
    uv_map.clear();
    normal_coords.clear();
    normal_map.clear();
    faces.clear();
}

void Mesh::error(const std::string& error) const
{
    std::cout << error << std::endl;
}

std::string parseInputs(int argc, char** argv) {
    auto usage = [] {
        std::cout   << "---------morecurves---------"   << std::endl
                    << "usage: "                        << std::endl
                    << "morecurves \"[anyfile].lua\""   << std::endl;
    };
    std::string filename;
    if(argc != 2) {
        usage();
        return "";
    }else {
        filename = (argv[1]);
        if(filename.substr(filename.length()-4) != ".lua")
        {
            std::cout << "error: " << filename << " does not specify a '.lua' file." << std::endl;
            return "";
        };
        std::ifstream testfile(filename, std::ios::in);
        if(!testfile.is_open()) {
            std::cout << filename << " does not exist or cannot be opened." << std::endl;
            return "";
        }else{
            testfile.close();
        }
    }
    return filename;
}