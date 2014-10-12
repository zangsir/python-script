#NEED to read: (1)timestamp file, located in ismir-paper/documents/melodia/; (2)pitch track with mbid name.
#extract 30 point vector, not all pitch values in a contour

#have a dictionary: {name, mbid}
#then later another dictionary {time,pitch} using per_label function, and if time>time_start and time<time_end, get the [time,pitch] into a list.
#of course, we first need to use praat to extract from textgrid, writing to a csv that contains [pitch_con,time_start,time_end,artist,roletype,shengqiang,tone], and named with names like DX_E_1. in this file, each role is a pitch_con, has its starting and ending time in the current file (textgrid, vocal-pitch)
from collections import defaultdict
import csv
import math
from itertools import islice

with open("newpitch.csv","w") as f:
    writer=csv.writer(f)
    e=["time","pitch","pitch_con","duration","artist","role_type","shengqiang","tone","word"]
    writer.writerow(e)


def take(n, iterable):
    "Return first n items of the iterable as a list"
    return list(islice(iterable, n))

#when called, 'this' list is passed as the list, which contains only the timestamps and the pitches for the contour
def normalize(list,n):
    newlist=[]
    #print 'len(list)=',n
    k=0
    #get the first point of k where k!=0
    while float(list[k][1])==0 and k<n-1:
        k+=1
    #print "k=",k   
    #push further the first sampling point to rule out spurious artifacts by instrumental sound
    k=k+80
    #if k=n-1, all pitch points are zero
    if k!=n-1:
        hopsize=(n-k)/38
        #write all pitches at first (zero and non-zero); then look at the whole list, and replace zero-pitch with the mean of its neighbors;
        #write the 30 points
        for i in range(30):
            #if float(list[k][1])!=0:
            #strategy to prevent out of index for k
            if check==1:
                print "k=",k
                print "value=",list[k]
            if k<n:
                newlist.append(list[k])
                k=k+hopsize
        #newlist contains only 30 point of the contour, instead of 'list', which contains all points from all frames
        #now to replace the zero values
        #print "len_newlist=",len(newlist)
        count=0
        #if check==1:
         #  print "hopsize=",hopsize
        for n,j in enumerate(newlist):
            if float(j[1])==0:
                count+=1
                if n>0 and n<len(newlist)-1:
                    newlist[n][1]=(float(newlist[n-1][1])+float(newlist[n+1][1]))/2
                elif n==0:
                    newlist[n][1]=float(newlist[n+1][1])
                elif n==len(newlist)-1:
                    newlist[n][1]=float(newlist[n-1][1])
        #if the zero count is greater than 3, then it returns an empty list, which has a length of zero, and will not be further processed
        #convert to cents-will not be used here, since in the normalized values, it doesn't make a difference but create troubles in generating same-valued vectors
        #for i in range(len(newlist)):
         #   if float(newlist[i][1])!=0:
          #      a=float(newlist[i][1])/55
           #     newlist[i][1]=1200*math.log(a,2)
        #if the contour is very short, like n=100, then k will start at 80 (if there is no 0s in the beginning), but hopsize will be (100-80)/28=0 in python. therefore it will keep sampling k=80 point for all pitch point. therefore we don't allow hopsize<1 to be included. this kind of contour is too short and the pitch detection is not reliable.
        if count>3 or hopsize<1:
            #print newlist
            newlist=[]            
    return newlist
    

#mbid={"LD_E-2": "67069b89-fe41-4509-9aba-5cc33d9c8e53"}

#mbid={"D_X-1": "61dd663f-77b8-423b-8ce9-4c40fee8b014"}
#mbid={"LS_E-2": "26054c12-3578-4d64-a251-f8f694fbc41c"}

