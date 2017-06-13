#!/bin/bash

# First Check the Server Installed Versions:
for i in  {1..10} {15..20} {21..30} {31..31} {33..35} {46..50} {51..60} {62..70} {71..80} {111..115} {117..120} {121..125} {126..130} {131..135} {139..148} {155..160} {181..199} {227..230};
do
  echo -n Checking Host: myapp-app$i.nm.project.com:    
   ssh myapp-app$i.nm.project.com " df -k | grep var | tail -1 | awk '{print \$(NF-1)}'"
done

for i in {1..12} ;
do
  echo -n Checking Host: myapp-app-completions$i.nm.project.com:    
   ssh myapp-app$i.nm.project.com " df -k | grep var | tail -1 | awk '{print \$(NF-1)}'"
done

