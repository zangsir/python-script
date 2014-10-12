xu1<-read.csv('~/Desktop/normf0_All1.csv')
xu2<-read.csv('~/Desktop/normf0_All2.csv')
xu3<-read.csv('~/Desktop/normf0_All3.csv')

 xu1[1:10,1:10]
 xu2[1:10,1:10]
 xu3[1:10,1:10]

xu1$Syllable1<-as.factor(xu1$Syllable1)
xu2$Syllable1<-as.factor(xu2$Syllable1)
xu3$Syllable1<-as.factor(xu3$Syllable1)
xu1$Syllable2<-as.factor(xu1$Syllable2)
xu2$Syllable2<-as.factor(xu2$Syllable2)
xu3$Syllable2<-as.factor(xu3$Syllable2)



xu1$speaker<-as.factor("s1")
xu2$speaker<-as.factor("s2")
xu3$speaker<-as.factor("s3")

#get rid of NA values
tail(xu1)
tail(xu2)
tail(xu3)

xu1<-xu1[1:320,]
xu2<-xu2[1:320,]

str(allxu)
str(xu1)
xu1<-droplevels(xu1)

allxu$pitch_con<-"a"
for (i in 1:nrow(allxu)){
	allxu[i,]$pitch_con<-paste(allxu[i,]$Normtime,allxu[i,]$speaker,sep="_")
	
}
str(allxu$pitch_con)

allxu$pitch_con<-as.factor(allxu$pitch_con)
str(allxu)
write.csv(allxu,"~/Desktop/allxu-3speakers.csv")

#try to use s1,s2,s3, individually, and collectively to clsuter
allxu<-read.csv("~/Desktop/xu-analysis/allxu-3speakers.csv")
allxu$Syllable1<-as.factor(allxu$Syllable1)
allxu$Syllable2<-as.factor(allxu$Syllable2)
str(allxu)


#produce a csv file with one syllable per row
allxu[,c(1:33,64,65)]->syl1
head(syl1)
allxu[,c(1:3,34:65)]->syl2
head(syl2)

syl1$syl<-"1"
syl2$syl<-"2"
syl1$syl<-as.factor(syl1$syl)
syl2$syl<-as.factor(syl2$syl)

#pitch_con, first syllable
a="1"
b="2"
syl1$pitch_con<-"a"
for (i in 1:nrow(syl1)){
	syl1[i,]$pitch_con<-paste(syl1[i,]$Normtime,syl1[i,]$speaker,a,sep="_")
	
}
#pitch_con, second syllable
syl2$pitch_con<-"a"
for (i in 1:nrow(syl2)){
	syl2[i,]$pitch_con<-paste(syl2[i,]$Normtime,syl2[i,]$speaker,b,sep="_")
	
}



syl1$pitch_con<-as.factor(syl1$pitch_con)
syl2$pitch_con<-as.factor(syl2$pitch_con)
syl1$tone<-syl1$Syllable1
syl2$tone<-syl2$Syllable2
syl1$tone<-as.factor(syl1$tone)
syl2$tone<-as.factor(syl2$tone)


colnames(syl2)<-colnames(syl1)

syl1$prevsyl<-as.factor("none")
syl2$prevsyl<-syl2$Syllable1
head(syl1)
str(syl1)
str(syl2)

allxu_new<-rbind(syl1,syl2)
write.csv(allxu_new,"~/Desktop/allxu_new.csv")



 













#one speaker
allxu<-allxu[allxu$speaker=="s3",]

#subset to the first syllable, second syllable
allxu[,4:33]->allsyl1
head(allsyl1)
allxu[,34:63]->allsyl2
head(allsyl2)

#cluster with kmeans on original pitch data, no normalization
clust.1<-kmeans(allsyl2,4)
clust.1$cluster->cluster.syl1
cluster.syl1<-as.factor(cluster.syl1)

#data frame for comparing with true labels and for plotting
tone.syl1<-allxu$Syllable1
syl1.clu<-data.frame(cluster.syl1,tone.syl1)
str(syl1.clu)
#visualize cluster
clust.plot<-ggplot(syl1.clu,aes(x=cluster.syl1))
clust.plot+geom_histogram(aes(fill=tone.syl1))+ggtitle("cluster with original pitch values (Hz) syl2 s3")


#confusion matrix
syl1.clu$label<-"1"
syl1.clu[syl1.clu$tone.syl1=="1",]$label<-"1"
syl1.clu[syl1.clu$tone.syl1=="4",]$label<-"2"
syl1.clu[syl1.clu$tone.syl1=="3",]$label<-"3"
syl1.clu[syl1.clu$tone.syl1=="2",]$label<-"4"

confusionMatrix(syl1.clu$cluster.syl1,syl1.clu$label)












################################# N O R M A L I Z A T I O N      O F      P I T C H
#convert this file to col-wise data file using group-r-to-c-xu.py
#read in col-wise data to perform pitch normalization
allxu.col<-read.csv("~/Desktop/python-script/smoothed-col-yixu.csv")
allxu.col$Syllable1<-as.factor(allxu.col$Syllable1)
allxu.col$Syllable2<-as.factor(allxu.col$Syllable2)

