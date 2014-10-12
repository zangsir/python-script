#this is a prototype that reads in csv file, and group the data by column "pitch_con"
#the output per_label[] is a dictionary, whose keys are pitch_con ids, and 
#value is a list that contains the time,pitch points in the current pitch_con

from collections import defaultdict
import csv

per_label = defaultdict(list)

#assume this is on desktop, which has another folder named python-script/csv
inputfilename="/Users/zangsir/Desktop/ismir_paper/documents/melodia-20aria/d-x-1-all-filtercon.csv"

with open(inputfilename, 'rU') as inputfile:
    reader = csv.reader(inputfile)
    # skip the header row
    next(reader, None)  

    for time, pitch, pitch_con, duration,artist,role_type,shengqiang,tone,word in reader:
        per_label[pitch_con.strip()].append([time.strip(),pitch,duration,artist,role_type,shengqiang,tone,word])