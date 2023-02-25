Somebody in a discord group wanted a script to run once every day, and do the following:
Track the number of modified folders in a parent folder since the day before.
Track how many folders were added or removed since the day before.
Output the results to a text file.
Input the path to the folder to be scanned.
Input the name of the output file. (But they also wanted it to be unique and not save over the current file.)

To accomplish this I used parameters to take in all of the requested input. I made the script output to a file to store the output of the total count of the current runs folders, so subsequent runs could use that value to compare the total folder count, and output the difference, if any.
I created the option to concat the date to the file name for a unique file save each time. The PowerShell might not run if the ExecutionPolicy is not set up right, I added instructions for running the script. I documented everything so the user would understand what the script was doing if they looked at it.

Instructions:
<##########################################################################################
 FileName: GetModifiedFolderCount_portfolio.ps1
 Author: David Stone
 Date Created: 02/04/2023

 If powershell is blocking this from being ran, try the following:
    Run powershell as admin:
    Run: Get-ExecutionPolicy
    Run: Set-ExecutionPolicy RemoteSigned
    Enter: y for yes.

 Instructions:
 Update the paths and filename as desired for the parameters in the PARAM() section. Or do so when calling the script.

 To run the powershell in the console call the powershell itself using the path with or without parameters.
 The parameters should be in quotes and in order if they are to be used:

 C:\Users\UserName\OneDrive\WEB\Powershell\UpdateAndCount\GetModifiedFolderCount.ps1
"C:\Users\UserName\OneDrive\WEB\Powershell\UpdateAndCount\ParentFolder"
"FolderCount"
"C:\Users\UserName\OneDrive\WEB\Powershell\UpdateAndCount"
##########################################################################################>
