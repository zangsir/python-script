#These are source files used in the project of machine learning and time series data mining of speech and music data. Include source code in python and PSL as well as some csv files, mostly used to generate various forms of data files and process them from raw data.

#to get polynomial fitting parameters (unnormlalized duration)
1. use the polyfit-tone.py script with speaker.csv (time,pitch,pitch_con)

#to get normalized duration
1. run polyfit-norm.py with desired speaker csv file

#newer versions of polyfit
1. we have polyfit-new.py, using 30-point pitch vectors to extract polyfit parameters.
2. polyfit-norm-mean-diff.py. this polyfit script is new. copied from polyfit-new.py,which takes the new csv file with 30point data vector, and columns for duration and mean_f0 of the pitch contour. the only difference in this is that, in that one, duration can't be computed from time,and was thus included in the raw csv. but in this one, raw csv doesn't include duration, and we compute the duration like in the original polyfit-tone.py. in the csv file that is read in raw, it has four columns, time, pitch, pitch_con, mean_f0. file name is, addult-diff-raw-mean.csv.

#to get qTA model fitting parameters
1. use various praat scripts for pre-processing
2. use PENTA Trainer on the data
3. the resulting parameters should be stored in a textgrid, save that
4. use extract-parameter.praat to extract parameters from the textgrid to write to a csv file

#optionally expand the csv file into a full datafile compatible with full tone curve data points, where each row is one pitch point and each row belongs to a pitch_con_id that spans a series of rows

5. the resulting csv file contains only one line of parameter per pitch contour
6. use repeat.py and full-qTA.py on that csv file to get a full data file.


================================
#editing history
#format of an edit:
#
#- text
#- text
#(date)

-this file is first created in Spring 2014 at the time I was running first experiments on tone ML
-then in winter of 2014 I was trying to run these again and edited this file, to be more clear what do the files do and versions differences
-however, since this directory contains many files I wrote in summer 2014 at MTG, for both speech and music tasks, it is still unclear what many or many different versions do 
(12/12/2014)



