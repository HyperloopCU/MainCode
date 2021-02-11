import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir) 
from baseAnalogSensor import BaseAnalogHandler


count = 0

def stop():
    global count
    count +=1
    if count > 20:
        return True
    return False

sensor = BaseAnalogHandler("P1_35",stop,True)