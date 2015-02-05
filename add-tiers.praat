#this is used to add tiers in PENTATrainer preparation data file
#make sure you have a one tier textgrid with pitch contours labeled and segmented, this will add the rest of the tiers required to run PENTATrainer
tier1$=Get tier name... 1



ntiers=Get number of tiers

if ntiers=1
	Set tier name... 1 interval
	Insert interval tier... ntiers+1 target	
	Insert interval tier... ntiers+2 slope
	Insert interval tier... ntiers+3 height
	Insert interval tier... ntiers+4 strength
	Insert interval tier... ntiers+5 duration
endif

ntiers=Get number of tiers
n=Get number of intervals... 1

for i from 2 to n
	t=Get start point... 1 i
	for j from 2 to ntiers
		Insert boundary... j t
	endfor
endfor

printline finished inserting boundary
