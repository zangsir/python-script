#this is used to read the column-wise data csv file of pitch contours to expand it into row-wise data file, in which each row has all the pitch values belonging to one particular contour id.

#the input to this should contain one column for normalized pitch value, which should be one of 3: 1.f0_norm; 2.f0_norm_ct;3.f0_norm_bk., these would vary according to their input file: allxu_col_X.csv, where X is: 1.hznorm;2.ctnorm;3.bknorm.

from collections import defaultdict
import csv

per_label = defaultdict(list)

inputfilename="/Users/zangsir/python-script/xu_data_qp2/allxu-col-hznorm.csv"
with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    for Syllable1, Syllable2, time, f0_norm, speaker, pitch_con, syl, tone, prev in reader:
        per_label[pitch_con.strip()].append([Syllable1, Syllable2, time, f0_norm, speaker, syl, tone, prev])

title=[]
#write header row: 1 to 30, then append all other attributes
#there is no time here b/c 1:30 is time, header row
for i in range(1,31):
    title.append(i)
#then append all other desired attributes
title.append("speaker")
title.append("syl")
title.append("tone")
title.append("prev")
title.append("pitch_con")



with open("/Users/zangsir/Desktop/row-yixunorm-hz.csv","w") as f:
    writer=csv.writer(f)
    writer.writerow(title)

#for each key, write all 30 data points as well as other cols, into a csv.
for key in per_label:
    a=[]
    contour=per_label[key]
    #append all 30 pitch
    for i in range(len(contour)):
        a.append(contour[i][3])
    #a.append(contour[i][-1])
    #append other attributes
    for i in range(-4,0):
        a.append(contour[0][i])
    a.append(key)
        
    #ready to write to csv
    with open("/Users/zangsir/Desktop/row-yixunorm-hz.csv","a") as f:
        writer=csv.writer(f)
        writer.writerow(a)