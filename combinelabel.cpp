#include<fstream>
#include<stdio.h>
#include<string>

using namespace std;

int main(){
    FILE* output = fopen("D:\\Program_set\\project_zike\\NumOnly\\totallabel.txt", "a");
    for (int i=0 ; i<28 ; i++){
        ifstream input ;
        input.open("D:\\Program_set\\project_zike\\label\\label_"+to_string(i)+".txt",ios::in);
        int label;
        while (input >> label)
        {
            fprintf(output,"%d\n",label);
        }
        input.close();
    }

    fclose(output);
    return 0;
}