from baseSensorHandler import BaseSensorHandler,ReadingType
from threading import Thread,Lock
count1 = 0
lock = Lock()

def callback1(data,sh):
    global lock
    with lock:
        global count1
        print("{} data from {}".format(data,sh.GPIO_PIN))
        count1+=1
        if count1 >= 20:
            sh.cont = False 

count2 = 0
def callback2(data,sh):
    global lock
    with lock:
        global count2
        print("{} data from {}".format(data,sh.GPIO_PIN))
        count2+=1
        if count2 >= 20:
            sh.cont = False 

def thread_function(c):
    if c:
        BaseSensorHandler("P1_35",ReadingType.INTERUPT,callback1)
    else:
        BaseSensorHandler("P1_36",ReadingType.INTERUPT,callback2)

t1 = Thread(target=thread_function,args=(True,))
t2 = Thread(target=thread_function,args=(False,))

t1.start()
t2.start()

t1.join()
t2.join()





