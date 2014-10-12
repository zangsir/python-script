#this script converts the row-wise data file back to column wise data file for analysis in R
#this script is modified for Xu's data
#in the original version, we count the whole contour syl1+syl2 (mama) as a single pitch contour, with 60 point long and a single pitch con id. 
#now, the modified version generates them as two separate contours, with distinct pitch con ids and with 30 point long vector
from collections import defaultdict
import csv

per_label = defaultdict(list)

#assume this is on desktop, which has another folder named python-script/csv
inputfilename="/Users/zangsir/Desktop/allxud_file.csv"

with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)
    for Syllable1,Syllable2,Normtime,X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22,X23,X24,X25,X26,X27,X28,X29,X30,X31,X32,X33,X34,X35,X36,X37,X38,X39,X40,X41,X42,X43,X44,X45,X46,X47,X48,X49,X50,X51,X52,X53,X54,X55,X56,X57,X58,X59,X60,speaker,pitch_con in reader:
          per_label[pitch_con.strip()].append([X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15, X16, X17, X18, X19, X20, X21, X22, X23, X24, X25, X26, X27, X28, X29, X30, X31, X32, X33, X34, X35, X36, X37, X38, X39, X40, X41, X42, X43, X44, X45, X46, X47, X48, X49, X50, X51, X52, X53, X54, X55, X56, X57, X58, X59, X60, Syllable1,Syllable2,Normtime,speaker])

#write header
title=[]
title.append("time")
title.append("pitch")
title.append("Syllable1")
title.append("Syllable2")
title.append("Normtime")
title.append("speaker")
title.append("pitch_con")

with open("smoothed-col-yixud.csv","w") as f:
    writer=csv.writer(f)
    writer.writerow(title)
    
    
for key in per_label:
    #a is a list from a list of list of length 1
    a=per_label[key][0]
    for i in range(60):
        z=[]
        pitch=a[i]
        #write time, pitch, and then a[-6:0]
        if i<30:
            z.append(i+1)
            z.append(pitch)
        #separate out the second syllable as another contour
        else:
            k=i-30
            z.append(k+1)
            z.append(pitch)
        #append all the other attributes, after time and pitch
        for j in range(-4,0):
            z.append(a[j])
        if i<30:
            z.append(key+"_1")
        else:
            z.append(key+"_2")
        with open("smoothed-col-yixud.csv","a") as f:
            writer=csv.writer(f)
            writer.writerow(z)
        
        
        
        
        
        
        
        
        
        
        
        