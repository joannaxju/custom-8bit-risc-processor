#ifndef HELPER_H
#define HELPER_H

#include <string>
#include <vector>
using namespace std;

string clean_line(string line);
vector<string> split(const string& line);
string lower_str(string s);
string upper_str(string s);
string bin(int value, int bits);

#endif