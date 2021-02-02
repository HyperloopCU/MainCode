from enum import Enum
from threading import Thread

class ReadingType(Enum):
    INTERUPT = 0
    ANALOG = 1
    PRUINTERRUPT = 3
    PRUANALOG = 4


class BaseSensorHandler(Thread): 
    def __init__(self,threadID, threadName,GPIO_PIN, reading_type,simulate=False):
        Thread.__init__(self)
        self.threadID = threadID
        self.threadName = threadName
        # check reading type is valid 
        if reading_type > 4 or reading_type < 0:
            raise ValueError("Invalid reading type")
        self.reading_type = reading_type
        if not isinstance(simulate,bool):
            raise ValueError("Invalid simulating type")
        self.simulate = simulate
        
    def run(self):
        if self.reading_type == ReadingType.INTERUPT:
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
        pass 
    def analogReader(self):
        pass

    def PRUInterruptReader(self):
        pass
    def PRUAnalogReader(self):
        pass