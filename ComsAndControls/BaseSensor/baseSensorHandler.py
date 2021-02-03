from enum import Enum
from sched import scheduler
from time import time,sleep
from random import randint
from Adafruit_BBIO import GPIO,ADC

class ReadingType(Enum):
    INTERUPT = 0
    ANALOG = 1
    PRUINTERRUPT = 2
    PRUANALOG = 3
    SIMULATE = 4


class BaseSensorHandler(): 
    '''

        Constructs a new Sensor Handler Object 

    '''
    def __init__(self,GPIO_PIN, reading_type,callback,simulateRange=[0,1]):
        '''
        :param GPIO_PIN: string value corresponding to the pin P(PINHEADER)_(PINNUMBER) ex pin header 1 with pin number 36 P1_36
        :param reading_type: ReadingType Enum corresponding to the type of reading the user wants to take (package in the same file)
        :param callback: function to be called with the data the function takes 2 parameters the data value and this object
        :param simulateRange: optional parameter array with 2 elements the first being the lower bound and the second being the upper bound to simulate ranges from
        :return: the object
        '''
        if not isinstance(reading_type,type(ReadingType.SIMULATE)):
            raise ValueError("Invalid reading type")
        self.reading_type = reading_type
        self.simulateRange = simulateRange
        self.callback = callback
        self.cont = True 
        self.GPIO_PIN = GPIO_PIN
        GPIO.setup(self.GPIO_PIN,GPIO.IN)
        self.run()
    

    def turnOfCont(self):
        self.cont = False
        
    def run(self):
        if self.reading_type == ReadingType.SIMULATE:
            self.s = scheduler(time,sleep)
            self.simulateTimer = .1
            self.simulatePriority = 1
            self.timerCreater()
        elif self.reading_type == ReadingType.INTERUPT:
            self.interruptReader()
        elif self.reading_type == ReadingType.ANALOG:
            ADC.setup()
            self.analogReader()
        elif self.reading_type == ReadingType.PRUINTERRUPT:
            self.PRUInterruptReader()
        elif self.reading_type == ReadingType.PRUANALOG:
            self.analogReader()
        else:
            raise ValueError("Invalid reading type")
        
    def interruptReader(self):
        if self.cont:
            GPIO.wait_for_edge(self.GPIO_PIN, GPIO.RISING)
            self.callback(True,self)
            self.interruptReader()
        

    def analogReader(self):
        while self.cont:
            data = ADC.read(self.GPIO_PIN)
            self.callback(data,self)


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
    
    