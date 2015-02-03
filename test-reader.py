#this is a test reader for group-xu.py
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