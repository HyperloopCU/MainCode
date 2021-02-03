from Adafruit_BBIO import GPIO
from baseSensorHandler import BaseSensorHandler,ReadingType

class BaseInterruptHandler:
    '''
    
    Basic class to handel general interrupts

    '''

    def __init__(self,GPIO_PIN,stop_reading,simulate=False):
        self.GPIO_PIN = GPIO_PIN
        self.stop_reading = stop_reading
        self.count = 0
        self.sensor_reader = BaseSensorHandler(self.GPIO_PIN,ReadingType.INTERUPT if not simulate else ReadingType.SIMULATE,self)
        self.sensor_reader.run()

    
    def callback(self,data):
        print("callback has run ")
        self.count += 1
        if self.count >= 20:
            self.sensor_reader.turnOff()


class MultiInterruptHandlerHelper(BaseInterruptHandler):
    def __init__(self,GPIO_PIN,stop_reading,simulate=False);
        super().__init__(GPIO_PIN,stop_reading,simulate)
    

    def callback(self,data):
        print("callback has run ")
        self.count += 1
        if self.count >= 20:
            self.sensor_reader.turnOff()


class MultiInterruptHandler():
    def __init__(self,GPIO_PINS,stop_reading,simluate=False):
        self.GPIO_PINS = GPIO_PINS
        self.stop_reading = stop_reading
        self.simulate = simulate

        # Implement code to thread the different MultiInterrupt Handler Helpers and compare their results




        
