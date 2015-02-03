#tier1=interval,tier2=target,tier3=slope,tier4=height,tier5=strength
writeInfoLine()
name$=selected$("TextGrid")
filename$=name$+".csv"

n=Get number of intervals... 1 
writeFileLine(filename$,"slope,height,strength,duration,tone")
for i to n
	label$=Get label of interval... 1 i
	label_start$=left$(label$,1)
	if label$!="" and label_start$!="5"
		tone$=Get label of interval... 1 i
		slope$=Get label of interval... 3 i
		height$=Get label of interval... 4 i
		strength$=Get label of interval... 5 i
		duration$=Get label of interval... 6 i

		appendFileLine(filename$,slope$,",",height$,",",strength$,",",duration$,",",tone$)
	endif
endfor
printline finished writing csv...
