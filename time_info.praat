#of course, we first need to use praat to extract from textgrid, writing to a csv that contains [pitch_con,time_start,time_end,artist,roletype,shengqiang,tone], and named with names like DX_E_1. in this file, each role is a pitch_con, has its starting and ending time in the current file (textgrid, vocal-pitch)
writeInfoLine()

mos=numberOfSelected ("TextGrid")
printline m='mos'

for i to mos
    textgrid'i'=selected("TextGrid",i);
    printline textgrid'i'
endfor


for k from 1 to mos
	select textgrid'k'
	filename$=selected$("TextGrid")
	noi=Get number of intervals... 6
	csvname$=filename$+".csv"
	writeFileLine(csvname$, "time_start,time_end,pitch_con,duration,artist,role_type,shengqiang,tone,word")

	#get role type and shengqiang from name of file
	first_underscore=index(filename$,"_")
	#first_dash=index(filename$,"-")
	#length=length(filename$)
	roletype$=left$(filename$,first_underscore-1)
	shengqiang$=mid$(filename$,first_underscore+1,1)

	#get artist
	artist$=Get label of interval... 1 1

	for i from 1 to noi

		label$=Get label of interval... 6 i
		if label$!="ac"
			start=Get start point... 6 i
			end=Get end point... 6 i
			duration=end-start
			#get tone
			tone$=right$(label$,1)
			#pitch_con_id
			pitch_con_id$=tone$+"_"+string$(k)+"_"+string$(i)
			appendFileLine(csvname$,start,",",end,",",pitch_con_id$,",",duration,",",artist$,",",roletype$,",", shengqiang$,",",tone$,",",label$)



		endif

	endfor
printline finished writing 'csvname$'
endfor

