# JKCS (=JKCS1.0)
Jammy Key for Configurational Sampling

  We strongly recommend people from outside of our research group to wait when JKCS2.0 will be released (end of summer 2019).
  
  HOW TO SETUP:

    cd ${YOUR_APPS_DIR}                              #enter to the directory with your scripts
    git clone https://github.com/kubeckaj/JKCS.git   #copy JKCS (JKCS folder is created)
    cd JKCS
    ls
    sh install.sh                                    #run basic "setup"
    source ~/.bashrc                                 #required after first "installation"
   
    # adjust programs.txt:
    # ABCluster: rigidmoloptimizer path
    # XTB: xtb path, XTBHOME path
    # PYTHON: please setup how to use python2.x (python3 works in JKCS2.0, but not in JKCS1.0)
    # If neaded load modules: Mpython ...
   
  Simple TEST (on local computer):
   
    cd $WRKDIR                 #go to your working directory
    mkdir TESTING_JKCS         #create a new forder 
    cd TESTING_JKCS            #and enter it
    JKCS0_copy --help          #CHECKING POINT:This fail if instal. wasn't succesful or you didn't source ~/.bashrc  
    JKCS0_copy SA A            #create input.txt for sulphuric acid and ammonia cluster
    #Here you can adjust the input.txt file
    JKCS1_prepare --help       #explains what is doing this script
    JKCS1_prepare -gen 20 -init 10 -lm 10  #prepare folders and files for ABCluster, just some "funny testing setup"
    JKCS2_runABC --help        #explains what is doing this script
    JKCS2_runABC               #CHECKING POINT:This fail if you didn't setup rigidmoloptimizer path in programs.txt
                               #enter each folder and perform ABCluster exploration
    #optional: you can perform [JKCS4_collect ABC] also here
    JKCS3_runXTB --help        
    JKCS3_runXTB               #CHECKING POINT:This fail if you didn't setup xtb paths in programs.txt properly
    JKCS4_collect XTB          #CHECKING POINT:This fail if you didn't setup python properly
                               #this script collect semi-empirically(xtb) optimized structures
    cd SYS_1SA_1A              #Enter folder with cluster 1sa1a
    molden movieXTB.xyz or vim resultsXTB.dat [structure_file gyration_radius energy] to see results.
     
    #######################
    # If everything worked, continue, otherwise, contact Jakub Kubecka (jakub.kubecka@helsinki.fi).
    # adjust the rest of programs.txt:
    # QUEING, QUANTUM CHEMISTRY PROGRAMS etc.
    
  and the rest you have to consult with manual (! JKCS1.0 does not have so advanced manual, in  case ask Jacob for help !)
    
    
   
 
