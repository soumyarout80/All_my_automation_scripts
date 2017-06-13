#!/bin/bash

#####################################################################################################################################
#Author:Soumya Ranjan Rout
#Syntax to run the scipt:[[./myscript.sh 172.31.12.187 172.31.1.115 172.31.1.224 172.31.2.251]] after this it will ask for file path.
#The servers must have key less authentication:ssh-keygen,ssh-copy-id username@remote_host
#This script is tested on ubuntu machine
####################################################################################################################################

usage()
{
echo "******************************************************************************************************"
echo -e "Example to run the script:\nsh scriptname.sh  172.31.12.187 172.31.1.115 172.31.1.224 172.31.2.251 \n
Enter the full path of the file you want to copy:/home/soumya/script.sh\n"
echo "******************************************************************************************************"
}

#checking all arguments are velid or not
for i in `echo "$*"`
do
if [[ $i =~ 25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]? ]]
then
echo "$i is a valid ip " >/dev/null 2>&1
else
echo -e "********************************\n$i is a bad argument"
echo -e "Program Termineted........\nPlease run the script again with valid ip address\n********************************"
exit 0
fi
done

#Creating a loop for user to input file path
while true

do

read -p "Enter the full path of the file you want to copy:" PathOfFile

#Checking for file it should not be null or invalid.
if [[ -z "$PathOfFile" ]] || [[ ! -f "$PathOfFile" ]]

 then
     echo " "
     echo "You have to enter here the path of the file,It should not be blank or Invalid [Enter again file name/path below]"
     usage
     continue
 else
    break
fi

done
#Scp command to copy file from local to remote.
scp $PathOfFile soumya@$1:

echo "File:$PathOfFile copyed to the server:$1 "
#Nested for loop to Copy file from one server to another server Recurcively.
for i in `echo "$*"`

 do

   for j in `echo "${@:2}"`

     do
#Scp command to copy file from one server to another server.
ssh  soumya@$i "scp $PathOfFile soumya@$j:" >/dev/null 2>&1

    done

 done


echo -e "***************************************************\nFile:$PathOfFile\ncopyed to the serves:$@\n***************************************************"

#End of the script
