#!/bin/bash -l
#SBATCH -p serial
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 72:00:00
#SBATCH -J xtb
#########SBATCH --mem-per-cpu=3000
#SBATCH -e xtb.out
#SBATCH -o xtb.out

### run as:
### sbatch /wrk/kubeckaj/DONOTREMOVE/Apps/XTB/JKxtb.sh <file> <options>
### possibility to use command -inp file

Qprograms=programs.txt
what=""
opt=""
last=""
for i in $*
do
  ### -inp
  if [ "$last" == "-inp" ]
  then
    Qinp=$i
    last=''
    continue
  fi
  if [ "$i" == "-inp" ] || [ "$i" == "-i" ]
  then
    last="-inp"
    continue
  fi
  # programs
  if [ "$last" == '-programs' ]
  then
    last=''
    if [ "$i" == 2 ]
    then
      Qprograms="programs2.txt"
    else
      Qprograms="$i"
    fi
    continue
  fi
  if [ "$i" == "-programs" ]
  then
    last='-programs'
    continue
  fi
  ### 
  last4=`echo "aaaa$i" | rev | cut -c-4 | rev`
  if [ "$last4" == ".xyz" ]
  then
    what+=" $i"
  else
    opt+=" $i"
  fi
done

###############################################################################
################################ MAIN PROGRAM #################################
############################### DO NOT TOUCH #################################
###############################################################################

# locate TOOLS path
scriptpath=$(dirname $0)
toolspath="$scriptpath/../"

# load names
source $toolspath/TOOLSextra/names.txt

# programs
source $toolspath/../$Qprograms

###############################################################################
###

if [ -z $what ] 
then
  if [ -z $Qinp ]
  then
    echo "No XTB input [EXITING]"
    exit
  else
    what=`cat $Qinp | xargs`        
  fi
fi
echo "JKxtb.sh: what = $what"

###

for i in $what
do 
  file=$i
  name=$(basename $file .xyz)
  
  mkdir xtb_$name
  cd xtb_$name
  
  cp ../$file .
  $xtb ${name}.xyz $opt > output
  if [ -e ../${name}.xyz ]; 
  then 
    cp ../${name}.xyz ../${name}X.xyz
  fi
  cp output ../${name}.log
  if [ ! -e xtbopt.xyz ]
  then 
   cp ${name}.xyz ../${name}.xyz
  else 
   cp xtbopt.xyz ../${name}.xyz
  fi
 
  
  cd ..
  rm -r xtb_$name
done

