from baseSensorHandler import BaseSensorHandler,ReadingType

class BaseAnalogHandler():
    def __init__(self,GPIO_PIN,stop_reading,simulate):
        self.GPIO_PIN = GPIO_PIN
        self.simulate = simulate
        self.data = 0
        self.stop_reading = stop_reading
        self.sensor_reader = BaseSensorHandler(self.GPIO_PIN,ReadingType.ANALOG if not simulate else ReadingType.SIMULATE,self,[0,1.8])
        self.sensor_reader.run()
    
    def callback(self,data):
        self.data = data 
        print(self.data)
        if self.stop_reading():
            self.sensor_reader.turnOff()




    