import os
from os import listdir

scriptpath = os.path.dirname(os.path.realpath(__file__)) + os.sep
userdir = scriptpath + "users" + os.sep

userfiles = [ f for f in listdir(userdir) if isfile(join(userdir,f)) ]
for i in userfiles:
	print i