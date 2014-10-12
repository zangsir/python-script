from collections import defaultdict
import csv
import numpy as np
import matplotlib.pyplot as plt

per_label = defaultdict(list)
inputfilename="./csv/shuo.csv"

with open("newfile-norm.csv","w") as f:
    writer=csv.writer(f)
    e=["1st_norm","2nd_norm","3rd_norm","pitch","pitch_con","tone","sort"]
    writer.writerow(e)

with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    for time, pitch, pitch_con in reader:
        per_label[pitch_con.strip()].append([time.strip(), pitch.strip()])


for key in per_label:
    b=[]
    for i in range(len(per_label[key])):
        b.append([(float(per_label[key][i][0])-float(per_label[key][0][0]))*10])
    for i in range(len(b)):
        b[i].append(float(per_label[key][i][1]))
    #normalizing duration
    c=[[b[0][0]]]
    for i in range(len(b)-1):
        c.append([c[i][0]+((b[i+1][0]-b[i][0])/b[-1][0])])
    
    for i in range(len(c)):
        c[i].append(b[i][1])
    
    
    curve=np.array(c)
    x=curve[:,0]
    y=curve[:,1]
    z=np.polyfit(x,y,3)
    zz=z.tolist()
    zz.append(key)
    name,tone,number=key.split("_")
    zz.append(tone)
    zz.append(number)
	#to plot the curve
	#f=np.poly1d(z)
	#x_new=np.linspace(x[0],x[-1],50)
	#y_new=f(x_new)
	#plt.plot(x,y,'o',x_new,y_new)
	#plt.xlim([x[0]-0.001,x[-1]+0.001])
	#plt.show()	

	#append zz to columns of a csv file


    with open("newfile-norm.csv","a") as f:
        writer=csv.writer(f)
        writer.writerow(zz)



