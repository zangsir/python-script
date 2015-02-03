#use this script to produce individual pitch tracks, one file per contour
import csv as csv
import numpy as np



csv_file_object = csv.reader(open("./xu_data_qp2/allxu_new.csv", 'rU'))
header = csv_file_object.next()

#this would put a row of data into a list, to see, run the script and type "row" to see how is a row of data represented as a list, with each column as an item in the list 
data = []
#define a dictionary with tone durations (average from Xu 1997)
tone_dur={1:0.247,2:0.273,3:0.349,4:0.214}
#one row is one contour
for row in csv_file_object:
    data=row
    tone=data[-2]
    pitch_con=data[-4]
    step=tone_dur[float(tone)]/30
    timestamp=[0]
    #generate 30 timestamps
    for i in range(1,30):
        timestamp.append(timestamp[i-1]+step)
    #write timestamps and pitch values into one list and later into file
    pitch=data[4:34]
    newlist=[]
    for i in range(30):
        newlist.append([timestamp[i]])
    for i in range(30):
        newlist[i].append(pitch[i])
    #put the pitch_con_id and tone info into one string as the name.later, the name can be used to generate a textgrid of tones sequentially
    outputfilename="/Users/zangsir/Desktop/onecontour/"+tone+pitch_con+".csv"
    #write one header per file
    header=[]
    with open(outputfilename,"w") as f:
        writer=csv.writer(f)
        #writer.writerow(header)
    #write 30 times, each time one timestamp and one pitch value
    for i in range(30):
        z=newlist[i]
        with open(outputfilename,"a") as f:
            writer=csv.writer(f)
            writer.writerow(z)