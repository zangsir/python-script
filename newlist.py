def normalize(list,n):
	hopsize=n/35
	newlist=[]
	k=0
	for i in range(30):
		if float(list[k][1])!=0:
			newlist.append(list[k])
		else:
			n=find_non_zero(list,k)
			newlist.append(list[n])
		k=k+hopsize
	return newlist