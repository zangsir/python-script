import csv as csv
import numpy as np

csv_file_object = csv.reader(open("meng.csv", 'rU'))
header = csv_file_object.next()

data = []
for row in csv_file_object:
    data.append(row)
data = np.array(data)