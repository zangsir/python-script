#this script uses tsclust package in r to perform SAX representation clustering with mindist. originally created in August 2014.modified first in Dec.2014.

#notice that, when you do this with alpha=2, it doesn't work well with mindist because it counts strings with only one letter difference as 0 distance.

library(TSclust)
library(hclust)

#read original value
xuori<-read.csv("~/Desktop/allxu_new.csv")
xuori$tone<-as.factor(xuori$tone)
xuori$syl<-as.factor(xuori$syl)
#next try to put the tone into pitch_con


xuori$pitch_con_new<-"a"
for (i in 1:nrow(xuori)){
	xuori[i,]$pitch_con_new<-paste(xuori[i,]$pitch_con,xuori[i,]$tone,sep="_")
	
}
xuori$pitch_con_new<-as.factor(xuori$pitch_con_new)
#get s3
xuori_s3<-xuori[xuori$speaker=="s3",]
xuori_s3<-xuori_s3[xuori_s3$syl=="1",]
xuori_s3<-droplevels(xuori_s3)
str(xuori_s3)

head(xuori_s3)

vector<-xuori_s3[,5:34]
head(vector)
rownames(vector)<-xuori_s3$pitch_con_new
#sax conversion and dissimilarity matrix
vector_matrix<-data.matrix(vector)


alpha=3
w=5
dist<-diss(vector_matrix, "MINDIST.SAX", w, alpha)



#hclust
hc <- hclust(dist, method="average")
summary(hc)


#hcd<-as.dendrogram(hc)
#plot(dend$lower)
plot(hc, labels=xuori_s3$tone,cex=0.5)
hcd = as.dendrogram(hc)

#zoome in
plot(cut(hcd, h = 1)$upper, main = "Upper tree of cut at h=75")
plot(cut(hcd, h = 1)$lower[[6]],main = "Second branch of lower tree with cut at h=75")


#phylogenetic trees
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

#next, experiment with some specific contour groups and see the behavior of min=dist
#select four tones of 20 each
test<-xuori_s3[1:80,]
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