#add a first-second syllable feature for 
allxu.col$syl<-"first"
#selecting only the 1st syllable
for (i in 1:length(allxu.col$pitch_con)){
	allxu.col$pitch_con[i]->a
	strsplit(as.character(a),"_")->b
	#print(b)
	if (b[[1]][4]=="2"){
	#	print(b[[1]][4])
		allxu.col$syl[i]<-"second"
		}

}
allxu.col$syl<-as.factor(allxu.col$syl)
#to normalize by speaker, turns out is not right. 
#still, normalize by contour is the way to go.


mtt1<-allxu.col
pcl=levels(mtt1$pitch_con)

#initialize tpc
tpc=mtt1[1,]
#tpc$time<-0
tpc$f0_norm<-0
tpc$f0_cent<-0
tpc$bark<-0
tpc$f0_norm_bk<-0
#time normalization:for each pitch contour, do the normalization
for (j in 1:length(pcl)){
  #cpc is current pitch contour,tpc is the rbind all cpcs(total pitch contours)
  cpc=mtt1[mtt1$pitch_con==pcl[j],]
  #convert to cent
  a=cpc$pitch/55
  cpc$f0_cent=1200*log(a,2)
  
  #convert to bark
  f0=cpc$pitch
  cpc$bark<-7*log(f0/650 + sqrt(1+(f0/650)^2))

  
  #pitch normalization
  mean_f0=mean(cpc$f0_cent)
  mean_f0_bk=mean(cpc$bark)
  #sd_f0=sd(cpc$pitch)
  cpc$f0_norm=cpc$f0_cent-mean_f0
  cpc$f0_norm_bk<-cpc$bark-mean_f0_bk
  tpc=rbind(tpc,cpc)
}
#time normalized now, stored in tpc_t2 for tone 1, etc.minus the very first row (made up)
tpc_t1<-tpc[-1,]
str(tpc_t1)






#show that the original and normalized pitch contours are the same
test<-tpc_t1[1:30,]
par(new=F)
plot(test$time,test$pitch,pch=1,col=1)
par(new=T)
plot(test$time,test$f0_norm,pch=3,col=3)


#R E M E M B E R    TO   S E L E C T    C O L S   T O    W R I T E
#col 9 is f0_norm, or you might choose f0_norm_bark
a<-tpc_t1[,c(1,9,3,4,5,6,7)]
write.csv(a,"~/Desktop/allxu-col.csv",row.names = FALSE)
#converted to row data file, newfile-yixunorm.csv first, modify the colums, then using group-xu.py 
xunorm<-read.csv("~/Desktop/newfile-yixunorm.csv")

xunorm$Syllable1<-as.factor(xunorm$Syllable1)
xunorm$Syllable2<-as.factor(xunorm$Syllable2)
str(xunorm)

#create an attribute that shows whether this row is first or second syllable 30-point vector
xunorm$syl<-"first"
#selecting only the 1st syllable
for (i in 1:length(xunorm$pitch_con)){
	xunorm$pitch_con[i]->a
	strsplit(as.character(a),"_")->b
	#print(b)
	if (b[[1]][4]=="2"){
	#	print(b[[1]][4])
		xunorm$syl[i]<-"second"
		}

}
xunorm$syl<-as.factor(xunorm$syl)
str(xunorm)



#add tone labels
xunorm[xunorm$syl=="first",]->xunorm1
xunorm[xunorm$syl=="second",]->xunorm2
xunorm1$tone<-xunorm1$Syllable1
xunorm2$tone<-xunorm2$Syllable2

xunorm1$prev<-as.factor("none")
xunorm2$prev<-as.factor(xunorm2$Syllable1)

xunorm_new<-rbind(xunorm1,xunorm2)
head(xunorm_new)
write.csv(xunorm_new,"~/Desktop/xunorm_new.csv",row.names=FALSE)
#xunorm_new has tone attributes, xunorm does not

#original dataset (rowwise): xunorm_new

####################C L U S T E R I N G   o n  1  o r    m o r e        s p e a k e r 

#kmeans clustering on syllable 1 with normalized data
head(xunorm_new)

##########################c h o o s e		s p e a k e r
#subset one speaker
xunorm_new[xunorm_new$speaker=="s3",]->xunorm_s1

#or
#no subset, use the whole set 3 speakers
xunorm_s1<-xunorm_new
###########################




######################  	c h o o s e     s y l l a b l e   O r    n o t

#choose the first syllable
xunorm_s1[xunorm_s1$syl=="first",]->xunorm_s1





#O R choose the second syllable:
#choose the second syllable
xunorm_s1[xunorm_s1$syl=="second",]->xunorm_s1
#########################E N D





#subset the numeric vectors for clustering
xunorm_s1[,1:30]->xunormsyl1
head(xunormsyl1)

