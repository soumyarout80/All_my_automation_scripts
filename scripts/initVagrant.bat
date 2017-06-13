@echo off
for /l %%c in (1,1,4) do (
   echo *** init in directory test0%%c
   cd test0%%c
   vagrant init  ubuntu/trusty64
)
cd e:\vagrant 