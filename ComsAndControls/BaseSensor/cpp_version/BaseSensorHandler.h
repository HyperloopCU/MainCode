#pragma once
#ifndef BASESENSORHANDLER_H
#define BASESENSORHANDLER_H
#include <iostream>
#include <fstream>
#include <string>

using namespace std; 

enum ReadingType {
    INTERUPT=1,
    ANALOG=2,
    PRUINTERRUPT=3,
    PRUANALOG=4,
};

class BaseSensorHandler {
    protected:
        int simulationRange[2];
        string GPIO_PIN;
        int last; 
        enum ReadingType readingType; 
        void store(int data);
        void store(double data);
    private:
        int readPin(void);
        int map(int x, int in_min, int in_max, int out_min, int out_max) {return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;}
        int checkInterrupt(void);
        double checkAnalog(void);
    public:
        int count; 
        int data; 
        BaseSensorHandler(string GPIO_PIN,enum ReadingType readingType);
        void run(void);

};

class BaseInterruptHandler: public BaseSensorHandler {
    public: 
        BaseInterruptHandler(string pin) : BaseSensorHandler(pin,INTERUPT){  
        }
};

class BaseAnalogHandler: public BaseSensorHandler {
    public: 
        BaseAnalogHandler(string pin) : BaseSensorHandler(pin,ANALOG){  
        }
};





#endif