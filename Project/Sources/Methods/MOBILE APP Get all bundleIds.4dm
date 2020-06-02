//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // Returned object
C_TEXT:C284($1)  // teamId

C_LONGINT:C283($Lon_parameters;$app_indx;$sep_position)
C_OBJECT:C1216($Dir_mobileApps;$Obj_result)
C_TEXT:C284($folderName;$teamId)

ARRAY TEXT:C222($appFoldersList;0)


  // PARAMETERS
  //________________________________________

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18;*)
	
	$Obj_result:=New object:C1471
	$Obj_result.success:=False:C215
	$Obj_result.bundleIds:=New collection:C1472
	
Else 
	
	ABORT:C156
	
End if 


If ($Dir_mobileApps.exists)
	
	  // Each folder corresponds to an application
	FOLDER LIST:C473($Dir_mobileApps.platformPath;$appFoldersList)
	
	For ($app_indx;1;Size of array:C274($appFoldersList);1)
		
		$folderName:=$appFoldersList{$app_indx}
		
		$sep_position:=Position:C15(".";$folderName)
		
		$teamId:=Substring:C12($folderName;0;$sep_position-1)
		
		If ($1=$teamId)
			
			$Obj_result.bundleIds.push(Substring:C12($folderName;$sep_position+1;Length:C16($folderName)))
			
		End if 
		
	End for 
	
	  // Else : couldn't find MobileApps folder in host database
	
End if 

If ($Obj_result.bundleIds.count()>0)
	
	$Obj_result.success:=True:C214
	$Obj_result.bundleIds:=$Obj_result.bundleIds.distinct()
	
End if 

$0:=$Obj_result
