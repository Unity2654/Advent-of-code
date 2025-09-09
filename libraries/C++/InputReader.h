#ifndef INPUTREADER_H
#define INPUTREADER_H

#include <vector>
#include <string>
#include <regex>

namespace libcpp {

    /**
     * Reads the entiere input from a file and returns it as a string
     */
    std::string ReadText(std::string path);

    /**
     * Reads the input line per line and stores it in an array
     */
    std::vector<std::string> ReadLines(std::string path);

    /**
     * Reads the complete input, and find the strings that matches the pattern given in parameters
     */
    std::vector<std::string> ReadPatterns(std::string path, std::regex pattern);

    /**
     * Similar to the function above, but the pattern is given as a string to avoid including regex
     */
    std::vector<std::string> ReadPatterns(std::string path, std::string pattern);

    //// Template implementations ////

    /**
     * Templated function of ReadPatterns that attempts to convert elements in the given type
     */
    template<typename T>
    std::vector<T> ReadPatterns(std::string path, std::regex pattern){
        return {};
    };

    /**
     * Templated function of the overload of ReadPatterns that attempts to convert elements in the given type
     */
    template<typename T>
    std::vector<T> ReadPatterns(std::string path, std::string pattern){
        return {};
    }
}


#endif
