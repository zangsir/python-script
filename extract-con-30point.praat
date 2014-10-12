sound=selected("Sound")
textgrid=selected("TextGrid")

	#create pitch object for the current sound file
	select sound
	pitch_obj=do("To Pitch (ac)...", 0.005, 55, 15, "yes", 0.03,0.15,0.01,0.95,0.14,700)
	
	select textgrid
	label$=selected$("TextGrid")
	filename$=label$+".csv"

	writeFileLine(filename$, "time,pitch,tone,pitch_con,duration")

	#here you should put whichever is the tone segmentation tier
	tier=1
	noi=Get number of intervals... tier
	
	#for each interval, compute pitch track, list info with each pitch point
	for j from 1 to noi
		select textgrid
		#get the label of the current interval, and all other relevant info associated with the current pitch contour
		int_label$=Get label of interval... tier j
		

		if int_label$!="" and int_label$!="5" and int_label$!="5r"
			start_time=Get start point... tier j
			end_time=Get end point... tier j			
			duration=end_time-start_time
			select pitch_obj

			start_frame=Get frame number from time... start_time
			end_frame=Get frame number from time... end_time
			hopsize=(end_frame-start_frame)/31
			#assign a ID for the current pitch contour (of this token of interval)
			pitch_con_id$=label$+"_"+int_label$+"_"+string$(j)
			call ComputePitch start_frame end_frame hopsize
		endif
	endfor

printline finished writing csv...





#===================procedures========================
procedure ComputePitch frame_start frame_end hopsize
for i from 0 to 29
	#printline hopsize='hopsize'
    frame_number=frame_start+i*hopsize
    #printline frame number is 'frame_number' 
    if frame_number>frame_end
        printline Warning: frame_number 'frame_number' > end_frame 'frame_end' at time 'start_time' to 'end_time'
    endif
	#printline computing pitch...
    pitch=Get value in frame... frame_number Hertz
	pitch$=string$(pitch)
    if pitch$="--undefined--"
        pitch=prev_pitch
        pitch$=string$(pitch)
    endif
	#before:time=Get time from frame number... frame_number
	#now:just write 1 to 30 for time
	time=i+1
    if pitch$!="--undefined--"
        #printline writing pitch...
		appendFileLine(filename$, time,",",pitch$,",",int_label$,",",pitch_con_id$,",",duration)
   	endif
    prev_pitch=pitch
endfor

#undefined pitch is omitted in this case
endproc


