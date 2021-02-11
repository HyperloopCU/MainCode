import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir) 
from baseInterruptHandler import MultiInterruptHandler


multiINterrupts = MultiInterruptHandler(["P1_36","P1_35"],20,3,True)










