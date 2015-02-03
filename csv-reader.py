import csv as csv
import numpy as np

csv_file_object = csv.reader(open("./xu_data_qp2/xunorm_new.csv", 'rU'))
header = csv_file_object.next()

#this would put a row of data into a list, to see, run the script and type "row" to see how is a row of data represented as a list, with each column as an item in the list 
data = []
for row in csv_file_object:
    data.append(row)
    
#if you need to convert to numpy array then do this
#data = np.array(data)