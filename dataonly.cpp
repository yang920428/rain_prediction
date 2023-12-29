#include<fstream>
#include<string>
#include<iostream>

using namespace std;

int main(){
    for (int i=0 ; i<28 ; i++){
        ifstream input;
        input.open("D:\\Program_set\\project_zike\\stationdata\\station_"+to_string(i)+".txt" , ios::in);
        ofstream output;
        output.open("D:\\Program_set\\project_zike\\NumOnly\\numOnly_"+to_string(i)+".txt" , ios::out);
        string time , winddir;
        float pressure,temper,wet,wind;
        string rain,sun;
        while (input >> time >> pressure >> temper >> wet >> wind >> winddir >> rain >> sun)
        {
            if (sun == "None") continue;
            if (rain == "T"){
                output << pressure << " " << temper << " " << wet << " " << wind << " " << 0 << " " << stof(sun) << endl;
            }
            else{
                output << pressure << " " << temper << " " << wet << " " << wind << " " << stof(rain) << " " << stof(sun) << endl;
            }
        }
        input.close();
        output.close();
    }
    return 0;
}