from serial import Serial
from Adafruit_BBIO import UART
from threading import Thread 
import time
import struct

class SerialThreadReader(Thread):
    def __init__(self, threadID, threadName, port, baudrate,UART_digit,msgByteSize, msgCallBack=None):
        Thread.__init__(self)
        self.threadID = threadID
        self.threadName = threadName
        self.msgByteSize = msgByteSize
        self.msgCallBack = msgCallBack
        UART.setup("UART{}".format(UART_digit))
        self.s = Serial(port=port, baudrate=baudrate)
        self.continue_running = True
    
    def run(self):
        while self.continue_running:
            msg = self.s.read(self.msgByteSize)   
            self.s.write(msg)
            if self.msgCallBack is not None and callable(self.msgCallBack):
                self.msgCallBack(msg) 
            else:
                print("The msg is {} - From {}".format(msg.hex(),self.threadName))


class SerialThreadReaderTest(SerialThreadReader):
    def __init__(self, threadID, threadName, port, baudrate,UART_digit,msgByteSize, msgCallBack=None):
        super().__init__(threadID, threadName, port, baudrate,UART_digit,msgByteSize, msgCallBack)
        self.firstMessage = 0
        self.counter = 0
    
    def run(self):
        while self.continue_running:
            msg = self.s.read(self.msgByteSize)
            time_stamp = int(round(time.time() * 1000))
            if self.firstMessage == 0:
                print("First msg {}".format(struct.unpack('Q',msg)[0]))
                self.firstMessage = time_stamp + struct.unpack('Q',msg)[0]
            if self.counter < 10:
                print(struct.unpack('Q',msg)[0]-self.firstMessage)
                self.counter +=1 
            if self.msgCallBack is not None and callable(self.msgCallBack):
                self.msgCallBack(msg,self.threadName,time_stamp-self.firstMessage,self.counter) 
            else:
                print("The msg is {} - From {}".format(msg.hex(),self.threadName,self.firstMessage))


class SerialThreadCorrectTest(SerialThreadReader):
    def __init__(self, threadID, threadName, port, baudrate,UART_digit,msgByteSize, msgCallBack=None):
        super().__init__(threadID, threadName, port, baudrate,UART_digit,msgByteSize, msgCallBack)

    
    def run(self):
        while self.continue_running:
            msg = self.s.read(self.msgByteSize)  
            print(msg) 
            self.s.write(msg)
            




    
    

