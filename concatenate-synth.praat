#this script concatenate all the one contour synth into a big file with silence inserted and also writes (append) the tone info sequentially into a textfile
#later, this is used for running PENTATrainer
#/Applications/Praat.app/Contents/MacOS/Praat

directory$ = "/Users/zangsir/Desktop/synth2"
strings = Create Strings as file list: "list", directory$ + "/*.wav"
numberOfFiles = Get number of strings

#create a silence sound and initialize newSound to silence
sampling_frequency=16000
newSound = Create Sound from formula... silence 1 0 0.3 sampling_frequency 0


for ifile to numberOfFiles

    #get the file name to read in
    selectObject: strings
    fileName$ = Get string: ifile
    #read in one file
    printline read in 'fileName$'
    sound = Read from file: directory$ + "/" + fileName$
    silence = Create Sound from formula... silence 1 0 0.3 sampling_frequency 0
    #concatenate
    select newSound
    plus sound
    plus silence
    newSound = Concatenate
    removeObject: sound, silence
endfor

output_directory$="/Users/zangsir/Desktop"
fileName$="concatSynth2.wav"
select newSound
Save as WAV file: output_directory$ + "/" + fileName$


