#module: this utility breaks a line of character into lines that are at most 90 characters long, and it returns the resulting lines as a list of strings. this is part of addline-R.py for parsing and modifying r files in order to compile into pdf notebook in R studio (knitr)

#regular expression module import 
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
        #if case 2, nst is a list; if case 1, we also made it return a list, so the result returned is always a list containing 1 or more string elements
        nst=breakline(st[k:])
        for i in range(len(nst)):
            newst.append(nst[i]) 
        return newst
            
            
