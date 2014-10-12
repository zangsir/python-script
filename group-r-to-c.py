#this script converts the row-wise data file back to column wise data file for analysis in R
from collections import defaultdict
import csv

per_label = defaultdict(list)

#assume this is on desktop, which has another folder named python-script/csv
inputfilename="/Users/zangsir/Downloads/smoothed-norm.csv"

with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    #for x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, duration,artist,role_type,shengqiang,tone,word,pitch_con in reader:
     #   per_label[pitch_con.strip()].append([x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30,duration,artist,role_type,shengqiang,tone,word])
     #yi xu data
     for Syllable1,Syllable2,Normtime, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60, speaker,pitch_con in reader:
          per_label[pitch_con.strip()].append([x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30,x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50, x51, x52, x53, x54, x55, x56, x57, x58, x59, x60,Syllable1,Syllable2,Normtime,speaker])
        
        
#write header
title=[]
title.append("time")
title.append("pitch")
title.append("duration")
title.append("artist")
title.append("role_type")
title.append("shengqiang")
title.append("tone")
title.append("word")
title.append("pitch_con")

with open("smoothed-col.csv","w") as f:
    writer=csv.writer(f)
    writer.writerow(title)
    
    
for key in per_label:
    a=per_label[key][0]
    for i in range(30):
        z=[]
        pitch=a[i]
        #write time, pitch, and then a[-6:0]
        z.append(i+1)
        z.append(pitch)
        #append all the other attributes, after time and pitch
        for j in range(-6,0):
            z.append(a[j])
        z.append(key)
        with open("smoothed-col.csv","a") as f:
            writer=csv.writer(f)
            writer.writerow(z)
        
        
        
        
        
        
        
        
        
        
        