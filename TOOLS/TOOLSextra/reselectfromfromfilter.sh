

file1=''
file2=''

#go through all the arguments
for i in $*
do
  #trying to find .dat
  text=`echo "aaaa$i" | rev | cut -c-4 | rev`
  if [ "$text" == ".dat" ]
  then
    if [ ! -e $i ]
    then
      echo "$scriptfile: error - $i does not exist. EXITING"
      exit
    fi
    if [ -z "$file1" ]
    then
      #the lower one
      file1=$i 
    else 
      #the higher one
      file2=$i
    fi
    continue
  fi
done
echo "reselectfromfromfilter.sh: " $file1 $file2

file1FILTERED=`echo $file1 | rev | cut -c5- | rev`_FILTERED.dat

row=`grep "$file1" FILTER.txt | tail -n 1` 
Dradius=`echo $row | awk '{print $5}'`
#Dxmin=`echo $row | awk '{print $7}'`
Dxd=`echo $row | awk '{print $8}'`
#Dymin=`echo $row | awk '{print $9}'`
Dyd=`echo $row | awk '{print $10}'`

#######################
###
#######################
MINIMAmax=`wc -l $file2 | awk '{print $1}'`
STRUCTURES=$MINIMAmax
total=`echo $STRUCTURES+$MINIMAmax | bc`
POSIBLE=`wc -l $file1 | awk '{print $1}'`
if [ $POSIBLE -lt $total ]
then
  STRUCTURES=`echo $POSIBLE-$MINIMAmax | bc`
fi
for MINIMA in `seq 1 $MINIMAmax`
do
  echo "MINIMA = $MINIMA" 
  xyz=`cat $file2 | sort -nrk 3 | tail -n $MINIMA | head -n 1 | awk '{print $1}'`
  com=$(echo $xyz | rev | cut -c5- | rev).com
  dir0=`pwd`
  dir=$(basename $dir0)
  xyzORIG=`grep "$dir" $com`
  
  rowORIG=`grep $xyzORIG $file1`
  Org=`echo $rowORIG | awk '{print $2}'`
  Oen=`echo $rowORIG | awk '{print $3}'`
  
  rows=`wc -l $file1 | awk '{print $1}'`
  #echo $rows
  for i in `seq 1 $rows`
  do
    rowcheck=`head -n $i $file1 | tail -n 1`
    #echo $rowcheck
    name=`echo $rowcheck | awk '{print $1}'`
    CHrg=`echo $rowcheck | awk '{print $2}'`
    CHen=`echo $rowcheck | awk '{print $3}'`
    #testing
    #echo $CHrg $CHen $Org $en $Dradius `echo "($CHrg-1.0*$Org)/$Dxd" | bc -l` `echo "(($CHen-1.0*$Oen)/$Dyd)" | bc -l ` 
    st1=`echo "(($CHrg-1.0*$Org)/$Dxd)^2+(($CHen-1.0*$Oen)/$Dyd)^2 < $Dradius^2" | bc -l`
    #echo $st1
    if [ $st1 -eq 1 ]
    then
      Talredycalculated=`grep -c "$name" $file1FILTERED`
      if [ $Talredycalculated -eq 0 ]
      then
        echo $rowcheck >> $file1FILTERED
        STRUCTURES=`echo $STRUCTURES-1 | bc`
        if [ $STRUCTURES -le 0 ]
        then
          break
        fi
      fi
    fi    
  done
  if [ $STRUCTURES -le 0 ]
  then
    break
  fi
done
