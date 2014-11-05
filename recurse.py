#this short script demos the use of recursive structure in finding the first number
#greater than 10 by incrementing a.
a=6
def compare(a):
	test=a
	if test>10:
		print "good"
		print a

	else:
		a=a+1
		compare(a)
