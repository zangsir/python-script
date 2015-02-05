#mclust, PCA, model based clustering, demo originally by Chris Kirov

#mydata below will be some subset of a csv file where each line corresponds to a tone in your data

#The columns will be sets of parameters. You can try different sets.
#A) 4 polyfit params + length based on unnormalized curve
#B) 4/5 dynamic params + length based on unnormalized curve
#C) 4 polyfit params based on normalized curve
#...

#CLUSTERING
#Attempting to automatically break the data into Gaussian clusters. mydata contains ALL datapoints, or just datapoints from a particular context (e.g., following tone 1). You don't need to do dimensionality reduction before clustering.

# Model Based Clustering - mixture of Gaussians
library(mclust)

library(caret)

par(mfrow=c(1,1))
#use 30-vector time-series
tone=read.csv("~/Desktop/adult-new2.csv")

#use different-length time-series
tone=read.csv("~/Desktop/adult-diff-mean-param.csv")
tone$tone<-factor(tone$tone,c("1","2","3","4"))
str(tone)

#######################raw csv compute mean pitch and write to csv
#read in raw csv file to normalize pitch, then produece different-length parameter polynomial file
#normalize
#adult<-read.csv("~/Desktop/total_adult_raw.csv")
#in the file adult_mean.csv on 5/12, computation of f0-mean was done using raw pitch with all speakers, not good.
#here we read in that file, and compute a new f0-mean value that is normalized against the mean value of each speaker, using real pitch value, not normalized ones.

#adult<-read.csv("~/Desktop/child-files/adult-mean.csv")
#adult$tone<-as.factor(adult$tone)
#wang<-adult[adult$speaker=="wang",]
#meng<-adult[adult$speaker=="meng",]
#zhong<-adult[adult$speaker=="zhong",]

#mw=mean(wang$pitch)
#mm=mean(meng$pitch)
#mz=mean(zhong$pitch)
#wang$f0_mean_norm<-wang$mean_f0/mw
#meng$f0_mean_norm<-meng$mean_f0/mm
#zhong$f0_mean_norm<-zhong$mean_f0/mz

#new_adult_mean<-rbind(wang,meng,zhong)
#write.csv(new_adult_mean,"~/Desktop/adult_mean_norm.csv")

#calculate the mean pitch value of each pitch contour
#aggregate(pitch~pitch_con,adult,mean)->a#

#for each speaker, to produce one-line data to match SAX format
#aggregate(pitch~pitch_con,wang,mean)->aw
#aggregate(pitch~pitch_con,meng,mean)->am
#aggregate(pitch~pitch_con,zhong,mean)->az
#aw$f0_mean_norm<-aw$pitch/mw
#am$f0_mean_norm<-am$pitch/mm
#az$f0_mean_norm<-az$pitch/mz

#rbind data vector for f0_mean_norm, in one line per pitch-con
#f0_mean_norm_oneline<-rbind()
#in the end i ended up using the full raw data with mean-norm, then use group.py to generate the one-line data

#calculate normalized mean pitch values

#d<-c()
#for (i in 1:nrow(a)){
#	b<-rep(a$pitch[i],nrow(tpc_adult[tpc_adult$pitch_con==pcl[i],]))
#	d<-c(d,b)
	
#}
#############################################################
#to create a classification feature with SAX-based shape, and duration, f0_mean_norm

















################ B E G I N     C L U S T E R I N G============
#############################################################

#with 30-point pitch-normlized data, or diff-length data
tone_clust<-tone[,c(1:3,8,9)]

#see documentation mclust.pdf for usage and model explanation

#cluster with sax n,a=(5,3)
#this sax file used numeric representation of a,b,c (1,2,3)
tone<-read.csv("~/Desktop/SAX_adult_5_3.csv")
tone$tone<-factor(tone$tone,c("1","2","3","4"))
str(tone)
tone_clust<-tone[,c(1:5,7,8)]
str(tone_clust)


#clustering without tone label
#tone_clust<-tone[,2:13]
fit <- Mclust(tone_clust,G=1:9)
summary(fit)
fit$classification
#visualize cluster assignment against tone category label
data<-data.frame(fit$classification,tone$tone)
data$fit.classification<-as.factor(data$fit.classification)
head(data)

