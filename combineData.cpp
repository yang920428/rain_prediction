#include<fstream>
#include<stdio.h>
#include<string>

using namespace std;

int main(){
    FILE* output = fopen("D:\\Program_set\\project_zike\\NumOnly\\totalnumdata.txt", "w");
    for (int i=0 ; i<28 ; i++){
        ifstream input ;
        input.open("D:\\Program_set\\project_zike\\NumOnly\\numOnly_"+to_string(i)+".txt",ios::in);
        float pre, tem, wet, wind, rain, sun;
        while (input >> pre >> tem >> wet >> wind >> rain >> sun)
        {
            fprintf(output,"%.1f %.1f %.1f %.1f %.1f %.1f\n",pre, tem, wet, wind, rain, sun);
        }
        input.close();
    }

    fclose(output);
    return 0;
}