import sys

seen = set()

for line in sys.stdin:
    ln = line.replace('\n','')
    t = tuple(sorted(ln.split(' ')))
    if (t not in seen) or (len(t) < 3):
        print(ln)
        seen.add(t)