#mbid={"LD_X-1": "5593350d-4a2d-4288-b3c6-b57b7f3c8dd4"}
mbid={"D_X-1": "61dd663f-77b8-423b-8ce9-4c40fee8b014","D_X-2": "a00666b5-07ef-40c8-8117-78b871569354","D_E-1": "f6339039-e01a-4a70-82ff-001c64fecddd","J_X-1": "bc86b730-b7bb-46ba-a771-2d0e6304b459","J_X-2": "a9896439-46ce-4a37-a6ed-3a5c998bd6cf","J_E-1": "b19d1921-9119-4a57-8c78-540ca09f09b9","J_E-2": "720e93d6-21b5-4026-8c50-5c415cca53ec","LD_X-1": "5593350d-4a2d-4288-b3c6-b57b7f3c8dd4","LD_X-2": "afd9da3d-418b-4dfc-85d4-6d5829b9c7e2","LD_E-1": "f581a2b2-ff94-4e03-91f8-d278b01d6fc4","LD_E-2": "67069b89-fe41-4509-9aba-5cc33d9c8e53","LS_X-1": "cdbf88f4-7a55-412e-b4b2-351f4c8aab49", "LS_X-2": "4a0fc23c-9c62-4b2e-a38a-124796c6ac5d","LS_E-1": "999917df-2282-49d4-ad95-e45d176fba64","LS_E-2": "26054c12-3578-4d64-a251-f8f694fbc41c","XS_X-1":      "e9794b6f-a797-4d7f-842a-a0c73639c2a5","XS_X-2": "206d833f-b194-40cc-92d1-7a632fbef603","XS_E-1": "aec9929b-69b4-4ca5-b998-f4d54ac426cb","XS_E-2": "01661eb4-114d-4671-af82-14b8fead56e1"}


for key in mbid:
    inputfilename='/Users/zangsir/Desktop/ismir_paper/documents/melodia-20aria/'+ key +'.csv'
    pitch_file='/Users/zangsir/Desktop/ubuntu-share/20aria-wav/'+mbid[key]+'.txt'
    print inputfilename
    print pitch_file

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
        check=0
        for key,value in d.iteritems():
           # if raw[2]=="1_9_7":
             #   print key,raw[0],raw[1]  
            #    check=1  
            if float(key)>float(raw[0]) and float(key)<float(raw[1]):
                #the list 'this' now holds all time & pitch values of the current pitch contour
                this.append([key,value[0]])
        #if check==1:
         #   print this
          #  print "================="
                #after sort, you get a pitch contour, with time and pitch in a list of lists
        #hop size in pitch track is 0.003s, so at least 60 point will give a minimum duration of 0.18s, which is reasonable. if there are too few point (fewer than 30) it will cause problem, and this way we filter out some too short ones
        if len(this)!=0 and len(this)>60:
			#use x[0],'time', as the key to sort
            this.sort(key=lambda x: x[0])

            this_30=normalize(this,len(this))
            this_30.sort(key=lambda x: x[0])
            #this line selects only 30-point vector. if vector is shorter than 30, then do not write
            if len(this_30)==30:
                #for each pair of [time,pitch] in this contour, write one line csv
                for i in range(len(this_30)):
                    z=[]
                    #append time and pitch
                    z.append(i+1)
                    z.append(float(this_30[i][1]))
                    #append all other attributes
                    for j in raw[2:]:
                        z.append(j)
                    #pitch contour data files written from this script should contain newpitch as the first strings in their names. this is in append mode so pitch tracks from all mbids are written in this one pitch file
                    with(open("newpitch.csv","a")) as f:
                        writer=csv.writer(f)
                        writer.writerow(z)

#In the python script to extract melodia-based pitch contours, we see that there are two options: first, extract all contours but replace those which are 0 with a mean; second, extract and write only the ones that contain all non-zero values. To evaluate the pitch track, we need to compute how many pitch contours contain all zero, or n-zero values. 

#there are two options how to do this:
#first, just write another script to evaluate the contour data in the full dataset extract (that contains all 30-point vectors including 0 values)\
#in this option, all contours are of 30 length. in each contour, a 0 value is replaced by a mean value of the current contour. when you read this in, you need to group into a dictionary with {pitch_con:[pitch values]} structure, and compute the mean of this contour. if a pitch value equals the mean, the chances are it is a 0 valued pitch point originally. 
#however, there is a problem with this approach. because the pitch contour data is a 30-point vector that contains the modified points (zero to nonzero), the mean of this vector is different from the original mean that was computed with zero-values included. so we'll have to go from the original method (next) after all. 


#second, do something in the original script so that each time a 0 pitch value is written, record that.but this way requires to go through all data again so probably too expensive. even if it is just to copy & modify this script in a different script it'll be easier than this.so the first option it is.















