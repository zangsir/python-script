#we copied results from "repeat.csv" to the qTA parameter file, meng-penta-part1.csv
#they should line up in the same order.
#we can use m to generate the full data file from original single line file
entries=csv.reader(open("meng-penta-part1.csv","rU"))
next(entries)

with open("qta-full.csv","a") as f:
	writer=csv.writer(f)
		

	for row in entries:
		for i in range(int(row[6])):
			writer.writerow(row)



