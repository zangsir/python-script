#to get polynomial fitting parameters (unnormlalized duration)
1. use the polyfit-tone.py script with speaker.csv (time,pitch,pitch_con)

#to get normalized duration
1. run polyfit-norm.py with desired speaker csv file

#to get qTA model fitting parameters
1. use various praat scripts for pre-processing
2. use PENTA Trainer on the data
3. the resulting parameters should be stored in a textgrid, save that
4. use extract-parameter.praat to extract parameters from the textgrid to write to a csv file

#optionally expand the csv file into a full datafile compatible with full tone curve data points
5. the resulting csv file contains only one line of parameter per pitch contour
6. use repeat.py and full-qTA.py on that csv file to get a full data file.







tone1.model2<-ssanova(f0_norm~time+pitch_con+time:pitch_con,data=short_t1)
tone1.model3<-ssanova(f0_norm~time+pitch_con+time:pitch_con,data=ub_st1)
tone1.model4<-ssanova(f0_norm~time+pitch_con+time:pitch_con,data=other_st1)
tone1.model5<-ssanova(f0_norm~time+pitch_con+time:pitch_con,data=p1b_st1)
tone1.model6<-ssanova(f0_norm~time+pitch_con+time:pitch_con,data=p2b_st1)

#model2
grid.A <- expand.grid(time = seq(0,30,1),pitch_con=levels(tpc_t1$pitch_con))
grid.A$Fit <- predict(tone1.model2,grid.A,se = T,inc = c("1","time"))$fit
 grid.A$SE <- predict(tone1.model2,grid.A,se = T,inc = c("1","time"))$se.fit
average <- ggplot(grid.A, aes(x = time, colour = pitch_con))
average+ geom_line(aes(y = Fit), size=2, alpha = .8) + ylab("pitch") + xlab("time") + geom_line(aes(y = Fit+(1.96*SE)), lty=2, alpha=0.8) + geom_line(aes(y = Fit-(1.96*SE)), lty=2, alpha=0.8) +  theme(legend.position="none") 


#model3
grid.A <- expand.grid(time = seq(0,30,1),pitch_con=levels(tpc_t1$pitch_con))
grid.A$Fit <- predict(tone1.model3,grid.A,se = T,inc = c("1","time"))$fit
 grid.A$SE <- predict(tone1.model3,grid.A,se = T,inc = c("1","time"))$se.fit
average <- ggplot(grid.A, aes(x = time, colour = pitch_con))
average+ geom_line(aes(y = Fit), size=2, alpha = .8) + ylab("pitch") + xlab("time") + geom_line(aes(y = Fit+(1.96*SE)), lty=2, alpha=0.8) + geom_line(aes(y = Fit-(1.96*SE)), lty=2, alpha=0.8) +  theme(legend.position="none") 

#model4
grid.A <- expand.grid(time = seq(0,30,1),pitch_con=levels(tpc_t1$pitch_con))
grid.A$Fit <- predict(tone1.model4,grid.A,se = T,inc = c("1","time"))$fit
 grid.A$SE <- predict(tone1.model4,grid.A,se = T,inc = c("1","time"))$se.fit
average <- ggplot(grid.A, aes(x = time, colour = pitch_con))
average+ geom_line(aes(y = Fit), size=2, alpha = .8) + ylab("pitch") + xlab("time") + geom_line(aes(y = Fit+(1.96*SE)), lty=2, alpha=0.8) + geom_line(aes(y = Fit-(1.96*SE)), lty=2, alpha=0.8) +  theme(legend.position="none") 

#model5
grid.A <- expand.grid(time = seq(0,30,1),pitch_con=levels(tpc_t1$pitch_con))
grid.A$Fit <- predict(tone1.model5,grid.A,se = T,inc = c("1","time"))$fit
 grid.A$SE <- predict(tone1.model5,grid.A,se = T,inc = c("1","time"))$se.fit
average <- ggplot(grid.A, aes(x = time, colour = pitch_con))
average+ geom_line(aes(y = Fit), size=2, alpha = .8) + ylab("pitch") + xlab("time") + geom_line(aes(y = Fit+(1.96*SE)), lty=2, alpha=0.8) + geom_line(aes(y = Fit-(1.96*SE)), lty=2, alpha=0.8) +  theme(legend.position="none") 


#model6
grid.A <- expand.grid(time = seq(0,30,1),pitch_con=levels(tpc_t1$pitch_con))
grid.A$Fit <- predict(tone1.model6,grid.A,se = T,inc = c("1","time"))$fit
 grid.A$SE <- predict(tone1.model6,grid.A,se = T,inc = c("1","time"))$se.fit
average <- ggplot(grid.A, aes(x = time, colour = pitch_con))
average+ geom_line(aes(y = Fit), size=2, alpha = .8) + ylab("pitch") + xlab("time") + geom_line(aes(y = Fit+(1.96*SE)), lty=2, alpha=0.8) + geom_line(aes(y = Fit-(1.96*SE)), lty=2, alpha=0.8) +  theme(legend.position="none") 

