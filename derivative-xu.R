#analysis with D1-clustering
xud1<-read.csv("~/Desktop/normtime_f0velocity_All1.csv")
xud2<-read.csv("~/Desktop/normtime_f0velocity_All2.csv")
xud3<-read.csv("~/Desktop/normtime_f0velocity_All3.csv")

 
 
 xud1[1:10,1:10]
 xud2[1:10,1:10]
 xud3[1:10,1:10]

xud1$Syllable1<-as.factor(xud1$Syllable1)
xud2$Syllable1<-as.factor(xud2$Syllable1)
xud3$Syllable1<-as.factor(xud3$Syllable1)
xud1$Syllable2<-as.factor(xud1$Syllable2)
xud2$Syllable2<-as.factor(xud2$Syllable2)
xud3$Syllable2<-as.factor(xud3$Syllable2)



xud1$speaker<-as.factor("s1")
xud2$speaker<-as.factor("s2")
xud3$speaker<-as.factor("s3")

#get rid of NA values
tail(xud1)
tail(xud2)
tail(xud3)

xud1<-xud1[1:320,]
xud2<-xud2[1:320,]
xud3<-xud3[1:320,]


allxud<-rbind(xud1,xud2,xud3)

str(allxud)



#subset to syllable 1 and syllable 2
allxud[,c(1:3,4:33,64:66)]->allxud1
head(allxud1)
allxud[,c(1:3,34:63,64:66)]->allxud2
head(allxud2)


#pitch_con, first syllable
a="1"
b="2"
allxud1$pitch_con<-"a"
for (i in 1:nrow(allxud1)){
	allxud1[i,]$pitch_con<-paste(allxud1[i,]$Normtime,allxud1[i,]$speaker,a,sep="_")
	
}
#pitch_con, second syllable
allxud2$pitch_con<-"a"
for (i in 1:nrow(allxud2)){
	allxud2[i,]$pitch_con<-paste(allxud2[i,]$Normtime,allxud2[i,]$speaker,b,sep="_")
	
}




str(allxud1$pitch_con)

allxud1$pitch_con<-as.factor(allxud1$pitch_con)
allxud2$pitch_con<-as.factor(allxud2$pitch_con)
allxud1$syl<-as.factor(allxud1$syl)
allxud2$syl<-as.factor(allxud2$syl)

#add tone
allxud1$tone<-allxud1$Syllable1
allxud2$tone<-allxud2$Syllable2
allxud1$tone<-as.factor(allxud1$tone)
allxud2$tone<-as.factor(allxud2$tone)



str(allxud1)
str(allxud2)

colnames(allxud2)<-colnames(allxud1)

allxudn<-rbind(allxud1,allxud2)



#get syllable and tone
allxudn$syl<-"first"
#selecting only the 1st syllable
for (i in 1:length(allxudn$pitch_con)){
	allxudn$pitch_con[i]->a
	strsplit(as.character(a),"_")->b
	#print(b)
	if (b[[1]][4]=="2"){
	#	print(b[[1]][4])
		allxudn$syl[i]<-"second"
		}

}
allxudn$syl<-as.factor(allxudn$syl)




str(allxudn)



#allxudn is new allxud, contains 30-point vector, attribute about tone, syllable. row-wise, for clustering, this is first derivative profile. 
write.csv(allxudn,"~/Desktop/allxudn-3speakers.csv",row.names = FALSE)

########## write to file.
# notice that this is D1 profile, so it doesn't need any normalization - it's already a feature normalized.












#################################################### c l u s t e r i n g
#note that kmeans clustering takes row wise vectors

#clustering with D1
#subset for numeric columns

data_xud<-allxudn[,4:33]
head(data_xud)
#cluster with kmeans on original pitch data, no normalization
clust.1<-kmeans(data_xud,4)
clust.1$cluster->cluster.syl1
cluster.syl1<-as.factor(cluster.syl1)

#data frame for comparing with true labels and for plotting
tone.syl1<-allxudn$tone
syl1.clu<-data.frame(cluster.syl1,tone.syl1)
str(syl1.clu)
#visualize cluster
clust.plot<-ggplot(syl1.clu,aes(x=cluster.syl1))
clust.plot+geom_histogram(aes(fill=tone.syl1))+ggtitle("cluster with D1 (Hz) 3 speakers 2 syls")


#confusion matrix
syl1.clu$label<-"1"
syl1.clu[syl1.clu$tone.syl1=="1",]$label<-"1"
syl1.clu[syl1.clu$tone.syl1=="3",]$label<-"2"
syl1.clu[syl1.clu$tone.syl1=="4",]$label<-"3"
syl1.clu[syl1.clu$tone.syl1=="2",]$label<-"4"

confusionMatrix(syl1.clu$cluster.syl1,syl1.clu$label)




###################################### plot some contours, not very useful

#try to plot to see what D1 contours look like
allxud.col<-read.csv("~/Desktop/python-script/smoothed-col-yixud.csv")

allxud.col$syl<-"first"
#selecting only the 1st syllable
for (i in 1:length(allxud.col$pitch_con)){
	allxud.col$pitch_con[i]->a
	strsplit(as.character(a),"_")->b
	#print(b)
	if (b[[1]][4]=="2"){
	#	print(b[[1]][4])
		allxud.col$syl[i]<-"second"
		}

}
allxud.col$syl<-as.factor(allxud.col$syl)
allxud.col.syl1<-allxud.col[allxud.col$syl=="first",]
allxud.col.syl2<-allxud.col[allxud.col$syl=="second",]
allxud.col.syl1$tone<-allxud.col.syl1$Syllable1
allxud.col.syl2$tone<-allxud.col.syl2$Syllable2
allxud.col.syl1$tone<-as.factor(allxud.col.syl1$tone)
allxud.col.syl2$tone<-as.factor(allxud.col.syl2$tone)

allxud.col.new<-rbind(allxud.col.syl1,allxud.col.syl2)
allxud.col.new$tone<-as.factor(allxud.col.new$tone)
str(allxud.col.new)

alp<-ggplot(allxud.col.new,aes(x=time,y=pitch,group=pitch_con))
alp+geom_point(aes(color=tone),alpha=0.3)+geom_line(aes(color=tone),alpha=0.4)+ggtitle("4 tones D1 by 3 speakers")+facet_wrap(~tone)




