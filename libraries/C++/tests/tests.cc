#include <gtest/gtest.h>

#include "../InputReader.h"
#include <regex>
#include <string>
#include <map>

using namespace libcpp;

std::map<std::string, std::string> files{
    {"Fulltext", "../testFiles/fulltext.txt"},
    {"numbers", "../testFiles/numbers.txt"},
    {"integers", "../testFiles/integers.txt"},
    {"hiddenIntegers", "../testFiles/hiddenIntegers.txt"}
};

/**
 * InputReader tests
 */

TEST(Reading, Fulltext){
    std::string result = ReadText(files["Fulltext"]);
    EXPECT_EQ(result, "hello\nworld");
}

int main(int argc, char* argv[]) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
