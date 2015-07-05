#read from this directory
#dir= "/Users/zangsir/Desktop/test/"

#onlyfiles = [ f for f in listdir(dir)]


addline='gum<-read.table("~/Downloads/GUM_pos_type.tab",header=TRUE)'

for i in range(4):
    print i
    #print "file:"+file
    #filepath=dir+file
    #f=open(filepath,"r")
    #xs=f.readlines()
    #f.close
    
    newfile="/Users/zangsir/Desktop/target/file_"+str(i)
    print "write to new file "+newfile
    g=open(newfile,"w")
    #g=open(newfile,"a")
    g.write(addline+"\n")
    print "wrote1"
    g.write(addline+str(i)+'this\n')
    print "wrote12"
    
    g.write(addline+str(i)+'that\n')
    print "wrote13"
    
    g.write(addline+str(i)+'these\n')
    print "wrote14"
    g.close()
    
    
    #g.write(xs[0])
    #g.write(xs[1])