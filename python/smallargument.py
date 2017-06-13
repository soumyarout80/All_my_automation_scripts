

#!/user/bin/python

import sys

if len(sys.argv) <= 1: 
 print "Sorry!!!! you have enter zero argument please enter values in below"
 value1 = raw_input('please enter  first value:') ; value2 = raw_input('please enter  second value:') ; value3 = raw_input('please enter  third value:')

print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Arguments list:', str(sys.argv)
print 'Script name:', sys.argv[0]
print 'sum:', int(sys.argv[3])+int(sys.argv[2])
      
file_name = raw_input("Enter file name:")
if len(file_name) == 0:
   print "Next time please enter some thing"
try:
   file = open(file_name, "r")
except IOError:
   print "There was an error reading file"
#   sys.exit()
file_text = file.read()
file.close()
print file_text
Total = sys.argv[2] + \
        sys.argv[3] +\
        sys.argv[4]
print 'Value is :', Total

