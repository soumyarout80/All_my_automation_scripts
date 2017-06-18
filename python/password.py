#!/usr/bin/env python

import sys, re
    
"""
 Verifies the strength of the given password.
 The password must contain:
    8 characters length or more
    1 digit or more
    1 symbol or more
    1 uppercase letter or more
    1 lowercase letter or more
    """

password = sys.argv[1]

# calcules the length
length_error = len(password) < 8

# search for digits
digit_error = re.search(r"\d", password) is None

# search for uppercase
uppercase_error = re.search(r"[A-Z]", password) is None

# search for lowercase
lowercase_error = re.search(r"[a-z]", password) is None

# search for symbols
symbol_error = re.search(r"[ !#$%&'()*+,-./[\\\]^_`{|}~"+r'"]', password) is None

# overall result
password_ok = not ( length_error or digit_error or uppercase_error or lowercase_error or symbol_error )

if not password_ok :
    print "password must contain: "
    if length_error :
	   print "\tat least eight characters"
    if digit_error :
	   print "\tat least one digit"
    if uppercase_error :
	   print "\tat least one uppercase letter"
    if lowercase_error :
	   print "\tat least one lowercase letter"
    if symbol_error :
	   print "\tat least one special symbol"
else :
print "password accepted"
