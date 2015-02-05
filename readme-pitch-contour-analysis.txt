#documentation this file is written in the devleopment of ISMIR paper 2014, for Beijing Opera corpus

to do pitch contour analysis:
1. run extract.sh shell script in ~/Desktop/python-script. this will yield the pitch file grouped by contour id(col wise), and two versions of row-wise data file in downloads directory. 
2. in downloads, run matlab fastsmooth.m. the smoothed file is smoothed-norm.csv. you can then add attributes to this file, copied from the newfile-header.csv.
3. run group-r-to-c.py, to produce the final col-wise data file, smoothed-col.csv, for analysis in R.

to convert to sax representation, use the row-wise vector file newfile-noheader.csv in downloads.


#final files for analysis
row-wise for matlab: smoothed-norm.csv (in downloads)(this is copied to smoothed-norm-noheader.csv in sax-ver directory, with no headers)
col-wise for R:smoothed-col.csv (in python-script)

then we need to hierarchical cluster in R, we made smoothed-norm-sax.csv in desktop from the smoothed-norm.csv. this one contains one column of nseg=2 sax feature, and it is sorted by word, after the sax-2-3new.csv.

we then sorted this new file by tone.

#normalized pitch
the only normalized pitch files saved are on desktop, tpc_t1, etc.we need a row-wise version of this by running group.py. this new file has only 1-30 normalized pitch values(no original pitch values), and with sax feature,sorted by pitch con. this is tpc_t1_sax_row.csv. you  need to copy the sax feature from file smoothed-norm-sax.csv.select only those rows that is tone x in feature column when youc copy sax feature.



/Users/zangsir/Downloads/SAX_2006_ver/SAX_2006_ver

