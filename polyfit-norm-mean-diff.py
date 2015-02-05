#the revision history of this script should be read from top to bottom, with the bottom entry the newest modification

#this polyfit script is new. copied from polyfit-new.py,which takes the new input csv file with 30point data vector, and columns for duration and mean_f0 of the pitch contour. the only difference in this is that, in that one, duration can't be computed from time,and was thus included in the input csv. but in this one, input csv doesn't include duration, and we compute the duration like in the original polyfit-tone.py. in the csv file that is read in, it has four columns, time, pitch, pitch_con, mean_f0. originally the input file name is, addult-diff-raw-mean.csv.

#notice that this one does not really take 30 point vectors as input file, I don't know what is the history of this script, but each contour vector in this input file certainly has its own length and distinctive timestamps, which is entirely different from 30 point vectors which is just 1 to 30 in time stamp column. this comment is written in Dec 2014

#time, pitch, pitch_con, mean_f0 4 cols in input csv file 

#created and modified may13 2014

#modified in Nov 2014 for the QP2, using Xu's data from Gauthier 2007

#in this new modification, we don't care about duration or mean pitch, they are not available in the XU's data.we can use the 30-point pitch vector to extract polyfit parameters.in the original csv file to be read, it is a column-wise representation with raw samples (each contour has different length, with their original time stamps). but in our new task, we only have Xu's 30-point data, there is no time stamps.this should be easier. we should probably write a new script that is based on polyfit-new.py.

#for duration, we don't need it since Xu's data is designed to be equal length so that duration is not a concern. also we can think about pitch height.

from collections import defaultdict
import csv
import numpy as np
import matplotlib.pyplot as plt

per_label = defaultdict(list)
inputfilename="./csv/adult-diff-raw-mean.csv"

with open("newfile.csv","w") as f:
    writer=csv.writer(f)
    e=["1st","2nd","3rd","pitch","pitch_con","tone","sort","duration","mean_f0"]
    writer.writerow(e)

with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    for time, pitch, pitch_con,mean_f0 in reader:
        per_label[pitch_con.strip()].append([time.strip(), pitch.strip(),mean_f0])


for key in per_label:
    b=[]
    #time originally in unit of second, *1000 is ms, but here we chose something in between to make the parameter values reasonable
    for i in range(len(per_label[key])):
        b.append([(float(per_label[key][i][0])-float(per_label[key][0][0]))*10])
    for i in range(len(b)):
        b[i].append(float(per_label[key][i][1]))
    duration=b[-1][0]*100
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
    zz.append(duration)
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
    #append other attributes, in this case, mean_f0
    for i in range(-1,0):
        zz.append(contour[0][i])
    #a.append(key)

    with open("newfile.csv","a") as f:
        writer=csv.writer(f)
        writer.writerow(zz)



