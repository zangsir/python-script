#this script uses tsclust package in r to perform SAX representation clustering with mindist. originally created in August 2014.modified first in Dec.2014.

#notice that, when you do this with alpha=2, it doesn't work well with mindist because it counts strings with only one letter difference as 0 distance.

library(TSclust)
library(hclust)

#read original value
xuori<-read.csv("~/Desktop/feature-files/30point-raw/row-yixunorm-bk.csv")
xuori$tone<-as.factor(xuori$tone)
xuori$syl<-as.factor(xuori$syl)



#next try to put the tone into pitch_con , for better viewing?
xuori$pitch_con_new<-"a"
for (i in 1:nrow(xuori)){
	xuori[i,]$pitch_con_new<-paste(xuori[i,]$pitch_con,xuori[i,]$tone,sep="_")
	
}
xuori$pitch_con_new<-as.factor(xuori$pitch_con_new)

###################get s3
#xuori_s3<-xuori[xuori$speaker=="s3",]
#xuori_s3<-xuori_s3[xuori_s3$syl=="1",]
#xuori_s3<-droplevels(xuori_s3)
#str(xuori_s3)
#head(xuori_s3)

#vector<-xuori[,1:30]
#head(vector)
#rownames(vector)<-xuori_s3$pitch_con_new

#next, experiment with some specific contour groups and see the behavior of min=dist
#select four tones of 20 each
test<-xuori[1:200,]
xtabs(~tone,test)
vector<-test[,1:30]
#sax conversion and dissimilarity matrix
vector_matrix<-data.matrix(vector)

library(flexclust)

#####################specify parameters
alpha=3
w=9
#####################compute distance matrix using min-dist
dist<-diss(vector_matrix, "MINDIST.SAX", w, alpha)
#Kmeans clustering
fclust<-kcca(dist,4)
summary(fclust)
#notice that this provides SAX and mindist distance measure, but not a clustering method.
#SEE HERE:
 #help(diss.MINDIST.SAX)
#confusion matrix
a<-data.frame(fclust@cluster)
a$tone<-test$tone
a$fclust.cluster<-as.factor(a$fclust.cluster)
str(a)
cm=confusionMatrix(a$fclust.cluster,a$tone)
cm

a$label<-"1"
for (i in 1:nrow(cm$table)){
		t=cm$table[i,]
		max=max(t)
		for (j in 1:length(t)){
			if (t[j]==max){
			print(j)
			ass=toString(j)
			a[a$tone==ass,]$label<-i
			check=c(check,j)
			}
		}
	}
a$label<-as.factor(a$label)

cm_true=confusionMatrix(a$fclust.cluster,a$label)
cm_true





w=3
dist<-diss(vector_matrix, "MINDIST.SAX", w, alpha)
################ model based clust
fit <- Mclust(dist,4) #mclust will try 1 to 9 clusters and choose the best number based on BIC
toneframe=test
#fit <- Mclust(mydata,G=4) #tell mclust to find exactly 4 clusters
#plot(fit) # plot results - will show a matrix of 2d graphs for each pair of parameters
#summary(fit) # display the best model
#fit$classification #labels assigned to each data point by clustering - compare to real labels
cm = confusionMatrix(fit$classification,toneframe$tone)

cluvis<-data.frame(fit$classification,toneframe$tone)
cluvis$fit.classification<-as.factor(cluvis$fit.classification)

cluvis$label<-"1"
for (i in 1:nrow(cm$table)){
		t=cm$table[i,]
		max=max(t)
		for (j in 1:length(t)){
			if (t[j]==max){
			print(j)
			ass=toString(j)
			cluvis[cluvis$toneframe.tone==ass,]$label<-i
			check=c(check,j)
			}
		}
	}
cluvis$label<-as.factor(cluvis$label)

cm_true=confusionMatrix(fit$classification,cluvis$label)

cm_true



#plot sax results
sax<-read.csv("~/Desktop/sax-eval.csv")
str(sax)
saxplot<-ggplot(sax,aes(x=Feature,colour=condition))
saxplot+geom_point(aes(y=Accuracy))+geom_errorbar(aes(ymin=Accuracy-se, ymax=Accuracy+se), width=.1)+geom_line(aes(y=Accuracy,group=condition))












################### hclust
hc <- hclust(dist, method="average")
summary(hc)


#hcd<-as.dendrogram(hc)
#plot(dend$lower)
plot(hc, labels=test$tone,cex=0.5)
hcd = as.dendrogram(hc)

#zoome in
plot(cut(hcd, h = 1)$upper, main = "Upper tree of cut at h=75")
plot(cut(hcd, h = 1)$lower[[6]],main = "Second branch of lower tree with cut at h=75")

#########################################
#select groups for seeing more clearly
#next, experiment with some specific contour groups and see the behavior of min=dist
#select four tones of 20 each
test<-xuori[1:80,]
test
vector<-test[,5:34]
#try numeric cluster with hclust, euclidean distance
distMatrix <- dist(vector, method="euclidean")
hc <- hclust(distMatrix, method="average")
summary(hc)
plot(hc, labels=test$tone, cex=0.9)

#try numeric cluster with hclust, dtw distance 
distMatrix <- dist(vector, method="DTW")
hc <- hclust(distMatrix, method="average")
summary(hc)
plot(hc, labels=test$tone, cex=0.9)





#############################################################phylogenetic trees
# load package ape;
# remember to install it: install.packages("ape")
library(ape)
# plot basic tree
plot(as.phylo(hc), cex = 0.9, label.offset = 1)
# cladogram
plot(as.phylo(hc), type="cladogram", cex = 0.4, label.offset = 1)


plot(hc, labels=xuori_s3$tone,cex=0.1)
plot(as.phylo(hc), type="cladogram", cex = 0.1)
dev.copy2pdf(file = "~/Desktop/tree.pdf")

#we tried using nseg=5, alpha=3 to compute dissimilarity matrix with sax and then cluster. we used the original pitch values (not d1). next, we should also use the numeric vectors as a baseline, to do a hclust, and compare the baseline results with different parameters of the sax based clutsering. 
library(dtw)
#try numeric cluster with hclust, dtw distance 
distMatrix <- dist(vector, method="DTW")
hc <- hclust(distMatrix, method="average")
summary(hc)
plot(hc, labels=xuori_s3$tone, cex=0.2)
dev.copy2pdf(file = "~/Desktop/tree-num-dtw.pdf")

#try numeric cluster with hclust, euclidean distance
distMatrix <- dist(vector, method="euclidean")
hc <- hclust(distMatrix, method="average")
summary(hc)
plot(hc, labels=xuori_s3$tone, cex=0.2)
dev.copy2pdf(file = "~/Desktop/tree-num-euclidean.pdf")
#######################################################################################################







############################################################ not useful
#how is xuori_s3 speaker dataset  with kmeans?pretty good

clust.1<-kmeans(vector,4)
clust.1$cluster->cluster.syl1
cluster.syl1<-as.factor(cluster.syl1)

#data frame for comparing with true labels and for plotting
tone.syl1<-xuori_s3$tone
syl1.clu<-data.frame(cluster.syl1,tone.syl1)
str(syl1.clu)
#visualize cluster
library(ggplot2)
clust.plot<-ggplot(syl1.clu,aes(x=cluster.syl1))
clust.plot+geom_histogram(aes(fill=tone.syl1))+ggtitle("cluster with original pitch values (Hz) syl2 s3")
###############################################################






############################################################ 



