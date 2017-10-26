

import sys
import os
import json
import time

print "Name of the script:-",sys.argv[0]
print "Number of the arguments passed to the script" ,len(sys.argv)-1
print "The arguments are",str(sys.argv[1:])
length=len(sys.argv)-1
i=0
a=0
d={}
while i<length:
    print "Arguments",sys.argv
    d["string{0}".format(i)]="Hello"
    a=a+1
    print  a
    i+=1
print d




l1=['a','b','c','d','e','f','g','h','i','j']
l2=[1,2,56,90,76,23,42,56,89,45]
d1=dict(zip(l1,l2))
print "List-1",l1,"List-2",l2
print "Creating a dictionary from above two list......"+'\n'

print "Dictionary",d1
print "\n"

print "Searching in dictionary if value of the dictionary is greter then 55!"
for i,j in d1.iteritems():
    if j>55:
        print i,j

print json.dumps({'success': True, 'data': [d1]})


