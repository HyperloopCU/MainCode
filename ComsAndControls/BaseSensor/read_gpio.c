#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#define DEFAULT_PIN "27"

int readPin(char *pin) {
	int res;
	char val, path[100];
	sprintf(path, "/sys/class/gpio/gpio%s/value", pin);
	FILE *fp = fopen(path,"r");
	val = fgetc(fp);
	res = atoi(&val);
	fclose(fp);
	return res;
}

int main(int argc, char *argv[]) {
	//1st arg: pin #
	//2nd arg: # millis
	clock_t start = clock(), diff;
	int time_ms=0,last=0,count=0; 	
	char pin[3];
	int samp_time; //sample time in millis
	if (argc == 3) {
		strcpy(pin, argv[1]);
	}
	else {
		strcpy(pin, DEFAULT_PIN);
	}
	samp_time = atoi(argv[argc-1]);
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
	printf("%i",count); 
}

