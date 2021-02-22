import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir) 
from baseInterruptHandler import BaseInterruptHandler


multiINterrupts = BaseInterruptHandler("P8_10",20)










