from Adafruit_BBIO import UART 
from serial import Serial 
import random 
import os

UART.setup("PB-UART2")
data_counter = 0
data_total = 900

with Serial (port="/dev/ttyO2", baudrate=9600) as ser1:
	while data_counter < data_total:
		msg = []
		amount = 3 
		for i in range(amount):
			val = random.randint(0,15)
			msg.append(val)
		msg = bytes(msg)

		print(msg)
		ser1.write(msg)
		msg2 = ser1.read(amount)
		print(msg2)
		if msg2 != msg:
			data_counter = data_total + 100
			#print("not working")
		else:
			data_counter +=1
			#print("{}%".format(int(10000*(data_counter/data_total))/100))

	if data_counter == data_total + 100:
		print('TEST Failed')
	else:
		print("TEST Passed")
