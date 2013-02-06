import re
ll = re.match('hello[ \t]*(.*)world','hello      python world')
print ll.groups()
