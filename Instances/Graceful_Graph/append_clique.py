import re
import sys

def intTerms(atom):	
	"""
	When sorting the atoms, consider the integer value of the terms
	"""	
	terms = re.search('\((.*)\)', atom)
	if terms is None: 
		return int(atom)
	else:
		return [int(term) for term in re.findall('(\d+)',terms.group(1))]

t = sys.argv[1].split(' ')
t.sort(key=intTerms, reverse=False)
t=[re.sub('[^0-9,]', "", i).split(',') for i in t]
t=[a for [a,b] in t  if b=='1']
print(" ".join(["clique({},{}).".format(a,id+1) for (id,a) in  enumerate(t)]))
 