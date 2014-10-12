from collections import defaultdict
import csv

per_label = defaultdict(list)

inputfilename="meng.csv"

with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    for time, pitch, pitch_con in reader:
        per_label[pitch_con.strip()].append([time.strip(), pitch])