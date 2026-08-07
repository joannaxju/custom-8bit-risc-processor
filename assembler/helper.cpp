#include "helper.h"
#include <sstream>
#include <stdexcept>
#include <cctype>

string clean_line(string line) {
    //remove comments
    size_t comment = line.find('#');
    if(comment != string::npos) line = line.substr(0, comment);
    //replace , with space to parse easier later
    for(char& c : line) if (c == ',') c = ' ';
    //clear other whitespace character
    size_t start = line.find_first_not_of(" \t\r\n");
    if(start == string::npos) return "";
    size_t end = line.find_last_not_of(" \t\r\n");
    return line.substr(start, end - start + 1);
}

vector<string> split(const string& line) {
    //parse into tokens
    stringstream ss(line);
    vector<string> parts;
    string token;
    while (ss >> token) parts.push_back(token);
    return parts;
}

string lower_str(string s) {
    for(char& c : s) c = tolower(c);
    return s;
}

string upper_str(string s) {
    for(char& c : s) c = toupper(c);
    return s;
}

string bin(int value, int bits) {
    //convert dec to binary
    string out;
    for(int i = bits - 1; i >= 0; i--) out += ((value >> i) & 1) ? '1' : '0';
    return out;
}