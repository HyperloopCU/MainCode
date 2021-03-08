#include <iostream>
#include "../BaseSensorHandler.h"

using namespace std; 

int main(){

    BaseAnalogHandler load("1");
    while(1){
        load.run(); 
        cout << load.data << "\n";
    }

    return 0; 
}