@echo off
for /l %%c in (1,1,4) do (
   echo *** copying keys from test0%%c
   copy  e:\vagrant\test0%%c\.vagrant\machines\default\virtualbox\private_key e:\vagrant\test0%%c\pk_test0%%c
   )
