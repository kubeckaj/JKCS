#!/bin/bash
###################################
## CHECK IN WHICH DIRECTORY I AM
## + load info about charge and cpu
###################################
if [ -e TXT ]
then
  echo TXT exists
  folders=./
  thisdir=`echo "${PWD##*/}"`
  source TXT
else
  if [ ! -e $filesfile ]
  then
    if [ -e $inputfile ]
    then
      ### IN SOME WORKING FOLDER ###
      folders=./
      thisdir=`echo "${PWD##*/}"`
      testfolder=`grep -c " $thisdir " ../$filesfile`
      if [ "$testfolder" != 1 ]
      then
        echo "$scriptfile: This directory is missing in ./$filesfile file. EXITING"
        exit
      fi
      allCPU=`        grep " $thisdir " ../$filesfile | awk '{print $1}'`
      allINIT=`       grep " $thisdir " ../$filesfile | awk '{print $2}'`
      allGENERATIONS=`grep " $thisdir " ../$filesfile | awk '{print $3}'`
      allSCOUTS=`     grep " $thisdir " ../$filesfile | awk '{print $4}'`
      allLMs=`        grep " $thisdir " ../$filesfile | awk '{print $5}'`
      allSIZEs=`      grep " $thisdir " ../$filesfile | awk '{print $7}'`
      #test for allSIZEs
      test1=`echo $folders  | xargs -n 1 | wc -l`
      test2=`echo $allSIZEs | xargs -n 1 | wc -l`
      if [ $test1 -ne $test2 ] && [ ! -z $allSIZEs ]
      then
        echo "$scriptfile: the last (7th) column (sizes) in $filesfile is incorrectly defined. EXITING"
        exit  
      fi
    else
      if [ ! -e $userinputfile ]
      then
        ### NOTHING ###
        echo "$scriptfile: You are not in correct folder or no familiar folder/file exist. EXITING"
        echo "$scriptfile: (no $filesfile,no $inputfile,no $userinputfile)"
        exit
      fi
    fi
  else
    ### ON THE TOP OF WORKINNG FOLDERS ###
    if [ -z "$folders" ]
    then
      folders=`     sed 1,1d $filesfile | awk '{print $6}' | xargs`
    fi
    allCPU=`        sed 1,1d $filesfile | awk '{print $1}' | xargs`
    allINIT=`       sed 1,1d $filesfile | awk '{print $2}' | xargs`
    allGENERATIONS=`sed 1,1d $filesfile | awk '{print $3}' | xargs`
    allSCOUTS=`     sed 1,1d $filesfile | awk '{print $4}' | xargs`
    allLMs=`        sed 1,1d $filesfile | awk '{print $5}' | xargs`
    allSIZEs=`      sed 1,1d $filesfile | awk '{print $7}' | xargs`
    #test for allSIZEs
    test1=`echo $folders  | xargs -n 1 | wc -l`
    test2=`echo $allSIZEs | xargs -n 1 | wc -l`
    if [ $test1 -ne $test2 ] && [ ! -z $allSIZEs ]
    then
      echo "$scriptfile: the last (7th) column (sizes) in $filesfile is incorrectly defined. EXITING"
      exit  
    fi
  fi
  #####################################
  if [ -e ../$userinputfile ] && [ ! -e $userinputfile ]
  then
    back="../"
  fi
  if [ -e ../$userinputfile ] || [ -e $userinputfile ] 
  then
    ### JKCS1 ###
    # total charge
    totcharge=`grep TotalCharge $back$userinputfile | awk '{print $2}'`
    # multiplicity
    test=`grep -c TotalMultiplicity $back$userinputfile`
    if [ $test -eq 1 ]
    then
      MULTIPLICITY=`grep TotalMultiplicity $back$userinputfile | awk '{print $2}'`
    fi
    # composition loading
    composition=`grep Composition $back$userinputfile | awk '{ $1 = "";print $0}'`
    # CPU per folder
    cpu=`grep CPU $back$userinputfile | awk '{print $2}'`
  fi
fi

