

#define the distance measure
distEuclidean <- function(x, centers)
{
z <- matrix(0, nrow=nrow(x), ncol=nrow(centers))
for(k in 1:nrow(centers)){
z[,k] <- sqrt( colSums((t(x) - centers[k,])^2) )
}
z
}

#create a 'brand new' clustering method of a kccaFamily object
 kmFam <- kccaFamily(dist = distEuclidean, cent = colMeans)
#create the data 
  x <- matrix(rnorm(1000), ncol = 2)

#do the clustering, where family must be an object of class kccaFamily
 cl1 <- kcca(x, 10, family = kmFam)
 cl1

summary(kmFam)

#plot 
image(cl1)


library(dtw)

distMatrix <- dist(xx, method="DTW")
#need to compute the dtw distance between the data and the center
#the dtw distance between two vectors: dtw(a,b)
#this is my implementation of dtw distance function
#returns z, a matrix of dtw distance to the center of the cluster
distDTW <- function(x, centers)
{z <- matrix(0, nrow=nrow(x), ncol=nrow(centers))
for(k in 1:nrow(x)){
	z[k,] <- dtw(x[k,],centers[1,])$distance
	
	}
z
}




#created the new cluster method
 kmFamdtw <- kccaFamily(dist = distDTW, cent = colMeans)
 
 
 #actually cluster
 cl2 <- kcca(x, 10, family = kmFamdtw)
 cl2
 image(cl2)
 
 
 
 xunorm_s1->try
try2<-try[,1:30]
 #with the xu's data
  cl3 <- kcca(try2, 4, family = kmFamdtw)
  cl<-cl3@cluster
  cl<-as.factor(cl)
  try$tone->label
 dtwclust<-data.frame(label,cl)

  #plot cluster assignments
  library(ggplot2)
clust.plot<-ggplot(dtwclust,aes(x=cl))
clust.plot+geom_histogram(aes(fill=label))+ggtitle("cluster with kmeans dtw distance implemented ")
 
 
 #so far, the k means with dtw distance is pretty bad. either i have implemented it wrong, or it doesn't work well with this type of data, like some people said on the internet. i will yet to check my implementation.
 #it could also be the data is bad-we used default k means and also got bad results. the concern is that running dtw distance on a 1920*30 matrix is very costly, takes a long time.

#using pam (k-medoids)from cluster (euclidean distance)
clustpam<-pam(xunormsyl1,4) 
 
 
   cl<-clustpam$clustering
  cl<-as.factor(cl)
  xunorm_s1$tone->label
 pamclust<-data.frame(label,cl)

  #plot cluster assignments
  library(ggplot2)
clust.plot<-ggplot(pamclust,aes(x=cl))
clust.plot+geom_histogram(aes(fill=label))+ggtitle("cluster with pam ")
 

 
 #use dtw to do pam
 library(dtw)
distMatrix <- dist(xunormsyl1, method="DTW")
clustpam<-pam(distMatrix,4,diss=T) 


 