#!/usr/bin/python3
import subprocess
import os
import fnmatch
import time
import threading

t1 = None
shutdown_init = False
shutdown_performed = False
shutdown_timeout = 1 * 60

def MyThreadShutdown():
	ellapsed_seconds = 0
	while (ellapsed_seconds < shutdown_timeout) and shutdown_init:
		time.sleep(1)
		ellapsed_seconds = ellapsed_seconds + 1
		print("shutdown running")
	if shutdown_init:
		os.system('sudo shutdown -h now')
		shutdown_performed = True
		
# please check your number of the touchscreen with xinput list    
touchscreen_devices = ["ATML1000:00", "SIS0817:00"]

def find_xinput_dev(devicename):
	result = ""
	try:	
            p = subprocess.Popen(['sudo xinput list | grep ' + devicename], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
            out, err = p.communicate()
            if len(err) == 0:
                    results = fnmatch.filter(str(out.decode('utf8')).split(), 'id=*')
                    print(results)
                    if len(results) >= 1:
                            if len(results) > 1:
                                    print("warn: more than one matches in xinput list for device name " + devicename + ". Using the first match")
                            result = results[0][3:]
                    else:
                            print("warn: no match in xinput list found for device name " + devicename)
            else:
                    print("error: calling xinput(" + err + ")")
	except:
		print("error: + " + str(sys.exc_info()))
		
	return result
	
xinputStr = ""
for dev in touchscreen_devices:
	if xinputStr == "":
		xinputStr = find_xinput_dev(dev)
print(xinputStr)

			
xinput_screen_device = 12

proc = subprocess.Popen(['xinput','test','14'],stdout=subprocess.PIPE)

os.system('xset +dpms')
active = True
while True:
	line = proc.stdout.readline()
	
	if shutdown_performed:
		exit()
	
	#print(line.decode('ascii').strip())
	if line.decode('ascii').strip() == 'key release 133':
		docked = os.path.isdir('/dev/input/by-id')		
		if docked:
			os.system('xdotool key --clearmodifiers ctrl+F8')
			shutdown_init = False
		else:
			if active:
				os.system('xinput disable 12') #13
				os.system('xset dpms force off')
				shutdown_init = True
				print("start thread")
				t1 = threading.Thread(target=MyThreadShutdown, args=[])
				t1.start()
			else:
				os.system('xinput enable 12') #13
				os.system('xset dpms force on')
				shutdown_init = False
				print("abort")
				if t1 != None:
					t1.join()
					t1 = None
			active = not active

