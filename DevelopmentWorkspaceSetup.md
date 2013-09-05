# FutureBudget Software Development Workspace Setup

## Create a Folder for Development

	mkdir FutureBudget_Master
	cd FutureBudget_Master
	
## Clone the Source and Libraries from GIT

	git clone git@macmini.local:/Users/git/FutureBudget.git 
	git clone git@macmini.local:/Users/git/ResultraGenericLib.git
	git clone git@macmini.local:/Users/git/MarkdownHelpGeneration.git
	git clone git@macmini.local:/Users/git/core-plot.git
	
## Set the CorePlot Library to the Appropriate Version

Note for core-plot, since this is a 3rd party library, FutureBudget will be integrated with specific versions of the library. So, after making the clone, the checked out files from the library need to be set to the appropriate reference. This library may also contain some Resultra specific "localizations" for project settings, which are placed on a branch from a CorePlot release.

For example, to reference version 0.4 of the library:

	cd core-plot
	git checkout alpharelease_0.4_resultra_patch 
	
## Note About Build Settings for CorePlot

XCode will issue a build warning for CorePlot, saying it wants to update the build settings to "Apple LLVM Compiler 4.2". However, CorePlot version 0.4 needs "LLVM GCC 4.2" to successfully build.