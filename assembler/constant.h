#ifndef CONSTANT_H
#define CONSTANT_H

#include <string>
#include <unordered_map>
using namespace std;

const unordered_map<string, string> REG2 = {
    {"R1","00"}, {"R2","01"}, {"RL","10"}, {"RM","11"}
};

const unordered_map<string, string> REG3 = {
    {"R1","000"}, {"R2","001"}, {"R3","010"}, {"R4","011"},
    {"R5","100"}, {"R6","101"}, {"R7","110"}, {"R8","111"}
};

const unordered_map<string, string> REG2_C = {
    {"R1","00"}, {"R2","01"}, {"R3","10"}, {"R4","11"}
};

const unordered_map<string, string> A_FUNCT = {
    {"and","00"}, {"xor","01"}, {"add","10"}, {"adc","11"}
};

const unordered_map<string, string> B_OPCODE = {
    {"mov","001"}, {"lb","010"}, {"sb","011"}, {"cmp","100"}
};

const unordered_map<string, string> D_FUNCT = {
    {"shl","00"}, {"rlc","01"}, {"shr","10"}, {"rrc","11"}
};

const unordered_map<string, string> E_TYPE = {
    {"ju","0"}, {"bge","1"}
};

#endif