#xunormsyl1 has only numeric values cols
#cluster kmeans
clust.norm<-kmeans(xunormsyl1,4)

#keep cluster assignment in a variable
clust.norm$cluster->cluster.syl1
cluster.syl1<-as.factor(cluster.syl1)

#keep true tone label to a variable
tone.syl1<-xunorm_s1$tone

#put both in a data frame
syl1.clu<-data.frame(cluster.syl1,tone.syl1)

str(syl1.clu)

######v i s u a l i z e     c l u s t e r s
clust.plot<-ggplot(syl1.clu,aes(x=cluster.syl1))
clust.plot+geom_histogram(aes(fill=tone.syl1))+ggtitle("cluster with normalized pitch (subtract-mean) syl1 s3-bark ")


###########################c o n f u s i o n      M a t r i x
library(caret)
syl1.clu$label<-"1"
syl1.clu[syl1.clu$tone.syl1=="4",]$label<-"1"
syl1.clu[syl1.clu$tone.syl1=="3",]$label<-"2"
syl1.clu[syl1.clu$tone.syl1=="1",]$label<-"3"
syl1.clu[syl1.clu$tone.syl1=="2",]$label<-"4"

confusionMatrix(syl1.clu$cluster.syl1,syl1.clu$label)





##########################C H E C K    O N E     C O N T O U R
#its seems the same data with the same speaker, after normalization of pitch, the clustering doesn't work. let's take s3, with original pitch dataset allxu, and normalized pitch data set xunorm-s1, pick the same contours, see if they look the same. if they are, then it's exactly the same data set, except for the normalization. turns out they are exactly the same shape.  
#pick a pitch contour

xunorm[xunorm$pitch_con=="_LHAB1_s3_1",]->normed
allxu[allxu$pitch_con=="_LHAB1_s3",]->ori

#these are row-wise vectors, we need to put each into one variable
normed[,1:30]->normed_vector
normed_vector<-as.numeric(normed_vector)
normed_vector 
time<-seq(1,30,1)
time
normdata<-data.frame(time,normed_vector)
normdata
#original data has 60 dimensions, we need to also switch those into 30-point vectors

ori
ori[,4:33]->unnormed_vector
unnormed_vector<-as.numeric(unnormed_vector)
unnormed_vector 
time<-seq(1,30,1)
time
oridata<-data.frame(time,unnormed_vector)
oridata





par(new=F)
plot(normdata$time,normdata$normed_vector,pch=1,col=1)
par(new=T)
plot(oridata$time,oridata$unnormed_vector,pch=3,col=3)

#allxu.col is colwise data frame with no normalized pitch, no first-second
#tpc-t1 is colwise data with normalized pitch. 

#is it possible that there are height information in the original pitch values that are lost in normalization?
#tpc_t1 has column wise original data pitch and normalized pitch, normalized by contour
#subset to syllable 1
tpc_syl1<-tpc_t1[tpc_t1$syl=="first",]
tpc_syl2<-tpc_t1[tpc_t1$syl=="second",]
#ad hoc assignment of tone: break them into two parts syl1 and syl2 parts and recombine them
tpc_syl1$tone<-tpc_syl1$Syllable1
tpc_syl2$tone<-tpc_syl2$Syllable2

tpc_t1_new<-rbind(tpc_syl1,tpc_syl2)

#one speaker, first syllable
tpc_syl1_s1<-tpc_syl1[tpc_syl1$speaker=="s1",]
tpc_syl1_s2<-tpc_syl1[tpc_syl1$speaker=="s2",]
tpc_syl1_s3<-tpc_syl1[tpc_syl1$speaker=="s3",]
tpc_syl2_s1<-tpc_syl1[tpc_syl2$speaker=="s1",]
tpc_syl2_s2<-tpc_syl1[tpc_syl2$speaker=="s2",]
tpc_syl2_s3<-tpc_syl1[tpc_syl2$speaker=="s3",]
#one speaker, both syllables
tpc_s1<-tpc_t1_new[tpc_t1_new$speaker=="s1",]
tpc_s2<-tpc_t1_new[tpc_t1_new$speaker=="s2",]
tpc_s3<-tpc_t1_new[tpc_t1_new$speaker=="s3",]




#plot original pitch by tone
alp<-ggplot(tpc_t1_new,aes(x=time,y=pitch,group=pitch_con))
alp+geom_point(aes(color=tone),alpha=0.4)+ggtitle("4 tones clustering 3spk 2syl")+geom_line(aes(color=tone),alpha=0.4)+facet_wrap(~tone)




#plot by original-cent pitch or normalized pitch
alp<-ggplot(tpc_syl1_s3[tpc_syl1_s3$Syllable1=="1",],aes(x=time,y=bark,group=pitch_con))
alp+geom_point(alpha=0.3)+geom_line(alpha=0.5)+ggtitle("4 tones by 1 speakers normalized syllable 1(spk3-bark)")+facet_wrap(~pitch_con)





















