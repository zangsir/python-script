#this script extract 30 pitch points for each pitch contour
#this is originally written for the 20-arias study in beijing opera ismir 2014

writeInfoLine()
nos=numberOfSelected ("Sound")
echo n='nos'
mos=numberOfSelected ("TextGrid")
#printline m='mos'

if nos!=mos
exit ERROR!PLEASE MAKE SURE YOU SELECTED THE SAME NUMBER OF SOUND AND TEXTGRID FILES.
endif

#printline
#printline List of Sound Files

for i to nos
    sound'i' = selected ("Sound", i);
    #printline sound'i'
endfor

#printline
#printline List of TextGrid Files

for i to mos
    textgrid'i'=selected("TextGrid",i);
    #printline textgrid'i'
endfor
#printline
writeFileLine("tonex.csv", "time,pitch,word,pitch_con,duration,banshi,artist,role_type,shengqiang,position")

for k from 1 to nos
	#create pitch object for the current sound file
	select sound'k'
	pitch_obj=do("To Pitch (ac)...", 0.01, 75, 15, "yes", 0.03,0.57,0.1,5,2,1000)
	
	#loop through intervals
	select textgrid'k'
	label$=selected$("TextGrid")

	#get the tone category from textgrid name
	first_digit=index_regex (label$, "\d")
	tone_cat$=mid$(label$,first_digit,1)
	num_tiers=Get number of tiers

	noi=Get number of intervals... 1
	
	#for each interval, compute pitch track, list info with each pitch point
	for j from 1 to noi
		select textgrid'k'
		#get the label of the current interval, and all other relevant info associated with the current pitch contour
		int_label$=Get label of interval... 1 j
		banshi$=Get label of interval... 2 j
		artist$=Get label of interval... 3 j
		role_type$=Get label of interval... 4 j
		shengqiang$=Get label of interval... 5 j
		position$=Get label of interval... 6 j
		if position$=""
			position$="other"
		endif

		if int_label$!="silent"
			#printline label is 'int_label$'
			start_time=Get start point... 1 j
			end_time=Get end point... 1 j			
			duration=end_time-start_time
      
      
			select pitch_obj

			start_frame=Get frame number from time... start_time
			end_frame=Get frame number from time... end_time
            
            
			##printline start_frame='start_frame'
			##printline end_frame='end_frame'
			
            
            call FindBoundary start_frame end_frame
			#printline start_frame_true='true_frame_start'
			#printline end_frame_true='true_frame_end'
            
            #if there is indeed a start and end found
            if is_empty=0
                hopsize=(true_frame_end-true_frame_start)/30 
				#try no rounding
    			#assign a ID for the current pitch contour (of this token of interval)
    			pitch_con_id$=tone_cat$+"_"+string$(k)+"_"+string$(j)
    			call ComputePitch true_frame_start true_frame_end hopsize
            endif
		endif
	endfor

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
	#time=Get time from frame number... frame_number
	time=i+1
    if pitch$!="--undefined--"
        #printline writing pitch...
		appendFileLine("tonex.csv", time,",",pitch$,",",int_label$,",",pitch_con_id$,",",duration,",",banshi$,",",artist$,",",role_type$,",",shengqiang$,",",position$)
   	endif
    prev_pitch=pitch
endfor

#undefined pitch is omitted in this case
endproc



procedure FindBoundary frame_start frame_end

pitch_temp=Get value in frame... frame_start Hertz
pitch_temp$=string$(pitch_temp)
true_frame_start=frame_start

while pitch_temp$="--undefined--" and true_frame_start<frame_end
    true_frame_start=true_frame_start+1
    pitch_temp=Get value in frame... true_frame_start Hertz
    pitch_temp$=string$(pitch_temp)
endwhile
##printline pitch_temp is 'pitch_temp$'
#found true frame start

#if there is indeed a start, we will look for an end too
if pitch_temp$!="--undefined--"
    is_empty=0
#now find frame end
    pitch_temp_end=Get value in frame... frame_end Hertz
    pitch_temp_end$=string$(pitch_temp_end)
    true_frame_end=frame_end

    while pitch_temp_end$="--undefined--" and true_frame_end>frame_start
        true_frame_end=true_frame_end-1
        pitch_temp_end=Get value in frame... true_frame_end Hertz
        pitch_temp_end$=string$(pitch_temp_end)
    endwhile
else
    is_empty=1

endif


endproc