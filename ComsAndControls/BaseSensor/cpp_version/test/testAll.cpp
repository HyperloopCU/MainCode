#include <iostream>
#include <string> 
#include <fstream> 
#include "../BaseSensorHandler.h"

using namespace std;

int main() {
    BaseInterruptHandler fid1("23");
    BaseInterruptHandler fid2("26");
    BaseAnalogHandler load("1");
    BaseAnalogHandler pnumatic("3");

    int time_ms = 0; 

    int samp_time = 1000;
    clock_t start = clock(), diff;
    while(time_ms < samp_time) {	
			fid1.run(); 
			fid2.run();
			load.run(); 
			pnumatic.run();



			diff = clock() - start;
			time_ms = diff*1000.0/CLOCKS_PER_SEC;
    }

    cout << "fid 1 is " << fid1.count << " and fid2 is " << fid2.count << "\n";
    cout << "length of load " << load.data.size() << "\n"; 
    string path = "./data.csv";
    ofstream file(path); 
    for(auto v: load.data){
        
        file << v << ","; 
    }
    file << "\n";
    file.close();         

    return 0; 
}
