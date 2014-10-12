#this is used to read the column-wise data csv file of pitch contours to expand it into row-wise data file, in which each row has all the pitch values belonging to one particular contour id.

from collections import defaultdict
import csv

per_label = defaultdict(list)

inputfilename="/Users/zangsir/Desktop/allxu-col.csv"
with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    for time, f0_norm, Syllable1, Syllable2, Normtime, speaker, pitch_con in reader:
        per_label[pitch_con.strip()].append([time,f0_norm,Syllable1,Syllable2,Normtime,speaker])

title=[]
#write header row: 1 to 30
for i in range(1,31):
    title.append(i)
title.append("Syllable1")
title.append("Syllable2")
title.append("Normtime")
title.append("speaker")
title.append("pitch_con")

with open("/Users/zangsir/Desktop/newfile-yixunorm.csv","w") as f:
    writer=csv.writer(f)
    writer.writerow(title)

#for each key, write all 30 data points as well as role_type, etc., into a csv.
for key in per_label:
    a=[]
    contour=per_label[key]
    #append all 30 pitch
    for i in range(len(contour)):
        a.append(contour[i][1])
    #a.append(contour[i][-1])
    #append other attributes
    for i in range(-4,0):
        a.append(contour[0][i])
    a.append(key)
        
    #ready to write to csv
    with open("/Users/zangsir/Desktop/newfile-yixunorm.csv","a") as f:
        writer=csv.writer(f)
        writer.writerow(a)