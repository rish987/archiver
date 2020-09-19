import sys
import os.path
print(os.path.relpath(sys.argv[2], sys.argv[1]) + "/ref.pdf")

try:
    sys.stdout.close()
except:
    pass
try:
    sys.stderr.close()
except:
    pass
