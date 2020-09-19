import sys
import os.path

path = os.path.relpath(sys.argv[1], sys.argv[2]) 

dirs = path.split("/")

for ind in range(len(dirs)):
    if dirs[ind] not in ['proof', 'note', 'topic', 'definition']:
        print('\\input{{\\root/{}{}}}'.format("/".join(dirs[0:ind + 1]), "/defs.tex"))

try:
    sys.stdout.close()
except:
    pass
try:
    sys.stderr.close()
except:
    pass
