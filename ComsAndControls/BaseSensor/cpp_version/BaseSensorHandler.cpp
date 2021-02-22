#include <iostream>
#include <fstream>
#include <string>
#include "BaseSensorHandler.h"

using namespace std; 



// enum ReadingType {
//     INTERUPT = 0,
//     ANALOG = 1,
//     PRUINTERRUPT = 2,
//     PRUANALOG = 3,
// };

BaseSensorHandler::BaseSensorHandler(string GPIO_PIN,enum ReadingType readingType){
    this->GPIO_PIN = GPIO_PIN; 
    this->readingType = readingType;
    last = 0;
    count = 0; 
    data = 0;              
    switch(this->readingType){
        case INTERUPT:{
            string path = "/sys/class/gpio/gpio" + GPIO_PIN + "/direction";
            ofstream dFile(path); 
            dFile << "in\n"; 
            dFile.close(); 
        }
            break;
        case ANALOG:
            checkAnalog(); 
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
    int res = stoi(val);
    if (res != 1)
        res = 0;
    vFile.close();  
    return res; 
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
    int res = stoi(val);
    return (double)(map(res,2300,3890,0,18))/10.0;  
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


// class BaseSensorHandler {
//     protected:
//         int simulationRange[2];
//         string GPIO_PIN;
//         int last; 
//         enum ReadingType readingType; 

//         void store(int data){
//             if(data)
//                 count++; 
//         }

//         void store(double data){
//             this->data = data; 
//         }

//     private:
//         int readPin() {
//             string path = "/sys/class/gpio/gpio" + GPIO_PIN + "/value";
//             ifstream vFile(path); 
//             string val; 
//             getline(vFile,val); 
//             int res = stoi(val);
//             if (res != 1)
//                 res = 0;
//             vFile.close();  
//             return res; 
//         }

//         int map(int x, int in_min, int in_max, int out_min, int out_max) {
//             return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
//         }

//         int checkInterrupt(void){
//             int val = readPin(); 
//             if(val != last){
//                 last = val; 
//                 store(val);
//                 return val; 
//             }
//             return 0; 
//         }
        
//         double checkAnalog(void){
//             string path = "/sys/bus/iio/devices/iio:device0/in_voltage" + GPIO_PIN + "_raw"; 
//             ifstream vFile(path);
//             string val; 
//             getline(vFile,val);
//             int res = stoi(val);
//             return (double)(map(res,2300,3890,0,18))/10.0;  
//         }

//     public:
//         int count; 
//         int data; 
//         BaseSensorHandler(string GPIO_PIN,enum ReadingType readingType){
//             this->GPIO_PIN = GPIO_PIN; 
//             this->readingType = readingType;
//             last = 0;
//             count = 0; 
//             data = 0;              
//             switch(this->readingType){
//                 case INTERUPT:{
//                     string path = "/sys/class/gpio/gpio" + GPIO_PIN + "/direction";
//                     ofstream dFile(path); 
//                     dFile << "in\n"; 
//                     dFile.close(); 
//                 }
//                     break;
//                 case ANALOG:
//                     checkAnalog(); 
//                     break;
//                 default:
//                     cout << "Not Implemented\n";
//             }
//         }
//         int run(void){
//             switch(readingType){
//                 case INTERUPT:
//                     return checkInterrupt(); 
//                     break;
//                 case ANALOG:
//                     return checkAnalog(); 
//                     break;
//                 default:
//                     cout << "Not Implemented\n";
//                     return 0; 
                    
//             }
//             return 0;
//         }
// };


// class BaseInterruptHandler: public BaseSensorHandler {
//     public: 
//         BaseInterruptHandler(string pin) : BaseSensorHandler(pin,INTERUPT){  
//         }
// };

// class BaseAnalogHandler: public BaseSensorHandler {
//     public: 
//         BaseAnalogHandler(string pin) : BaseSensorHandler(pin,ANALOG){  
//         }
// };

