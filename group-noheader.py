#saves a row-wise csv data file to the downloads, for matlab processing fastsmooth.m
#this is used to read the column-wise data csv file of pitch contours to expand it into row-wise data file, in which each row has all the pitch values belonging to one particular contour id.

from collections import defaultdict
import csv

per_label = defaultdict(list)


#assume this is on desktop, which has another folder named python-script/csv
inputfilename="newpitch.csv"
with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    for time, pitch, pitch_con, duration,artist,role_type,shengqiang,tone,word in reader:
        per_label[pitch_con.strip()].append([time.strip(),pitch,duration,artist,role_type,shengqiang,tone,word])

title=[]
#write header row: 1 to 30
for i in range(1,31):
    title.append(i)

with open("/Users/zangsir/Downloads/newfile-noheader.csv","w") as f:
    writer=csv.writer(f)
    writer.writerow(title)

#for each key, write all 30 data points as well as role_type, etc., into a csv.
for key in per_label:
    a=[]
    contour=per_label[key]
    #append all 30 pitch
    for i in range(len(contour)):
        a.append(contour[i][1])    
        
    #ready to write to csv
    with open("/Users/zangsir/Downloads/newfile-noheader.csv","a") as f:
        writer=csv.writer(f)
        writer.writerow(a)