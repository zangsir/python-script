#xu_data_qp2

############################## NEW TASKS ####################################
1. we can implement new normalization strategy if it has not been implemented

2. smooth Matlab script is smooth_shuo.m, calling fastsmooth.m matlab function. these are stored originally in the ~/download/ directory now in Transcend sd card. to look for any produced file from matlab script, we should also look in there. The truth is the original data from Xu is already smoothed, as described in his paper; we may not need to do it again. in a way, SAX is a smoothing, and we have opportunity to play with that in later processes anyway.

3. produce a desirable csv data file to use for 30 point polyfit. this data file can be used for later machine learning tasks as well as a base 30 point definite version file that is normalized right (and possibily smoothed)

4. also produce a D1 csv file.

#paper idea
5. here, many choices are not simply made in this experiment. For instance, normalization seems not necessarily bring better results when clustering; we could conceive that for one speaker, actually normalized results are a little worse than original; but this is only possible because this is one speaker. if we have a range of voices, then the frequency range of each person being different, may cause the normalization to be desirable. Did we try this already?








############################## VERSION HISTORY TRACING ####################################
all files in this directory and subdirectory are created and modified during analysis of Xu original data files from June 2014. The data is collected in his 1997 paper of contextual variation of tones, and is reused for Gauthier et al. 2007 on the SOM of tone learning (machine). 

in summer 2014 I ran preliminary analysis and machine learning on this data, (including time series data mining), but did not document how the files were generated. 

now in Fall of 2014, I am writing my QP2 and do not know where a lot of files came from. I would begin this documentation on Dec.12, 2014. 




#I have identified data files that are of potential clear use: 
#this is the last file produced in yi-xu-analysis.r, smoothed and normalized for each contour in R, but smoothed file that are used for normalization not found yet:
#allxu.col<-read.csv("~/Desktop/python-script/smoothed-col-yixu.csv"); new comment:don't know  where this smoothed-col-yixu.csv comes from, could use un-smoothed allxu_new.csv converted to col-wise data for this normalization, or smooth it.)

#so:this is normalized with cent based normalization values (first converted to cent). 
#in order to generate an alternate bark-based normalized value, need to go back to yi-xu-analysis.r.
xunorm_new.csv,




#allxu_new seems like a comprehensive file that contains all speakers, each line containing 30 point data for one tone, and attributes columns are added such as speaker, pitch-con id, syllable (#1 or #2), etc. 
allxu_new.csv #(on F0 data, not normalized, all speakers,)

allxudn_3speakers.csv. (on D1 data, all speakers)

allxu-col.csv(column wise version data of allxu_new.csv. this is normalized and smoothed pitch).



#analysis files
yi-xu-analysis.r

derivative-xu.r

smooth_shuo.m 



#processing scripts
#this one is modified from CompMusic script group-r-to-c.py, used to generate column wise data file for analysis in R.smoothed-col*.csv are all generated with this batch.it is described in readme-pitch-contour.analysis.txt file originally in development of BJ opera TS mining
group-r-to-c-xu.py 


#problem with original Xu data files
The annoying thing about original data file is that they all contain an extra line of data in the end which I do not know where did it come from, and they all are in two-syllable format (60 point vectors) that I need to separate into single syllable anyway.




#dec.14,2014
I have made some progress in understanding the version history of these files, and today I put together xu_data_qp2 directory under which i store the data files useful for now. 

note on files: 

#Original files: 
the original files from Xu has two files, one for F0 (3 speakers), one for D1 (3 speakers). In each file, 3 speaker data are stored in 3 tabs of the spreadsheet. (these are named normf0_All3, indicating it contains all 3 speakers in one file).

#Indie files: 
we then separate those three speakers into three files, including normf0_All1_indie, normf0_All2_indie, etc, for speakers 1, 2, etc. 

#problem with these files
is that we have no pitch con, which is added in R in the summer. I need to find a better file (maybe a comprehensive one including all 3 speakers in one-syllable 30 point row-wise format) which may also include other features like tone, pitch_con, etc.


#trace version history
to trace the version history of these files in summer 2014, I look at the analysis script yi-xu-analysis.r, the main script that showed which files I read and wrote, and what transformations were carried out. Notice this file start by reading in the three files mentioned above, now named with (indie) in their file names:

xu1<-read.csv('~/Desktop/normf0_All1.csv')
xu2<-read.csv('~/Desktop/normf0_All2.csv')
xu3<-read.csv('~/Desktop/normf0_All3.csv')

(now:normf0_All1_indie.csv, etc)
