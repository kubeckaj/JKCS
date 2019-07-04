#CALCULATE NUMBER OF ELEMENTS
function Felements {
  N=0
  for i in $*
  do
     N=`echo $N+1 |bc`
  done
  echo $N
}

# JKCS1 - replace brackets by number in composition 
function Cbrackets {
  input="$1"
  if [[ "$input" == *"("*")"* ]];
  then
    n1=$(echo $(expr index "$input" "\("))
    n2=$(echo $(expr index "$input" "\)"))
    n1p=`echo $n1+1 |bc`
    n2p=`echo $n2+1 |bc`
    diff=`echo $n2-$n1p | bc`
    if [ $n1 -eq 0 ]
    then
      before=''
    else
      n1m=`echo $n1-1 |bc`
      before=`echo ${input:0:$n1m}`
    fi
    in=`echo ${input:$n1:$diff} | sed 's/,/ /g'`
    after=`echo ${input:$n2}`
    output=''
    for i in $in
    do
      new=$before$i$after
      output+=" $new"
    done
    output2=''
    for j in $output
    do
      output20=`Cbrackets "$j"`
      output2+=" $output20"
    done
    echo $output2
  else
    echo "$input"
  fi
}

# JKCS1 - replace dash by serie
function Cdash {
  input="$1"
  if [[ "$input" == *"-"* ]];
  then
    c="$input"
    n1=$(echo $(expr index "$input" "-"))
    n1m=$(echo $n1-1|bc)
    t1=`echo ${c:0:$n1m}`
    if [[ "$t1" == *"_"* ]];
    then
      F1=`echo ${t1%_*}`;
      F1="${F1}_"
      l=${#F1};
      F2=`echo ${t1:$l} `;
    else
      F1=""
      F2="$t1"
    fi
    t2=`echo ${c#*-}`;
    if [[ "$t2" == *"_"* ]];
    then
      F4=`echo ${t2#*_}`;
      n1=$(echo $(expr index "$t2" "_"))
      n1m=`echo $n1-1 | bc`
      F3=`echo ${t2:0:$n1m}`;
      F4="_${F4}"
    else
      F3="$t2"
      F4=""
    fi
    output=''
    for j in `seq $F2 $F3`
    do
      output+=" $F1$j$F4"
    done
    output2=''
    for i in $output
    do
      output2h=`Cdash $i`
      output2+=" $output2h"
    done
    echo $output2
  else
    echo "$input"
  fi
}

function strindex { 
    local str=$1
    local search=$2
    let local n=1
    local retval=1 # here, 1 is failure, 0 success
    Qfound=0
    for col in $str; do # $str unquoted -> whitespace tokenization!
      if [ $col = $search ]; then
        echo $n
        Qfound=1
        break
      else
        ((n++))
      fi
    done
    if [ $Qfound -eq 0 ]; then echo -1; fi
}
