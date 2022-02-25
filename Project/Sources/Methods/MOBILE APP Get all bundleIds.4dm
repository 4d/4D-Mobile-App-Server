//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($wantedTeamId : Text)->$result : Object

var $sep_position : Integer
var $Dir_mobileApps : 4D:C1709.Folder
var $folderName; $teamId : Text

$result:=New object:C1471(\
"success"; False:C215; \
"bundleIds"; New collection:C1472)

$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18; *)

If ($Dir_mobileApps.exists)
	
	var $folder : 4D:C1709.Folder
	For each ($folder; $Dir_mobileApps.folders())
		
		$folderName:=$folder.name
		$sep_position:=Position:C15("."; $folderName)
		
		$teamId:=Substring:C12($folderName; 0; $sep_position-1)
		
		If ((Length:C16($wantedTeamId)=0) || ($wantedTeamId=$teamId))
			
			$result.bundleIds.push(Substring:C12($folderName; $sep_position+1; Length:C16($folderName)))
			
		End if 
		
	End for each 
	
	// Else : couldn't find MobileApps folder in host database
	
End if 


If ($result.bundleIds.length>0)
	
	$result.success:=True:C214
	$result.bundleIds:=$result.bundleIds.distinct()
	
End if 
