#this polyfit script is new. takes the new csv file with 30point data vector, and columns for duration and mean_f0 of the pitch contour

from collections import defaultdict
import csv
import numpy as np
import matplotlib.pyplot as plt

per_label = defaultdict(list)
inputfilename="./csv/adult-mean-30.csv"

with open("newfile.csv","w") as f:
    writer=csv.writer(f)
    e=["1st","2nd","3rd","pitch","pitch_con","tone","sort","duration","mean_f0"]
    writer.writerow(e)

with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    for time, pitch, pitch_con,duration,mean_f0 in reader:
        per_label[pitch_con.strip()].append([time.strip(), pitch.strip(),duration,mean_f0])


for key in per_label:
    b=[]
    #time originally in unit of second, *1000 is ms, but here is sth in between to make the parameter values reasonable
    for i in range(len(per_label[key])):
        b.append([(float(per_label[key][i][0])-float(per_label[key][0][0]))/10])
    for i in range(len(b)):
        b[i].append(float(per_label[key][i][1]))
    #duration=b[-1][0]*100
    #print(str('d='+str(duration)))
    curve=np.array(b)
    x=curve[:,0]
    y=curve[:,1]
    z=np.polyfit(x,y,3)
    zz=z.tolist()
    zz.append(key)
    name,tone,number=key.split("_")
    zz.append(tone)
    zz.append(number)
    #zz.append(duration)
	#to plot the curve
	#f=np.poly1d(z)
	#x_new=np.linspace(x[0],x[-1],50)
	#y_new=f(x_new)
	#plt.plot(x,y,'o',x_new,y_new)
	#plt.xlim([x[0]-0.001,x[-1]+0.001])
	#plt.show()	

	#append zz to columns of a csv file
    contour=per_label[key]
    #append all 30 pitch
    #a.append(contour[i][-1])
    #append other attributes
    for i in range(-2,0):
        zz.append(contour[0][i])
    #a.append(key)

    with open("newfile.csv","a") as f:
        writer=csv.writer(f)
        writer.writerow(zz)



