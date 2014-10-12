#writes unique keys and their numPoints into csv(no order)
for key in per_label:
	pairs=[key,len(per_label[key])]
	

	#append z to columns of a csv file
	with open("pair.csv","a") as f:
		writer=csv.writer(f)
		writer.writerow(pairs)