cl<-ggplot(data,aes(x=fit.classification))
cl+geom_histogram(aes(fill=tone.tone))


#plot SAX represented cluster of shapes
sax<-read.csv("~/Desktop/SAX_adult_r.csv")
sax$tone<-as.factor(sax$tone)
sax.plot<-ggplot(sax,aes(x=shape))
sax.plot+geom_histogram(aes(fill=tone))














#hierarchical clustering

#this csv file should contain all 30 data points in a row, and a header, and a column for tone category!!!!
tone<-read.csv("~/Desktop/adult-mean-norm-header-sax-sortedtone.csv")
#tone<-read.csv("/Users/zangsir/Downloads/SAX_2006_ver/SAX_2006_ver/all_short.csv")


tone$tone<-as.factor(tone$tone)
#sc<-subset(tone,tone!="5")
#sc<-droplevels(sc)
sc<-tone

scc<-sc[,1:32]
library(dtw)
#n<-20
#s <- sample(1:150, n)
#idx <- c(s, 246+s, 187+246+s, 187+246+170+s)
#sample2 <- sc[idx,]

#whole clust
a=xtabs(~tone,sc)
#data=sc[,1:30]
data=scc
observedLabels <- c(rep(1,a[1]), rep(2,a[2]), rep(3,a[3]), rep(4,a[4]))
distMatrix <- dist(data, method="DTW")
# hierarchical clustering
hc <- hclust(distMatrix, method="average")
summary(hc)
plot(hc, labels=observedLabels, main="4tone")
library(cluster)
#k-medoids
km<-pam(distMatrix,4)
plot(km, labels=observedLabels, main="4tone")

str(km)

#fit <- Mclust(tone_clust,G=1:9)

data<-data.frame(km$clustering,tone$tone)
data$km.clustering<-as.factor(data$km.clustering)
head(data)
library(ggplot2)
cl<-ggplot(data,aes(x=km.clustering))
cl+geom_histogram(aes(fill=tone.tone))

















################### before
confusionMatrix(fit$classification,tone$tone)

#use G parameter to control number of possible clusters
fit <- Mclust(tone_clust,G=1:9) #mclust will try 1 to 9 clusters and choose the best number based on BIC
confusionMatrix(fit$classification,tone$tone)

#visualize cluster assignment against tone category label
cl<-ggplot(data,aes(x=fit.classification))
cl+geom_histogram(aes(fill=tone.tone))

plot(fit) # plot results - will show a matrix of 2d graphs for each pair of parameters

summary(fit) # display the best model
fit$classification #labels assigned to each data point by clustering - compare to real labels:
tone$tone
confusionMatrix(fit$classification,tone$tone)


#try other subsets
#without prev_tone, duration_raw
tone_clust2<-tone[,2:11]
polyfit<-tone_clust2[,1:4]
polyfit_norm<-tone_clust2[,5:7]
qta<-tone_clust[,8:10]

fit <- Mclust(qta,G=4) #tell mclust to find exactly 4 clusters
confusionMatrix(fit$classification,tone$tone)

fit <- Mclust(tone_clust2,G=1:9) #mclust will try 1 to 9 clusters and choose the best number based on BIC



fit<-Mclust(polyfit,G=4)
confusionMatrix(fit$classification,tone$tone)
fit <- Mclust(polyfit,G=1:9) 

fit<-Mclust(polyfit_norm,G=4)
confusionMatrix(fit$classification,tone$tone)

fit<-Mclust(qta,G=4)
confusionMatrix(fit$classification,tone$tone)


#compare classification with label
fit$classification
tone$tone

#compute confusion matrix
confusionMatrix(fit$classification,tone$tone)

#get rid of previous "empty" ones
tone_clust3<-tone[tone$previous_tone!="empty",]
tone_clust4<-tone_clust3[,2:11]
fit <- Mclust(tone_clust4,G=4) 
confusionMatrix(fit$classification,tone_clust3$tone)

