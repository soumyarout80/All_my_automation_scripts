echo
i=1
k=1
echo "Enter no. of integers to be sorted"
read n
echo
echo "Enter the numbers"while [ $i -le $n ]
do
read num
x[$k]=`expr $num`
i=`expr $i + 1`
k=`expr $k + 1`
done
x[$k]=0
k=1
echo
echo "The number you have entered are"while [ ${x[$k]} -ne 0 ]
do
echo "${x[$k]}"
echo
k=`expr $k + 1`
done
k=1
while [ $k -le $n ]
do
j=1
while [ $j -lt $n ]
do
y=`expr $j + 1`
if [ ${x[$j]} -gt ${x[$y]} ]
then
temp=`expr ${x[$j]}`
x[$j]=`expr ${x[$y]}`
x[$y]=`expr $temp`
fi
j=`expr $j + 1`
done
k=`expr $k + 1`
done
k=1
echo
echo "Number in sorted order..."
echo
while [ ${x[$k]} -ne 0 ]
do 
echo "${x[$k]}"
echo 
k=`expr $k + 1`
done
