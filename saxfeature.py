#this script takes a sax-based file where the a shape like abc is written as a,b,c (csv), and it converts it into 'abc', with no comma, and the new strings are written in a new csv file (only one column) in the current dir.

import csv


inputfilename="/Users/zangsir/Downloads/SAX_2006_ver/SAX_2006_ver/sax-3-3new.csv"

entries=csv.reader(open(inputfilename,"rU")) 
next(entries,None)
a=[]
p=['feature']
with(open("feature3-twothird.csv","w")) as f:
    writer=csv.writer(f)
    writer.writerow(p)
    
for row in entries:
    b=row[0]+row[1]
    if b=='ab' or b=='bc' or b=='ac':
        shape='rise'
    elif b=='ba' or b=='cb' or b=='ca':
        shape='fall'
    elif b=='aa' or b=='bb' or b=='cc':
        shape='flat'
        
    a.append([b,shape])
    

for i in range(len(a)):
    #print a[i]
    with(open("feature3-twothird.csv","a")) as f:
        writer=csv.writer(f)
        writer.writerow(a[i])
    