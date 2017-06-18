#! /usr/bin/env python

import sys, re

"""
Verifies email address. Valid email addresses
must meet the following requirements:
	Usernames can contain:
		letters (a-z)
		digits (0-9)
		dashes (-)
		underscores (_)
		apostrophes (')
		periods (.)
	usernames must start with an alphanumeric character
"""

email_address = sys.argv[1]

emailRegex = re.compile(r'''(
	[a-zA-Z0-9]+
	[a-zA-Z0-9-_'.]*
	@
	[a-zA-Z]+
	(\.[a-zA-Z]{2,4})
	)''', re.VERBOSE)

isValid = emailRegex.match(email_address)

if(isValid) :
	print "valid email"
else :
	print """
	Valid email addresses must meet the following requirements:
	Usernames can contain:
		letters (a-z)
		digits (0-9)
		dashes (-)
		underscores (_)
		apostrophes (')
		periods (.)
	Usernames must start with an alphanumeric character 
	"""
