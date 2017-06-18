#!/usr/bin/env python
# -*- coding: utf-8 -*-

# for SSH
from paramiko import SSHClient
from paramiko import AutoAddPolicy
# for versioning
import datetime
# for file operations
import os
# for sleep
import time

host = '1.2.3.4'
user = 'root'
password = 'pass'
port = 22

sshCli = SSHClient()
sshCli.set_missing_host_key_policy(AutoAddPolicy())
dfH = 'df -h'

try:
        print "connecting.." + host + "@"  + user + ":" + password
        sshCli.connect(hostname=host, username=user, password=password, port=port)
        print "connected.."
        # creating local backup
        stdin, stdout, stderr = sshCli.exec_command(dfH)
        data = stdout.read() + stderr.read()
        sshCli.close()
        print data
except:
print "Error connecting to host", host
