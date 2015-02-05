library(mclust)

library(caret)



fit <- princomp(tpc_t1, cor=TRUE)
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