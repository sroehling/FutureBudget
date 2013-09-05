# App Release Checklist

### Update App Information for New Version

1. Update Version Numbers
  1. In AppStoreInfo.md
  2. In the project settings:
     * For the "FutureBudget" target, go to "Summary" tab in the project settings.
     * Change both the version and build to the current version number.

3. Add a Release Notes Entry to the bottom of the AppStoreInfo.md file. This will be used to describe "What's Changed" in the App Store submission.

4. Update the copyright information in AppStoreInfo.md, if the year has changed
  
5. Commit changes made to project files above.

## In iTunes Connect, create the new version

1. Cut and paste the "What's changed" information from AppStoreInfo.md
2. Use the same version number as was changed in step 1.
3. Update the copyright, if the year has changed.

## Final Testing

1. Run the "Analyze" Build phase on the project
2. Run the project's unit tests using the "Test" option.
3. Install and run on an iOS device.
4. Manual UI Testing - Open the file FutureBudgetManualUITesting.ods in OpenOffice, and step through these tests on hardware.
  
## Create a Release Build

  1. In the build scheme, make sure "FutureBudget > iOS Device" is selected. Otherwise, the Archive menu items will likely be greyed out.

  2. Clean the build folder - In Xcode, with the option key pressed, select "Product->Clean Build Folder" from the menu. This is done by also selecting the option key before accessing the "Product" menu.
  
  3. Edit the Build Settings for the Project and the Target(s) to use the Distribution code signing. 
     1. Select the top-level "FutureBudget" project file from the XCode file list pane.
     2. Select "FutureBudget" from the Targets list.
     3. Select the "Build Settings" tab.
     4. In the "Code Signing" section, change the "Code Signing Identity" settings for the release build to "iPhone Distribution".
  
  4. In XCode, select "Product -> Archive". XCode should build the archive and create an entry for it in Organizer.

  5. Add a comment to the Archive in the Organizer, such as "Version 1.0.RC1".

  6. Discard the build settings set in step 3. Right-click on the build file and select "Source Control->Discard Changes".

## Create an IPA for Final Testing.

1. In the Organizer, select the archive, and press the "Distribute..." button.
2. Select the "Save for Enterprise or Ad-hoc deployment" option.
3. Sign with the Development certificate.
4. Save in the folder /Users/sroehling/Development/ReleasedAppIPAs with a name like "FutureBudget-1.0.RC1".

## Tag the Version in Git
  
Using git, tag the app's project code with the version number
   (substituting appropriate version number, instead of "1.0.1"), then push that tag to the remote server: e.g.:

	cd /Users/sroehling/Development/PROJECT-FOLDER
	git tag -a v1.0.RC1 -m "Version 1.0.RC1"
    git push origin v1.0.RC1 
	  
## Test the Release Build on an iOS Device

  1. Add the final testing IPA created above to iTunes. This is done with the "File->Add to Library..." command within iTunes, and selecting the appropriate IPA file.
  2. Install on the device via iTunes. This will replicate how the app will be installed from the App store. After adding the IPA to the library. This is done by re-synching the device with iTunes (e.g., via the "Apply" button).
  3. Perform the manual UI testing steps as described above.
   
## Validate and Submit App to App Store

Within the Xcode organizer, validate and distribute/submit the archive for the App Store.
	
## Backup the Source Code and Archive
	
1. Create an off-site backup of the current source code tree, including library code.

2. Create an off-site backup of the archives used to build the project.

## After App Has Been Approved/Released

After the app has been approved for sale in Apple's app store:

1. Tag the project's git repository again with a "golden master" tag, such as "v1.0.GM", signifying this is a released version.
2. Go back to the Xcode Organizer, and update the comment on the released archive to indicate this version has been approved as version 1.0.