#this polyfit script is modeled after polyfit-new.py, it takes the new csv file with 30point data vector, and tone attribute for Xu's data

#Here we adopt a simpler design, not to use column wise data as in spring 2014 (that was dictacted mostly by my early days of doing things which is always column wise data from praat script and ran in R. here we get from Xu a row-wise dataset, and it is less expensive to process this format)

#the goal of preprocessing is to use csv reader to read in the row of data, put one contour into an array of 30 tuples of (time,pitch), which time is {1,2,...,30}. and pass this array/list to the polyfit in numpy. then we use this to polyfit and output the desired data file with additional attributes like pitch-con, tone, and so on.

#there is no need for per_label, but a need for plain csv reader, refer to csv-reader.py for demo
#this would take an input file of 30 point plus any attributes column, row-wise data file


#this one is bark based
from collections import defaultdict
import csv
import numpy as np
import matplotlib.pyplot as plt

#per_label = defaultdict(list)
inputfilename="./xu_data_qp2/allxu_new.csv"

#write to the output file header
with open("newfile-bark.csv","w") as f:
    writer=csv.writer(f)
    e=["1st","2nd","3rd","4th","speaker","pitch_con","syl","tone","prevsyl",]
    writer.writerow(e)

#read input file 
csv_file_object = csv.reader(open(inputfilename, 'rU'))
header = csv_file_object.next()

#this would put a row of data into a list, to see, run the script and type "row" to see how is a row of data represented as a list, with each column as an item in the list 
data = []

for row in csv_file_object:
    #read in one row of data and put in data list, in this case would be the 30 point of pitch plus whatever attributes col.
    #there are 39 cols in this csv file of allxu_new.csv
    data=row[4:34]
    
    #we want to output time (1,2,...,30) and pitch into b for polyfit, and then extract any additional attributes to append to zz final list	    
    b=[]
    for i in range(1,31):
    	b.append([i])
    for i in range(30):
        ##########convert to bark
        f0=float(data[i])
        #print(f0)
        f0_bark=7*np.math.log(f0/650 + np.sqrt(1+(f0/650)**2))
        b[i].append(f0_bark)
        #print(f0_bark)
#here I tried  dividing data[i] by 10 above, to hopefully scale the polyfit values in a more similar range by drawing closer time(10^1) and pitch(10^2) orders of magnitude, but it's worse than original 
    curve=np.array(b)
    x=curve[:,0]
    y=curve[:,1]
    z=np.polyfit(x,y,3)
    zz=z.tolist()
    
    #now we have zz that contains the 4 parameters of polyfit, copied from z
    #next we append last five attributes:"speaker","pitch_con","syl","tone","prevsyl"
    for i in range(-5,0):
        zz.append(row[i])



    with open("newfile-bark.csv","a") as f:
        writer=csv.writer(f)
        writer.writerow(zz)



