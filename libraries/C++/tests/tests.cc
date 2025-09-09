#include <gtest/gtest.h>

#include "../InputReader.h"
#include <regex>
#include <string>
#include <map>
#include <vector>

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

TEST(Reading, Lines){
  auto result = ReadLines(files["Fulltext"]);
  std::vector<std::string> exp{"hello","world"};
  EXPECT_EQ(result, exp);
}

TEST(Reading, MoreLines){
  auto result = ReadLines(files["numbers"]);
  std::vector<std::string> exp{"1 4 3 7 5 1", "1 2 4 7 8 5", "8 6 0 2 2 4", "5 9 3 8 4 0"};
  EXPECT_EQ(result,exp);
}

TEST(Reading, Regexp){
  auto result = ReadPatterns(files["numbers"], std::regex{"[0-9]"});
  std::vector<std::string> exp{"1", "4", "3", "7", "5", "1", "1", "2", "4", "7", "8", "5", "8", "6", "0", "2", "2", "4", "5", "9", "3", "8", "4", "0"};
  EXPECT_EQ(result,exp);
}

TEST(Reading, EmptyRegexp){
  auto result = ReadPatterns(files["numbers"], std::regex{""});
  std::vector<std::string> exp{};
  EXPECT_EQ(result,exp);
}

TEST(Reading, TypedRegexp){
  std::vector<int> result = ReadPatterns<int>(files["numbers"], std::regex{"[0-9]"});
  std::vector<int> exp{1, 4, 3, 7, 5, 1, 1, 2, 4, 7, 8, 5, 8, 6, 0, 2, 2, 4, 5, 9, 3, 8, 4, 0};
  EXPECT_EQ(result,exp);
}

TEST(Reading, StringRegexp){
  auto result = ReadPatterns(files["numbers"], "[0-9]");
  std::vector<std::string> exp{"1", "4", "3", "7", "5", "1", "1", "2", "4", "7", "8", "5", "8", "6", "0", "2", "2", "4", "5", "9", "3", "8", "4", "0"};
  EXPECT_EQ(result,exp);
}

/**
 * Main function
 */
int main(int argc, char* argv[]) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
