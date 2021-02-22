#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#define DEFAULT_PIN "23"

int readPin(char *pin) {
	int res;
	char val, path[100];
	sprintf(path, "/sys/class/gpio/gpio%s/value", pin);
	FILE *fp = fopen(path,"r");
	val = fgetc(fp);
	res = atoi(&val);
	fclose(fp);
	if(res > 1){
		// printf("Did I even run?\n"); 
		// printf("%i\n",res); 
		res = 0; 
		printf("hello sup\n"); 

	}
	return res;
}

int main(int argc, char *argv[]) {
	//1st arg: pin #
	//2nd arg: # millis
	int sum = 0,iter=5;
	int errors[iter];
	char pin[3];
	int samp_time; //sample time in millis
	if (argc == 3) {
		strcpy(pin, argv[1]);
	}
	else {
		strcpy(pin, DEFAULT_PIN);
	}
	samp_time = atoi(argv[argc-1]);

	for(int i = 0; i<iter;i++){
		clock_t start = clock(), diff;
		int time_ms=0,last=0,count=0; 	
		while(time_ms < samp_time) {	
			if (readPin(pin)==1) {
				//increment count on rising edge
				if (!last) {
					last=1;
					count++;
				}
			}
			else {
				last=0; //reset last on falling edge
			}
			diff = clock() - start;
			time_ms = diff*1000.0/CLOCKS_PER_SEC;
		}
		errors[i] = count-300 > 1 ? count-300:300-count; 
		sum += errors[i];
	}
	printf("after running %i times %i total errors were found making the average error %i",iter,sum,sum/iter); 
	for(int i = 0; i<iter;i++){
		printf("%i\n",errors[i]);
	}
	return 0; 
}

