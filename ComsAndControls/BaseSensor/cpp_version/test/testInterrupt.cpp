#include <iostream>
#include "../BaseSensorHandler.h"

using namespace std;

int main() {

	int sum = 0,iter=5;
	int errors[iter];
	int samp_time = 1000; 
	
	for(int i = 0; i<iter;i++){
        BaseInterruptHandler sensor("23");
		clock_t start = clock(), diff;
		int time_ms=0;	
		while(time_ms < samp_time) {	
			sensor.run(); 
			diff = clock() - start;
			time_ms = diff*1000.0/CLOCKS_PER_SEC;
		}
		errors[i] = sensor.count-300 > 1 ? sensor.count-300:300-sensor.count; 
		sum += errors[i];
	}
    cout << "After running " << iter << " times " << sum << " total errors were found with an average of " << sum/iter <<"\n";
	for(int i = 0; i<iter;i++){
		cout << errors[i] << "\n"; 
	}
	return 0; 
}