
# START
echo "-----------------------"
echo 'Hi, I will just test what is written in your ~/.bashrc file'
##
path=$PWD
path1="${path}/JKCSx"
path2="${path}/TOOLS"
if [ ! -e ~/.bashrc ]
then
  touch ~/.bashrc
fi
T=0
test=`grep -c "$path1" ~/.bashrc`
if [ $test -eq 0 ]
then 
  echo "export PATH=$path1:\$PATH" >> ~/.bashrc
  T=`echo $T+1|bc`
fi
test=`grep -c $path2 ~/.bashrc`
if [ $test -eq 0 ]
then
  echo "export PATH=$path2:\$PATH" >> ~/.bashrc
  T=`echo $T+1|bc`
fi
if [ $T -gt 0 ]
then
  echo "Write followinng command: "
  echo "          source ~/.bashrc"
else
  echo "No change in ~/.bashrc requiered."
fi
echo "-----------------------"

if [ ! -e programs.txt ]
then
  cp .programs.txt programs.txt
  echo "Please, chnage all required paths in file programs.txt"
else
  echo "File programs.txt already exist, check, if all paths in this file are correct."
fi

if [ ! -e programs2.txt ]
then
  cp .programs2.txt programs2.txt
  echo "If you also know how to use programs2, you can change all required paths in file programs2.txt"
fi
echo "-----------------------"
