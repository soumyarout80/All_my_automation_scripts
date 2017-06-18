
#! /usr/bin/env python

import sys, re

""" 
Verifies phone number. Phone number must contain
the following:
	optional country code +XXX
	optional parenthesis for area code (XXX)
	three to four digits 
	three to four digits
	two to five digit extension
"""

phone_number = sys.argv[1]

phoneRegex = re.compile(r'''(
	(\+\d{2,4})?
	(\s|-|\.)?
	(\d{3}|\(\d{3}\))? # area code
	(\s|-|\.)?
	(\d{3,4})
	(\s|-|\.)?
	(\d{3,4})
	(\s*(ext|x|ext.)\s*(\d{2,5}))?
	)''', re.VERBOSE)

isValid = phoneRegex.match(phone_number)

if(isValid) :
	print "phone number is valid"
else :
	print """
	Phone number must contain the following:
		optional country code +XXX
		optional parenthesis for area code (XXX)
		three to four digits 
		three to four digits 
		two to five digit extension
	"""
