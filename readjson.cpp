#include<iostream>
#include<fstream>
#include<string>

using namespace std;

int main(){
    ifstream input;
    input.open("D:\\Program_set\\project_zike\\C-B0024-001.json",ios::in);
    string line;
    while (getline(input , line))
    {
        cout << line <<endl;
    }

    input.close();
    
}