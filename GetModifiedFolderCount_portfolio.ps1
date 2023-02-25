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
"C:\Users\UserName\OneDrive\WEB\Powershell\UpdateAndCount\FolderCountLastRun.txt"
##########################################################################################>

param(
    [string] $PathToCheck = "C:\Users\UserName\OneDrive\WEB\Powershell\UpdateAndCount\ParentFolder",
    [string] $OutputFileName = "FolderCount",
    [string] $OutputFilePath = "C:\Users\UserName\OneDrive\WEB\Powershell\UpdateAndCount",
    [string] $DailyFolderCountPath = "C:\Users\UserName\OneDrive\WEB\Powershell\UpdateAndCount\FolderCountLastRun.txt",
    $AppendTime = 1
)

#Store the updated file list
$UpdatedFiles = @()
#Store the total count of files
$TotalFolderCountToday = ( dir $PathToCheck | measure).Count 
#Store the total number of modified folders
$ModifiedFolderCount = 0
#Store the folder count from the last run
$FolderCountLastRun = 0
#Insert 0 as the default if there is no record of yesterdays folder count
$xml = 0

#Add the data and time to the file name if desired
if($AppendTime = 1) {
    $OutputFileName += Get-Date -Format "_MM-dd-yyyy_HHMM"
}

#If there is no record from the last run create it. Start with 0.
if (-not(Test-Path -Path $DailyFolderCountPath)) {
    "0" > $DailyFolderCountPath
}
if(!(Get-Content -Path $DailyFolderCountPath)){
    "0" > $DailyFolderCountPath
}

#Set up the path to store the output.
$OutputFilePath = $OutputFilePath+"\"+$OutputFileName + ".txt"

#Get the records for all of the folders that have been modified
Get-ChildItem -path $PathToCheck | 
foreach-object {$_.PSIsContainer} {
    if($_.LastWriteTime -gt (get-date -Format "MM/dd/yyyy 00:00:00"))
    {
        $UpdatedFiles += "`n"+ "FolderName: " + $_.name + " " + "Date Modified: " + $_.LastWriteTime
        $ModifiedFolderCount += 1
    }
}

#Get the count of the folders from the last run
$FolderCountLastRun = Get-Content -Path $DailyFolderCountPath
#The difference between the last folder count and todays 
$delta = $TotalFolderCountToday-$FolderCountLastRun 

#Put together the output message if folders were added.
if($delta -gt -1){
    $UpdatedFiles = "There were $FolderCountLastRun folders last run. 
There are $TotalFolderCountToday folders today.
Total number of modified folders: $ModifiedFolderCount
Total number of folders added: $delta`n" + $UpdatedFiles
}

#Put together the output message if folders were removed.
if($delta -lt 0){
    $UpdatedFiles = "There were $FolderCountLastRun folders last run. 
There are $TotalFolderCountToday folders today.
Total number of modified folders: $ModifiedFolderCount
Total number of folders removed: $delta`n" + $UpdatedFiles
}

#Output the message to the console
write-output $UpdatedFiles

#Output a new file. Or replace the old one if AppendTime is set to 0
$UpdatedFiles > $OutputFilePath

#Output the daily folder count so it can be used on the next run to compare differences. 
$TotalFolderCountToday > $DailyFolderCountPath