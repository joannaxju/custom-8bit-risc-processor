#include <iostream>
#include <fstream>
#include <vector>
#include <unordered_map>
#include <stdexcept>

#include "constant.h"
#include "helper.h"

using namespace std;

int main(int argc, char* argv[]){
    if(argc != 3){
        cerr << "Usage: ./assembler <source> <destination>\n";
        return 1;
    }

    //open source file
    ifstream fin(argv[1]);
    if(!fin){
        cerr << "Could not open input file\n";
        return 1;
    }

    vector<string> program;
    unordered_map<string, int> labels;
    string line;
    int pc = 0;
    while(getline(fin, line)){
        line = clean_line(line);
        if (line.empty()) continue;
        size_t colon = line.find(':');
        //if is label, track label pc
        if(colon != string::npos){
            string label = clean_line(line.substr(0, colon));
            labels[label] = pc;
            string rest = clean_line(line.substr(colon + 1));
            if (!rest.empty()){
                program.push_back(rest);
                pc++;
            }
        } 
        //if not label just store instruction
        else{
            program.push_back(line);
            pc++;
        }
    }

    vector<string> machine;
    //try and catch mainly use to find bad branch/jump offsets or unknown instructions
    try{
        for(int pc = 0; pc < (int)program.size(); pc++){
            vector<string> p = split(program[pc]);
            if(p.empty())continue;
            //get isntruction
            string op = lower_str(p[0]);
            string code;
            //A: and, xor, add, adc
            if(A_FUNCT.count(op)){
                string r1 = upper_str(p[1]);
                string r2 = upper_str(p[2]);
                code = "000";
                code += REG2.at(r1);
                code += REG2.at(r2);
                code += A_FUNCT.at(op);
            }
            //B: mov, lb, sb, cmp
            else if(B_OPCODE.count(op)){
                string r1 = upper_str(p[1]);
                string r2 = upper_str(p[2]);
                code = B_OPCODE.at(op);
                code += REG3.at(r1);
                code += REG3.at(r2);
            }
            //C: addi
            else if(op == "addi"){
                string reg = upper_str(p[1]);
                int imm = stoi(p[2]);
                code = "101";
                code += REG2_C.at(reg);
                code += bin(imm, 4);
            }
            //D: shl, rlc, shr, rrc
            else if(D_FUNCT.count(op)){
                string reg = upper_str(p[1]);
                code = "110";
                code += D_FUNCT.at(op);
                code += "0";
                code += REG3.at(reg);
            }
            //done
            else if(op == "done"){
                code = "111000000";
            }
            //E: ju, bge
            else if(E_TYPE.count(op)){
                //instruction does not include target label
                if(p.size() < 2) throw runtime_error("Missing operand for " + op);
                int offset;
                string label = p[1];
                //if label does not exist
                if(!labels.count(label)) throw runtime_error("Unknown label: " + label);
                int target = labels[label];
                //ju means PC = PC - offset
                if(op == "ju") offset = pc - target;
                //bge means PC = PC + offset
                else offset = target - pc;
                //check if out of offset range (0 - 31)
                if(offset < 0 || offset > 31) throw runtime_error("Offset out of range at instruction " +
                                                                to_string(pc) + ": " + program[pc] +
                                                                " gives offset " + to_string(offset));
                code = "111";
                code += E_TYPE.at(op);
                code += bin(offset, 5);
            }
            //instruction not part of ISA
            else throw runtime_error("Unknown instruction: " + program[pc]);
            machine.push_back(code);
        }
    }
    catch(const exception& e){
        cerr << "Assembler error: " << e.what() << endl;
        return 1;
    }

    //open destination file
    ofstream fout(argv[2]);
    if(!fout){
        cerr << "Could not create machine_code.txt\n";
        return 1;
    }

    for(const string& code : machine) fout << code << "\n";

    cout << "\nDONE\n";
    return 0;
}