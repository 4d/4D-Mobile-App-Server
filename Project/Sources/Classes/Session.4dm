Class constructor
	C_TEXT:C284($1)  // TeamId
	C_TEXT:C284($2)  // BundleId
	
	If (Asserted:C1132(Count parameters:C259>=2;"Missing parameter"))
		
		ASSERT:C1129(Value type:C1509($1)=Is text:K8:3;"First parameter is TeamId, a text is expected")
		ASSERT:C1129(Value type:C1509($2)=Is text:K8:3;"Second parameter is BundleId, a text is expected")
		
	Else 
		
		ABORT:C156
		
	End if 
	
	This:C1470.teamId:=$1
	This:C1470.bundleId:=$2
	
	C_OBJECT:C1216($Dir_mobileApps;$appFolder)
	C_LONGINT:C283($folder_indx)
	ARRAY TEXT:C222($appFoldersList;0)
	
	$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18;*)
	
	If ($Dir_mobileApps.exists)
		
		  // Each folder corresponds to an application
		FOLDER LIST:C473($Dir_mobileApps.platformPath;$appFoldersList)
		
		$folder_indx:=Find in array:C230($appFoldersList;This:C1470.teamId+"."+This:C1470.bundleId)
		
		If ($folder_indx>0)
			
			$appFolder:=$Dir_mobileApps.folder($appFoldersList{$folder_indx})
			
			If ($appFolder.exists)
				
				This:C1470.sessionDir:=$appFolder
				
				  // Else : application directory doesn't exist
				
			End if 
			
			  // Else : couldn't find application directory
			
		End if 
		
		  // Else : couldn't find MobileApps folder in host database
		
	End if 
	
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215;"The specific session folder could not be found. Maybe it is not created yet")
		
	End if 
	
	  //-------------------------------------------------------------------------
Function getAllDeviceTokens
	
	C_OBJECT:C1216($0)
	
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215;"The specific session folder could not be found. Maybe it is not created yet")
		ABORT:C156
		
	End if 
	
	$0:=MOBILE APP Get all deviceTokens (This:C1470.sessionDir)
	
	  //-------------------------------------------------------------------------
Function getAllMailAddresses
	
	C_OBJECT:C1216($0)
	
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215;"The specific session folder could not be found. Maybe it is not created yet")
		ABORT:C156
		
	End if 
	
	$0:=MA Get all mailAddresses (This:C1470.sessionDir)
	
	  //-------------------------------------------------------------------------
Function getSessionInfoFromMail
	
	C_OBJECT:C1216($0)
	
	C_TEXT:C284($1)  // mail address
	
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215;"The specific session folder could not be found. Maybe it is not created yet")
		ABORT:C156
		
	End if 
	
	If (Asserted:C1132(Count parameters:C259>=1;"Missing mail address parameter"))
		
		ASSERT:C1129(Value type:C1509($1)=Is text:K8:3;"The function requires a mail address, a text is expected")
		
	Else 
		
		ABORT:C156
		
	End if 
	
	$0:=MOBILE APP Get session info (This:C1470.sessionDir;$1)