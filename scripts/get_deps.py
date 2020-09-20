import sys
import os.path

path = sys.argv[1]
this_type = sys.argv[2]

dirs = path.split("/")

deps = ""

for ind in range(len(dirs)):
    if dirs[ind] not in ['proof', 'note', 'topic', 'definition']:
        deps += '{}/{} '.format("/".join(dirs[0:ind + 1]), "defs.tex".format(dirs[ind]))

if (this_type == "tree") or (this_type == "tree_online"):
    deps += "{}/ref.tex ".format(path)

deps += "{}/preamble.tex ".format(dirs[0])

print(deps, end='')
