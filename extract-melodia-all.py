#update: first find the first non-zero pitch and then start writing to csv (filter-con)
#this file resides in the same directory as the timestampe file, ismir-paper/documents/melodia/
#extract not 30 point vector, but all pitch values in a contour
#NEED to read: (1)timestamp file, located in ismir-paper/documents/melodia/; (2)pitch track with mbid name.
#have a dictionary: {name, mbid}
#then later another dictionary {time,pitch} using per_label function, and if time>time_start and time<time_end, get the [time,pitch] into a list.
#of course, we first need to use praat to extract from textgrid, writing to a csv that contains [pitch_con,time_start,time_end,artist,roletype,shengqiang,tone], and named with names like DX_E_1. in this file, each role is a pitch_con, has its starting and ending time in the current file (textgrid, vocal-pitch)
from collections import defaultdict
import csv

from itertools import islice

with open("newpitch-all.csv","w") as f:
	writer=csv.writer(f)
	e=["time","pitch","pitch_con","duration","artist","role_type","shengqiang","tone","word"]
	writer.writerow(e)


#mbid={"D_X-1": "61dd663f-77b8-423b-8ce9-4c40fee8b014"}
mbid={"LD_E-2": "67069b89-fe41-4509-9aba-5cc33d9c8e53"}

#mbid={"D_X-1": "61dd663f-77b8-423b-8ce9-4c40fee8b014","D_X-2": "a00666b5-07ef-40c8-8117-78b871569354","D_E-1": "f6339039-e01a-4a70-82ff-001c64fecddd","J_X-1": "bc86b730-b7bb-46ba-a771-2d0e6304b459","J_X-2": "a9896439-46ce-4a37-a6ed-3a5c998bd6cf","J_E-1": "b19d1921-9119-4a57-8c78-540ca09f09b9","J_E-2": "720e93d6-21b5-4026-8c50-5c415cca53ec","LD_X-1": "5593350d-4a2d-4288-b3c6-b57b7f3c8dd4","LD_X-2": "afd9da3d-418b-4dfc-85d4-6d5829b9c7e2","LD_E-1": "f581a2b2-ff94-4e03-91f8-d278b01d6fc4","LD_E-2": "67069b89-fe41-4509-9aba-5cc33d9c8e53","LS_X-1": "cdbf88f4-7a55-412e-b4b2-351f4c8aab49", "LS_X-2": "4a0fc23c-9c62-4b2e-a38a-124796c6ac5d","LS_E-1": "999917df-2282-49d4-ad95-e45d176fba64","LS_E-2": "26054c12-3578-4d64-a251-f8f694fbc41c","XS_X-1":      "e9794b6f-a797-4d7f-842a-a0c73639c2a5","XS_X-2": "206d833f-b194-40cc-92d1-7a632fbef603","XS_E-1": "aec9929b-69b4-4ca5-b998-f4d54ac426cb","XS_E-2": "01661eb4-114d-4671-af82-14b8fead56e1"}


for key in mbid:
    inputfilename='/Users/zangsir/Desktop/ismir_paper/documents/melodia-20aria/'+ key +'.csv'
    pitch_file='/Users/zangsir/Desktop/ubuntu-share/20aria-wav/'+mbid[key]+'.txt'
    print inputfilename

    #each iteration, open one file such as D_X-1.csv
    entries=csv.reader(open(inputfilename,"rU")) 
    next(entries,None)

    #with open(pitch_file) as fin:
    fin=open(pitch_file)
    rows = ( line.split('\t') for line in fin )
    #put all rows in the vocal_pitch file in a dictionary, with time row[0] as the keys, and pitch and confidence as values
    d = { row[0]:row[1:] for row in rows }
    #get rid of header row
    if 'time' in d.keys():
    	del d['time']

    #iterate over pitch contours, each time of the loop one contour
    for raw in entries:
        this=[]
        #currently at one pitch contour, with start and end time
        for key,value in d.iteritems():    
            if float(key)>float(raw[0]) and float(key)<float(raw[1]):
                this.append([key,value[0]])
                #after sort, you get a pitch contour, with time and pitch in a list
        n=len(this)
        k=0
       
        #find the first non-zero value of pitch, k
        while n!=0 and float(this[k][1])==0 and k<n-1:
            k+=1
            #print 'k=',k
        
        if k!=n-1 and n!=0:
            #use x[0],'time', as the key to sort
            this.sort(key=lambda x: x[0])
            for i in range(k,len(this)):
                z=[]
                z.append(float(this[i][0]))
                z.append(float(this[i][1]))
                for j in raw[2:]:
                    z.append(j)
                
                with(open("newpitch-all.csv","a")) as f:
                    writer=csv.writer(f)
                    writer.writerow(z)