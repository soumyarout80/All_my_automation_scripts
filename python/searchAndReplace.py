#This script goes into an input text file, performs search and replace, and exports output file

import os
import csv

#Create dictionary of Replacements pairs
Replacements = {}
for i in range(2501,3001):
	Str1 = str(i)
	Str2 = str(i+2000)
	Replacements[Str1] = Str2
	#print Str1 + ':' + Replacements[Str1]
#Replacements = {'2501':'4501', '2502':'4502'}
#print Replacements['2501']

FolderPath = 'Logs/2016-12-07 Laglace PLC-200 HAZOP Variables/'
InputFile = FolderPath + 'variables.txt'
OutputFile = FolderPath + 'new_' + InputFile
LogFile1 = FolderPath + 'LogFile1.txt'
LogFile2 = FolderPath + 'LogFile2.txt'
ReplaceFile = FolderPath + 'ReplaceList.csv'

#Generate LogFile of all Replacements and then look through this file to decide which Replacements should and should not occur
LineNum = 0
with open(LogFile1, 'w') as logfile:
	logfile.write('Line|Source|Target|XML String\n') #Headers for Log File
	with open(InputFile) as infile:
	# with open('InputFile.txt') as infile, open('OutputFile.txt', 'w') as outfile:
		for line in infile:
			LineNum = LineNum + 1
			for src, target in Replacements.iteritems():
				line_old = line
				line = line.replace(src, target)
				if line_old <> line:
					logfile.write(str(LineNum)+'|'+src+'|'+target+'|'+line_old) #Log all lines where Replacements occur


#Fill ReplaceList from ReplaceList.csv, Delimiter is ','. These are the Lines/Source pairs that need to match in order for replacement to occur
ReplaceList = [] #Initialize List
with open(ReplaceFile, 'r') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',')
    for row in csvreader:
		ReplaceList.append(row) #0=Line Num, 1=Source, 2=Target		

#Replace Lines only if they meet criteria from ReplaceList
#The ReplaceList iterations can be made more efficient to reduce script time
LineNum = 0
with open(LogFile2, 'w') as logfile:
	logfile.write('Line|Source|Target|XML String\n') #Headers for Log File
	with open(InputFile) as infile, open(OutputFile, 'w') as outfile:
		for line in infile:
			LineNum = LineNum + 1
			for row in ReplaceList:
				line_old = line
				RLine = row[0]
				if RLine == str(LineNum):
					RSource = row[1]
					RTarget = row[2]
					line = line.replace(RSource, RTarget)
				if line_old <> line:
					logfile.write(str(LineNum)+'|'+RSource+'|'+RTarget+'|'+line_old) #Log all lines where Replacements occur
			outfile.write(line)
			
#Open Text File in Notepad	
# osCommandString = "notepad.exe C:\Users\mike.boiko\Documents\Code\Python\Search and Replace in File\OutputFile.txt"
# os.system(osCommandString)
# osCommandString = "notepad.exe C:\Users\mike.boiko\Documents\Code\Python\Search and Replace in File\LogFile.txt"
# os.system(osCommandString)

