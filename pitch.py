#modified by shuo zhang, original by ken chen
#put this script in the same directory as the 20 aria wav files
import essentia.standard as es
import sys
import numpy as np
from os.path import exists
import glob
#from scipy.io.wavfile import read

#get all wav files in this directory into a list
wavFiles = []
for filename in glob.glob('*.wav'):
    print(filename)
    wavFiles.append(filename)
#usage: python pitch.py pitchDir wavFiles

#pitchDir = sys.argv[1].rstrip("/")
#wavFiles = sys.argv[2:]

#the mbid corresponding to the title of the wavfile will be used to name the resulting pitch track file
mbid_all={"D_X-1": "61dd663f-77b8-423b-8ce9-4c40fee8b014","D_X-2": "a00666b5-07ef-40c8-8117-78b871569354","D_E-1": "f6339039-e01a-4a70-82ff-001c64fecddd","J_X-1": "bc86b730-b7bb-46ba-a771-2d0e6304b459","J_X-2": "a9896439-46ce-4a37-a6ed-3a5c998bd6cf","J_E-1": "b19d1921-9119-4a57-8c78-540ca09f09b9","J_E-2": "720e93d6-21b5-4026-8c50-5c415cca53ec","LD_X-1": "5593350d-4a2d-4288-b3c6-b57b7f3c8dd4","LD_X-2": "afd9da3d-418b-4dfc-85d4-6d5829b9c7e2","LD_E-1": "f581a2b2-ff94-4e03-91f8-d278b01d6fc4","LD_E-2": "67069b89-fe41-4509-9aba-5cc33d9c8e53","LS_X-1": "cdbf88f4-7a55-412e-b4b2-351f4c8aab49", "LS_X-2": "4a0fc23c-9c62-4b2e-a38a-124796c6ac5d","LS_E-1": "999917df-2282-49d4-ad95-e45d176fba64","LS_E-2": "26054c12-3578-4d64-a251-f8f694fbc41c","XS_X-1":      "e9794b6f-a797-4d7f-842a-a0c73639c2a5","XS_X-2": "206d833f-b194-40cc-92d1-7a632fbef603","XS_E-1": "aec9929b-69b4-4ca5-b998-f4d54ac426cb","XS_E-2": "01661eb4-114d-4671-af82-14b8fead56e1"}
#print pitchDir
hopSize = 128
frameSize = 2048
sampleRate = 44100
guessUnvoiced = False
for f in wavFiles:
    if ".wav" not in f.lower(): continue
    
    #mbid = f.split("/")[-1][:-4]
    #if exists(pitchDir+"/"+mbid+".txt"): continue
    #find the mbid to be used to name the resulting pitch track
    name=f.split("_")[0]+"_"+f.split("_")[1]
    print name
    mbid=mbid_all[name]
    print mbid
    
    loader = es.EasyLoader(filename=f, sampleRate=44100)
    equalLoudness = es.EqualLoudness(sampleRate=44100)
    audio = loader()
    audioDL = equalLoudness(audio)
    pitchPolyphonic = es.PredominantMelody(binResolution=1, guessUnvoiced=guessUnvoiced, hopSize=hopSize, minFrequency=100, maxFrequency = 1200, voicingTolerance = 1.2)
    res = pitchPolyphonic(audioDL)
    t = np.linspace(0, len(res[0])*128.0/44100, len(res[0]))
    data = zip(t, res[0], res[1])
    data = np.array(data)
    np.savetxt(mbid+".txt", data, delimiter="\t")
