import sys

path = sys.argv[1]
path_split_fmt = []
path_split = path.split("/")

types = {"proof", "note", "topic", "definition"}

links = []
curr_type = ""
for dir_i, dir in enumerate(path_split):
    if dir_i == 0:
        continue
    if dir in types:
        curr_type = dir
    else:
        link_str = dir.replace("_", "\\_")
        this_path = ref_path = "/".join(path_split[0:dir_i + 1])
        if dir_i < len(path_split) - 1:
            ref_path = "/".join(path_split[0:dir_i + 3]) + "_"
        link_str = "\\lngh{{{}}}{{{}}}{{{}}}".format(this_path, ref_path, "\\{}d[black]/".format(curr_type) + link_str)

        path_split_fmt.append(link_str)

archives_link = "\\lngraw{{{}}}{{{}}}".format(path_split[0], "/")

path = "\colorbox{{__gray}}{{{{\\tt{{}}{0}}}}}".format(archives_link + "/".join(path_split_fmt))
print(path)

try:
    sys.stdout.close()
except:
    pass
try:
    sys.stderr.close()
except:
    pass
