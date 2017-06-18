read -p "Enter Values That You Want To Sort(eg. 3 2 1):" vals
 
set -- $vals
n=$# 
k=0
for val in $* 
do
    a[$k]=$val
    ((k++))
done
 
flag=1
 
for (( i=0; i<$n-1 && $flag==1; i++ ))
do
    flag=0
    for (( j=0; j<$n-i-1; j++ ))
    do
        if [ ${a[$j]} -gt ${a[$j+1]} ]
        then
            temp=${a[$j]}
            a[$j]=${a[$j+1]}
            a[$j+1]=$temp
            flag=1
        fi
    done
done
 
echo "Sorted: "
for (( l=0; l<$n; l++))
do
    echo -ne "${a[$l]} "
done
 
echo

do_file_action(){
  echo
  echo "Do you want to perform this change?"  
  read -p "[Y] Yes [N] No [?] Help (Default is \"Y|y\"):" answer

  if [[ $answer = yes ]]
  then echo "you enter yes"
  exit 0
      elif [[ $answer = no ]]
      then echo "Exiting Program"
      exit 0
      fi
}

do_file_action
