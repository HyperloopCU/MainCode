#include <iostream>
#include <fstream>
#include <string>
#include <list> 
#include "BaseSensorHandler.h"

using namespace std; 


BaseSensorHandler::BaseSensorHandler(string GPIO_PIN,enum ReadingType readingType){
    this->GPIO_PIN = GPIO_PIN; 
    this->readingType = readingType;
    last = 0;
    count = 0; 
    switch(this->readingType){
        case INTERUPT:{
            string path = "/sys/class/gpio/gpio" + GPIO_PIN + "/direction";
            ofstream dFile(path); 
            dFile << "in\n"; 
            dFile.close(); 
        } 
            break;
        case ANALOG:
            break; 
        default:
            cout << "Not Implemented\n";
    }
}

void BaseSensorHandler::store(int data){
    if(data)
        count++; 
}

void BaseSensorHandler::store(double data){
    this->data = data; 
}

int BaseSensorHandler::readPin() {
    string path = "/sys/class/gpio/gpio" + GPIO_PIN + "/value";
    ifstream vFile(path); 
    string val; 
    getline(vFile,val); 
    try{
        int res = stoi(val);
        if (res != 1)
            res = 0;
        vFile.close();  
        return res; 
    } catch (const invalid_argument& ia) {
        return 0; 
  }
  return 0; 
}

int BaseSensorHandler::checkInterrupt(void){
    int val = readPin(); 
    if(val != last){
        last = val; 
        store(val);
        return val; 
    }
    return 0; 
}

double BaseSensorHandler::checkAnalog(void){
    string path = "/sys/bus/iio/devices/iio:device0/in_voltage" + GPIO_PIN + "_raw"; 
    ifstream vFile(path);
    string val; 
    getline(vFile,val);
    try{
        int res = stoi(val);
        double mappedValue = (double)(map(res,50,4100,0,180))/100.00; 
        //double mappedValue = res; 
        store(mappedValue);
        return mappedValue;  
    } catch (const invalid_argument& ia){
        return 0; 
    }
    return 0; 
}

void BaseSensorHandler::run(void){
    switch(readingType){
        case INTERUPT:
            checkInterrupt(); 
            break;
        case ANALOG:
            checkAnalog(); 
            break;
        default:
            cout << "Not Implemented\n";
            
    }
}



