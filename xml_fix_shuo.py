import re, sys, fileinput
#get file from command line with fileinput.input() and iterate over the lines
for line in fileinput.input():

    lists = ["<text id=""(.*)"">","</text>","<heading>","</heading>","<list>","</list>","<quote>","</quote>","<fnote","</fnote>","<enote>","</enote>","<abstract>","</abstract>"]   
    #make this regex so this will return true if any above is matched
    combined = "(" + ")|(".join(lists) + ")"
    if re.match(combined,line):
        sys.stdout.write(line)
    elif line.startswith("<"):
        line1 = line.replace("<", "lt ").replace(">", " gt")
        sys.stdout.write(line1)
    else:
        sys.stdout.write(line)
