#include "InputReader.h"

namespace libcpp{

    std::string ReadText(std::string path){
        return "";
    }

    std::vector<std::string> ReadLines(std::string path){
        return {};
    }

    std::vector<std::string> ReadPatterns(std::string path, std::regex pattern){
        return {};
    }

    template<typename T>
    std::vector<T> ReadPatterns(std::string path, std::regex pattern){
        return {};
    }

    std::vector<std::string> ReadPatterns(std::string path, std::string pattern){
        return {};
    }

    template<typename T>
    std::vector<T> ReadPatterns(std::string path, std::string pattern){
        return {};
    }
}
