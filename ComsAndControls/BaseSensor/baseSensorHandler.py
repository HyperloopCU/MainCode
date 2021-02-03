from enum import Enum
from sched import scheduler
from time import time,sleep
from random import randint
from Adafruit_BBIO import GPIO

class ReadingType(Enum):
    INTERUPT = 0
    ANALOG = 1
    PRUINTERRUPT = 2
    PRUANALOG = 3
    SIMULATE = 4


class BaseSensorHandler(): 
    def __init__(self,GPIO_PIN, reading_type,callback,simulateRange=[0,1]):
        # check reading type is valid 
        if not isinstance(reading_type,type(ReadingType.SIMULATE)):
            raise ValueError("Invalid reading type")
        self.reading_type = reading_type
        self.simulateRange = simulateRange
        self.callback = callback
        self.cont = True 
        self.GPIO_PIN = GPIO_PIN
        GPIO.setup(self.GPIO_PIN,GPIO.IN)
        self.run()
        
    def run(self):
        if self.reading_type == ReadingType.SIMULATE:
            self.s = scheduler(time,sleep)
            self.simulateTimer = .1
            self.simulatePriority = 1
            self.timerCreater()
        elif self.reading_type == ReadingType.INTERUPT:
            
            self.interruptReader()
        elif self.reading_type == ReadingType.ANALOG:
            self.analogReader()
        elif self.reading_type == ReadingType.PRUINTERRUPT:
            self.PRUInterruptReader()
        elif self.reading_type == ReadingType.PRUANALOG:
            self.analogReader()
        else:
            raise ValueError("Invalid reading type")
        
    def interruptReader(self):
        GPIO.add_event_detect(self.GPIO_PIN, GPIO.RISING)
        def recursive_reader(self):
            if self.cont:
                if GPIO.event_detected: 
                    self.callback(True,self)
                    recursive_reader(self)
        recursive_reader(self)

    def analogReader(self):
        raise NotImplementedError 


    def PRUInterruptReader(self):
        raise NotImplementedError 


    def PRUAnalogReader(self):
        raise NotImplementedError 

    
    def simulate(self):
        rand = randint(self.simulateRange[0],self.simulateRange[1])  # Maybe I should add 2 decimal places or someting but it will prob just be 0,255 
        self.callback(rand,self)
        self.timerCreater()


    def timerCreater(self):
        if self.cont:
            self.s.enter(self.simulateTimer,self.simulatePriority,self.simulate)
            self.s.run() 