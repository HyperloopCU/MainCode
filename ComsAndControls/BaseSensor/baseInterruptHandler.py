from Adafruit_BBIO import GPIO
from baseSensorHandler import BaseSensorHandler,ReadingType
from threading import Thread 

class BaseInterruptHandler:
    '''
    
    Basic class to handel general interrupts

    '''

    def __init__(self,GPIO_PIN,stop_reading,simulate=False):
        self.GPIO_PIN = GPIO_PIN
        self.stop_reading = stop_reading
        self.count = 0
        self.sensor_reader = BaseSensorHandler(self.GPIO_PIN,ReadingType.INTERUPT if not simulate else ReadingType.SIMULATE,self)
        self.setup()
        

    def setup(self):
        self.sensor_reader.run()

    
    def callback(self,data):
        print("callback has run ")
        self.count += 1
        if self.count >= 20:
            self.sensor_reader.turnOff()
    def setup(self):
        pass 


class MultiInterruptHandlerHelper(BaseInterruptHandler):
    def __init__(self,parent_handler,GPIO_PIN):
        super().__init__(GPIO_PIN,parent_handler.stop_reading,parent_handler.simulate)
        self.parent_handler = parent_handler
    

    def callback(self,data):
        print("callback has run ")
        self.count += 1
        self.parent_handler.checkDifference()
        if self.count >= 20:
            self.sensor_reader.turnOff()


class MultiInterruptHandler():
    def __init__(self,GPIO_PINS,stop_reading,threshold,simluate=False):
        self.GPIO_PINS = GPIO_PINS
        self.stop_reading = stop_reading
        self.simulate = simulate
        self.threshold = threshold
        self.sensors = [MultiInterruptHandler(self,PIN) for PIN in self.GPIO_PINS]
        self.threads = [Thread(target=sensor.run()) for sensor in self.sensors]
        for thread in self.threads:
            thread.join()
        for thread in self.threads:
            thread.start() 
    
    def checkDifference(self):
        arr = [sensor.count for sensor in self.sensorsmaxDiff = -1
        n = len(arr)
      
        # Initialize max element from  
        # right side 
        maxRight = arr[n - 1]  
    
        for i in range(n - 2, -1, -1): 
            if (arr[i] > maxRight): 
                maxRight = arr[i] 
            else: 
                diff = maxRight - arr[i] 
                if (diff > maxDiff): 
                    maxDiff = diff 
        
        if maxDiff >= self.threshold:
            print("ESTOP")
        else: 
            print("Value is fine")




        
