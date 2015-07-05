import re
from os import listdir


#read all files from this directory
dir= "/Users/zangsir/Desktop/texts/"

onlyfiles = [ f for f in listdir(dir)]



for file in onlyfiles:
    print "processing file:"+file
    filepath=dir+file
    f=open(filepath,"r")
    xs=f.readlines()
    f.close()
    
    newfile="/Users/zangsir/Desktop/cleaned/cleaned_"+file
    g=open(newfile,"w")
    g=open(newfile,"a")
    
    #each line will be handled as one of these cases
    for line in xs:
        #handle <sp who="g"> or <sp who="f">
        identity = re.search(r'<sp who="([^"]+)">', line)   
        if identity:
            s = identity.group() 
            speaker = s[9]
            add="<"+speaker+">"
            g.write(line.rstrip()+"\n")
            g.write(add+"\n")
        #add </g> or </f> after </sp>
        elif line.rstrip()=="</sp>":
            addclose="</"+speaker+">"
            g.write(line.rstrip()+"\n")
            g.write(addclose+"\n")
        #if none of these two cases above, then just write the line without the trailing spaces
        else:
            g.write(line.rstrip()+"\n")
    g.close()
