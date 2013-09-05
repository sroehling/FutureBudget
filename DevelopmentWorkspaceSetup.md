# FutureBudget Software Development Workspace Setup

## Create a Folder for Development
	
Clone the Source and Libraries from GIT, then populate and confirm the submodules. 

	git clone git@macmini.local:/Users/git/FutureBudget.git WORKINGDIRNAME
    git submodule init
    git submodule update
    git submodule status
    
**WORKINGDIRNAME** can be left off if the intent is to populate the 'FutureBudget' directory.    

## Note About Build Settings for CorePlot

XCode will issue a build warning for CorePlot, saying it wants to update the build settings to "Apple LLVM Compiler 4.2". However, CorePlot version 0.4 needs "LLVM GCC 4.2" to successfully build.