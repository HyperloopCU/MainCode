from ../baseSensorHandler import BaseSensorHandler,ReadingType

count = 0

def callback(data,sh):
    global count
    print(data)
    count+=1
    if count >= 20:
        sh.turnOff()


sh = BaseSensorHandler("P1_35",ReadingType.SIMULATE,callback)



