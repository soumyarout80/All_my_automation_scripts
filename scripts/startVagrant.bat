@echo off
for /l %%c in (1,1,4) do (
   echo *** start test0%%c
   cd e:\vagrant\test0%%c
   vagrant up
)
cd e:\vagrant