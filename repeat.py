#this script takes a pair-multiple csv file with two columns, 
#(pitch_con,length of the pitch_con in number of pitch points)
#which is a full length pitch data file with 1220 rows (including header)
#the output is a list of list, m, that holds list pairs that contain 
#[a unique pitch_on, number of points/rows in that pitch contour]
#this output would be used to turn the qTA parameter csv file 
#(in which each pitch contour only has one line of data)
#into a csv file that fully matches the original pitch data file
#with each parameter repeated the correct number of times/rows
#e.g., if a pitch contour has 7 data points, there should be 
#7 rows that bear that particular pitch_con id in the parameter file
#importantly, the data should be sorted by 'order', the last digits of pitch_con_id
#which is different from what "pair.py" generates, in a different order.
#in sum, now, if we extracted the order, we could sort any data list consistently
#but for generate qTA parameters full data file, we also need a single-line 
#csv file with pitch_con and numPoints


from collections import defaultdict
import csv


inputfilename="pair-multiple.csv"

with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    m=[next(reader)]
    l=[m[0][0]]

    k=0

    for row in reader:
    	if row[0]!=l[k]:
    		m.append(row)
    		l.append(row[0])
    		k=k+1

#now m holds the pitch_con and numPoints lists of lists in order
#we can write m to a csv file
with open("repeat.csv","a") as f:
		writer=csv.writer(f)
		for i in range(len(m)):
			writer.writerow(m[i])

