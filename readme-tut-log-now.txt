TUTORIAL LOG 

#5/12

RUN on : dataset 1(connected speech), dataset 2(reading word list)

1. extract raw time-pitch csv file with 30-point vectors
2. model parameters
	-qTA: no change
	-polynomial: using 30-vector, pitch-height-normalized values (preprocess in R with the CSV.)

3. SAX Representation and clustering
	-with nseg=2,3,or more fine-grained segments
	-alphabet-size=

4. Clustering
	-mclust:polynomial new
	-hclust:with raw pitch vectors, dtw distance
	
#log
1. plot of all pitch contours in tone 1, tone2, etc., showed that we also need pitch height to cluster--otherwise we're losing information about tone height, only depending on contour shape.this means, compute and extract the mean pitch height of this contour in praat. a initial boxplot showed that there are a lot of overlap in pitch height among all tones though. but still worth trying. 
2. we can also add duration.
3. first, i used 30 point vector to extract polyfit parameters. but all of them are pretty small. I will try:(1) use a different scale on time; (2)use normalized pitch with un-normalized time, different length time series




4/1-5/9
mainly worked on the implementation of the perceptual magnet model, extraction of parameters and previous contexts using polynomial fitting in python, and qTA praat script by Xu, among other scripts. Then we tried mclust in R, but it doesn't cluster very well. The parameters from qTA and polynomial may not have that clustering property that could be represented in the original raw time series.






3/21
read: Alan Yu paper on modelling categorical perception in coarticulation context, based on Feldman et al model
discussed Yu paper’s idea and weakness
discussed math tutorial on probability, Bayesian modeling, important distributions, sampling (Gibbs sampling)
assigned more reading on machine learning, Bayesian inference, information theory, graphic models, sampling
3/14 (spring break week)
this week: math tutorial on “Probability” through Harvard Stat 110 course, Joe Blitzstein, Professor of the Practice in Statistics, Harvard University, Department of Statistics (34 lectures) 
3/7
read and presented Feldman et al Perceptual magnet paper in class
read analysis by synthesis paper by Poeppel et al
discussed these two papers and its possible application in tone recognition and perception modeling


2/25/14
read: Prom-on  et al (2009), Mertens, Xu papers
topic: qTA, PENTA,F0 stylization, analysis by synthesis
meeting:
1. qTA is a model that generates the curve of speech production of F0 contours, with continuous functions at syllable boundaries that maintains the derivatives (smoothness). it takes a lot of assumptions from the PENTA model, but is not entirely tied to it. To fit the english pattern better, where you may not have a target for each syllable, one can try to specify lamda parameter to make the target every few syllables.
2.F0 stylization reveals the level of threshold of fine grained pitch change that human can detect. small pitch changes may be discarded and english intonation maybe reduced to level tones and linear rising and falling tones without sounding too unnatural. that has consequences for our representation and modeling of the tone curves in perception. this has implications on the TA work.what if we model the process taking into account the F0 stylization? should we still try to approximate as much as we can the original actual curve?
3.the analysis by synthesis method in computing and in human processing: this is used when the function that generated a surface pattern is not inversable, and one can use this method to generate the surface pattern that has the minimum SSE, and take that underlying parameters. this process has been hypothesized for human cognition as well.
next time: analysis by synthesis; perceptual magnet (feldman)       


2/14/14
read: Teague dissertation
topic: overview of literature
meeting:
1.questions regarding parallel encodings vs. linear encodings of prosody and tones;
2.insufficient evidence to disapprove PENTA
3.looking ahead   



