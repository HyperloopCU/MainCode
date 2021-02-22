from baseSensorHandler import BaseSensorHandler,ReadingType
from threading import Thread 
from datetime import datetime,timedelta

class BaseInterruptHandler:
    '''
    
    Basic class to handel general interrupts

    '''

    def __init__(self,GPIO_PIN,stop_reading,simulate=False):
        self.GPIO_PIN = GPIO_PIN
        self.stop_reading = stop_reading
        self.simulate = simulate
        self.count = 0
        self.sensor_reader = BaseSensorHandler(self.GPIO_PIN,ReadingType.INTERUPT if not simulate else ReadingType.SIMULATE,self)
        self.setup()
        

    def setup(self):
        self.sensor_reader.run()

    
    def callback(self,data):
        # print("callback has run ")
        if self.count == 0:
            self.time = datetime.now()
        self.count += 1
        if datetime.now() - timedelta(seconds=5) >= self.time:
            self.sensor_reader.turnOff()
            print(self.count)


class MultiInterruptHandlerHelper(BaseInterruptHandler):
    def __init__(self,parent_handler,GPIO_PIN):
        super().__init__(GPIO_PIN,parent_handler.stop_reading,parent_handler.simulate)
        self.parent_handler = parent_handler
    

    def callback(self,data):
        # print("callback has run ")
        if self.count == 0:
            self.time = datetime.now()
        self.count += 1
        self.parent_handler.checkDifference()
        if datetime.now() - timedelta(seconds=5) >= self.time:
            self.sensor_reader.turnOff()
            print(self.count)

            
    def setup(self):
        pass


class MultiInterruptHandler():
    def __init__(self,GPIO_PINS,stop_reading,threshold,simulate=False):
        self.GPIO_PINS = GPIO_PINS
        self.stop_reading = stop_reading
        self.simulate = simulate
        self.threshold = threshold
        self.sensors = [MultiInterruptHandlerHelper(self,PIN) for PIN in self.GPIO_PINS]
        print("sensors created ")
        self.threads = [Thread(target=sensor.sensor_reader.run) for sensor in self.sensors]
        print("threads made")
        for thread in self.threads:
            thread.start()
            # thread.join()
        # for thread in self.threads:
        #     thread.join()


    def checkDifference(self):
        arr = [sensor.count for sensor in self.sensors]
        n = len(arr)
        maxDiff = -1
      # https://www.geeksforgeeks.org/maximum-difference-between-two-elements/

        maxRight = arr[n - 1]  
    
        for i in range(n - 2, -1, -1): 
            if (arr[i] > maxRight): 
                maxRight = arr[i] 
            else: 
                diff = maxRight - arr[i] 
                if (diff > maxDiff): 
                    maxDiff = diff 
        
        if maxDiff >= self.threshold:
            print("ESTOP {} and {}".format(arr[0],arr[1]))
        # else: 
        #     print("Value is fine {} and {}".format(arr[0],arr[1]))
        #     print(datetime.now())




        
