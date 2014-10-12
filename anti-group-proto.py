
from collections import defaultdict
import csv

per_label = defaultdict(list)

#assume this is on desktop, which has another folder named python-script/csv
inputfilename="smoothed-header.csv"

with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    for x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, duration,artist,role_type,shengqiang,tone,word,pitch_con in reader:
        per_label[pitch_con.strip()].append([x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30,duration,artist,role_type,shengqiang,tone,word])