#subset on previous_tone 1,2,3,4,5
#tone_clust3 has all data points with prev_tone that is not 'empty'
tone_clust5<-tone_clust3[tone_clust3$previous_tone=="1",]
tone_clust6<-tone_clust5[,2:11]
fit<-Mclust(tone_clust6,G=4)
confusionMatrix(fit$classification,tone_clust5$tone)
par(mfrow=c(2,3))

plot(density(tone_clust6$X1st))
plot(density(tone_clust6$X2nd))
plot(density(tone_clust6$X3rd))
plot(density(tone_clust6$slope))
plot(density(tone_clust6$height))
plot(density(tone_clust6$strength))

summary(tone_clust6)

tone_clust7<-tone_clust3[tone_clust3$previous_tone=="2",]
tone_clust8<-tone_clust7[,2:11]
fit<-Mclust(tone_clust8,G=4)
confusionMatrix(fit$classification,tone_clust7$tone)

plot(density(tone_clust7$X1st))
plot(density(tone_clust7$X2nd))
plot(density(tone_clust7$X3rd))
plot(density(tone_clust7$X1st_norm))
plot(density(tone_clust7$X2nd_norm))
plot(density(tone_clust7$X3rd_norm))
plot(density(tone_clust7$slope))
plot(density(tone_clust7$height))
plot(density(tone_clust7$strength))

summary(tone_clust8)

tone_clust9<-tone_clust3[tone_clust3$previous_tone=="3",]
tone_clust10<-tone_clust9[,2:11]
fit<-Mclust(tone_clust10,G=4)
confusionMatrix(fit$classification,tone_clust9$tone)

tone_clust11<-tone_clust3[tone_clust3$previous_tone=="4",]
tone_clust12<-tone_clust11[,2:11]
fit<-Mclust(tone_clust12,G=4)
confusionMatrix(fit$classification,tone_clust11$tone)

tone_clust13<-tone_clust3[tone_clust3$previous_tone=="5" ||tone_clust3$previous_tone=="5r",]
tone_clust14<-tone_clust13[,2:11]
fit<-Mclust(tone_clust14,G=4)
confusionMatrix(fit$classification,tone_clust13$tone)











###########################DIMENSIONALITY REDUCTION
#If you want, you can reduce the dimensionality of the data, which will usually have 5-ish parameters.
#Making the data 2d will help with visualization.

#PCA and MDS will have essentially the same results for this data.

# Pricipal Components Analysis
# entering raw data and extracting PCs 
# from the correlation matrix 
fit <- princomp(tone_clust4, cor=TRUE)
par(mfrow=c(1,1))
summary(fit) # print variance accounted for 
loadings(fit) # pc loadings 
plot(fit,type="lines") # scree plot 
fit$scores # the principal components 
data2d <- fit$scores[,1:2] #just the first two principal components
rotation<-fit$rotation[,1]
#you can plot the 2d data as a scatterplot, perhaps with different colors for each tone
biplot(fit)
plot(data2d)

# Classical MDS
# N rows (objects) x p columns (variables)
# each row identified by a unique row name
d <- dist(tmp) # euclidean distances between the rows
fit <- cmdscale(d,eig=TRUE, k=2) # k is the number of dim (2 for 2d)
fit # view results
# plot solution 
x <- fit$points[,1]
y <- fit$points[,2]
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2", main="Metric MDS", type="n")
text(x, y, labels = tone$tone, cex=.7)

#VISUALIZATION
#after running PCA or MDS you have a 2D approximation of the data
#plot Gaussian ellipses for 2D data - for example, plot an ellipse for each tone category
library(car)

par(new=TRUE) #use this to plot one ellipse over another - call this before each new plot command
dataEllipse(data2d) #see dataEllipse docs for more info (i.e., use xlim, ylim, col, etc.)





#MAXIMUM LIKELIHOOD ESTIMATION

#Find the parameters for a multidimensional Gaussian - you usually don't need to do this manually.
#You would do this separately for each category in the data.
#get mean and covariance matrices - maximum likelihood estimates are just empirical mean and covariance
mu <- colMeans(tone_clust4)
sigma <- cov(tone_clust4)
#get the density of a particular point
library(mvtnorm)
x <- rmvnorm(n=500, mean=mu, sigma=sigma)


pdf=dmvnorm(x,mu,sigma)
plot(x)



shuo=read.csv(file.choose())

