# App Release Checklist

1. Update Version Numbers
  1. In AppStoreInfo.md
  2. In the project settings.

3. Add a Release Notes Entry to the bottom of the AppStoreInfo.md file. This will be used to describe "What's Changed" in the App Store submission.

4. Update releaseManifest.md with SHA1 of any libraries changed since last release.

5. Update the copyright information in AppStoreInfo.md, if the year has changed
  
## In iTunes Connect, create the new version

1. Cut and paste the "What's changed" information from AppStoreInfo.md
2. Use the same version number as was changed in step 1.
3. Update the copyright, if the year has changed.

## Final Testing

1. Run the "Analyze" Build phase on the project
2. Run the project's unit tests using the "Test" option.
3. Install and run on an iOS device.
4. Manual UI Testing - Open the file FutureBudgetManualUITesting.ods in OpenOffice, and step through these tests on hardware.
  
5. Commit changes made to project in steps 1-5 above.

## Create a Release Build

  1. Clean the build folder - In Xcode, with the option key pressed, select "Product->Clean" from the menu.

  2. In the build scheme, make sure "FutureBudget > iOS Device" is selected. Otherwise, the Archive menu items will likely be greyed out.
  
  3. Edit the Build Settings for the Project and the Target(s) to use the Distribution code signing. In the code signing section, change the settings for the release build to Distribution.
  
  4. In XCode, select "Product -> Archive". XCode should build the archive and create an entry for it in Organizer.

  5. Add a comment to the Archive in the Organizer, such as "Version 1.0.RC1 submitted to App Store".

  6. From the Organizer, open the archive in the finder (right click and show package contents). Drag the 
     app to a console window to run the following commands:
     
     codesign -dvvv /path/to/MyGreatApp.app
     
     and:
     
     codesign -d --entitlements - /path/to/MyGreatApp.app
     
     The above will confirm the signature and entitlements for the
     app. Run both commands on the previous version of the app
     to confirm the information is the same.

  7. Discard the build settings set in step 3. Right-click on the build file and select "Source Control->Discard Changes".
   
## Validate and Submit App to App Store

1. Validate the Release Build

  1. Using the same archived app folder names as the step above,
     perform a folder difference using DiffMerge on the previous
     and current app folders. The differences should correspond to
     the expected changes.

  2. Refer to the document "ManualTesting.md", which includes tests to
     be performed on a release build. This notably includes RELTEST-T01,
     which is testing the update to ensure backward compatibility has been preserved.

2. Within the Xcode organizer, validate and distribute/submit the archive for the App Store.

## Test with the Release Build

1. From the archive released build, create an IPA for final testing.

  1. In the Organizer, select the archive, and press the "Distribute..." button.
  2. Select the "Save for Enterprise or Ad-hoc deployment" option.
  3. Sign with the Development certificate.
  4. Save in the folder /Users/sroehling/Development/ReleasedAppIPAs with a name like "FutureBudget-1.0.RC1".
  
2. Test the release build on a device

  1. Add the final testing IPA created above to iTunes. This is done with the "File->Add to Library..." command within iTunes, and selecting the appropriate IPA file.
  2. Install on the device via iTunes. This will replicate how the app will be installed from the App store. After adding the IPA to the library. This is done by re-synching the device with iTunes (e.g., via the "Apply" button).
  3. Perform the manual UI testing steps as described above.
  
3. Using git, tag the app's project code with the version number
   (substituting appropriate version number, instead of "1.0.1"): e.g.:

    cd /Users/sroehling/Development/Workspace/Retirement\ Simulator
	git tag -a v1.0.RC1 -m "Version 1.0.RC1 submitted for approval"
	
4. Using git, tag any libraries changed alongside the project code 
   (substituting appropriate numbers for MailShredder and library code, instead of 1.7 and 1.0.RC1): e.g.:

    cd /Users/sroehling/Development/Workspace/ResultraGenericLib
	git tag -a v1.7 -m "Version build into FutureBudget 1.0.RC1"
	
## Backup the Source Code and Archive
	
1. Create an off-site backup of the current source code tree, including library code.

2. Create an off-site backup of the archives used to build the project.

## After App Has Been Approved/Released

After the app has been approved for sale in Apple's app store:

1. Tag the project's git repository again with a "golden master" tag, such as "v1.0.GM", signifying this is a released version.
2. Go back to the Xcode Organizer, and update the comment on the released archive to indicate this version has been approved as version 1.0.