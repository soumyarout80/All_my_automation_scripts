@echo off
for /l %%c in (1,1,6) do (
   echo *** stop test0%%c
   cd e:\vagrant\test0%%c
   vagrant halt
)
cd e:\vagrant