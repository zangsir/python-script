#General text file search and editing utility

#this script was developed in need to add one line of code (comment) to insert into all r scripts in a directory
#this line of inserted code is inserted above the line that starts with "boxplot" in the target R files, 
#this insertion is necessary for knitr to position the plots in the right place in the produced pdf documents. 
#the knitr script is meta-grading-knit.R

#this utility is extended to further edit the text.basically a line that is too long is broken into several lines, each with max of 90 chars, conforming to the knitr pdf format. this include a new function breakline() that takes a line and recursively break it into several lines of 90 characters or less.



from os import listdir
import re
            
def breakline(st):
    if len(st)<90:
        #print st
        return [st]
        
    else:
        #print "case2"
        k=89
        #======new regex method: find last occurence k of \W within the first 90 characters, and return st[:k]
        #after the iterations, m holds the last match, use m.start(), m.end(),m.group() to retrieve it
        m=None
        sts=st[:90]
        #notice here if the only non-alphanumeric symbol on this line is the first one ( begin with a hashtag, e.g.), then after the following iteration it finds this char at position 0, so m (and k) is stuck at 0 forever, causing a traceback error reaching max recursion depth
        for m in re.finditer(r"\W",sts):
            pass
        #print "first k=",k
        if m==None or m.start()==0:
            print "WARNING:Cannot find a place to break the line"
            print "WARNING:breaking line at 90"
        else:
            k=m.start()
            
        #=====old method of finding the last whitespace in the first 90 chars, but doesn't work if the line has no space; hence the new method above work more robustly b/c every line should have some sort of non-alphanumeric chars even if it has no whitespace
        #ch=st[k]
       # while ch!=" ":
        #    k=k-1
         #   ch=st[k]
          #  print ch," ",k
        #ch is whitespace; k is the index of that whitespace
        #print st[:k]
       
        newst=[st[:k]]
        #print "second k=",k
        #if case 2, nst is a list; if case 1, we also made it a list
        nst=breakline(st[k:])
        for i in range(len(nst)):
            newst.append(nst[i]) 
        return newst

#read from this directory
dir= "/Users/zangsir/Desktop/sub/"

onlyfiles = [ f for f in listdir(dir)]




for file in onlyfiles:
    print "file:"+file
    filepath=dir+file
    f=open(filepath,"r")
    xs=f.readlines()
    f.close
    
    newfile="/Users/zangsir/Desktop/submission2/"+file
    g=open(newfile,"w")
    g=open(newfile,"a")

    for line in xs:
        if line.lstrip():
            if line.lstrip()[:7]=="boxplot":
                g.write("#+ test-b, fig.width=5, fig.height=5 \n")
                g.write(line)
                print "wrote  to " + line
            else:

                if line.lstrip()[0]=="#":
                    linecon=line.lstrip()[1:]
                else:
                    linecon=line.lstrip()
                a=breakline(linecon)
                #print a
                for i in range(len(a)):
                    if line.lstrip()[0]=="#":
                        z="#"
                        g.write(z)
                    a[i]=a[i]+"\n"
                    g.write(a[i])
            
        
            
