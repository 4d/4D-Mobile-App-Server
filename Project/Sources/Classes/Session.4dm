Class constructor
	C_TEXT:C284($1)  // TeamId.BundleId or BundleId or AppName or empty entry
	
	C_OBJECT:C1216($Dir_mobileApps;$appFolder)
	C_LONGINT:C283($folder_indx)
	ARRAY TEXT:C222($appFoldersList;0)
	
	$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18;*)
	
	If ($Dir_mobileApps.exists)
		
		  // Each folder corresponds to an application
		FOLDER LIST:C473($Dir_mobileApps.platformPath;$appFoldersList)
		
		
		
		If (Length:C16(String:C10($1))=0)  // Empty entry
			
			Case of 
					
				: (Size of array:C274($appFoldersList)=0)
					
					ASSERT:C1129(False:C215;"There is no application folder found")
					
				: (Size of array:C274($appFoldersList)=1)
					
					$appFolder:=$Dir_mobileApps.folder($appFoldersList{1})
					
					This:C1470.sessionDir:=$appFolder
					
				Else 
					
					ASSERT:C1129(False:C215;"There are several application folders, can't select appropriate application")
					
			End case 
			
		Else   // TeamId.BundleId or BundleId or AppName entry
			
			$folder_indx:=Find in array:C230($appFoldersList;$1)
			
			
			C_TEXT:C284($folder_name)
			C_COLLECTION:C1488($Col_app)
			C_LONGINT:C283($pos;$app_indx)
			
			
			  // TeamId.BundleId
			
			If ($folder_indx>0)
				
				$appFolder:=$Dir_mobileApps.folder($appFoldersList{$folder_indx})
				
				If ($appFolder.exists)
					
					This:C1470.sessionDir:=$appFolder
					
					  // Else : application directory doesn't exist
					
				End if 
				
				  // Else : TeamId.BundleId not found
				
			End if 
			
			
			  // AppName
			
			If (This:C1470.sessionDir=Null:C1517)
				
				For ($app_indx;1;Size of array:C274($appFoldersList);1)
					
					$folder_name:=$appFoldersList{$app_indx}
					
					$Col_app:=Split string:C1554($folder_name;".")
					
					If ($Col_app[$Col_app.length-1]=$1)
						
						$appFolder:=$Dir_mobileApps.folder($folder_name)
						
						If ($appFolder.exists)
							
							This:C1470.sessionDir:=$appFolder
							
							  // Else : application directory doesn't exist
							
						End if 
						
						  // Else : AppName not found
						
					End if 
					
				End for 
				
				  // Else : sessionDir already found
				
			End if 
			
			
			  // BundleId
			
			If (This:C1470.sessionDir=Null:C1517)
				
				For ($app_indx;1;Size of array:C274($appFoldersList);1)
					
					$folder_name:=$appFoldersList{$app_indx}
					
					$pos:=Position:C15($1;$folder_name)
					
					If ($pos>0)
						
						$appFolder:=$Dir_mobileApps.folder($folder_name)
						
						If ($appFolder.exists)
							
							This:C1470.sessionDir:=$appFolder
							
							  // Else : application directory doesn't exist
							
						End if 
						
						  // Else : BundleId found
						
					End if 
					
				End for 
				
				  // Else : sessionDir already found
				
			End if 
			
			
		End if 
		
		  // Else : couldn't find MobileApps folder in host database
		
	End if 
	
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215;"Session folder could not be found")
		
	End if 
	
	
	
	
	  //-------------------------------------------------------------------------
Function getAllDeviceTokens
	
	C_OBJECT:C1216($0)
	
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215;"Session folder could not be found")
		ABORT:C156
		
	End if 
	
	$0:=MOBILE APP Get all deviceTokens (This:C1470.sessionDir)
	
	  //-------------------------------------------------------------------------
Function getAllMailAddresses
	
	C_OBJECT:C1216($0)
	
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215;"Session folder could not be found")
		ABORT:C156
		
	End if 
	
	$0:=MA Get all mailAddresses (This:C1470.sessionDir)
	
	  //-------------------------------------------------------------------------
Function getSessionInfoFromMail
	
	C_OBJECT:C1216($0)
	
	C_TEXT:C284($1)  // mail address
	
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215;"Session folder could not be found")
		ABORT:C156
		
	End if 
	
	If (Asserted:C1132(Count parameters:C259>=1;"Missing mail address parameter"))
		
		ASSERT:C1129(Value type:C1509($1)=Is text:K8:3;"The function requires a mail address, a text is expected")
		
	Else 
		
		ABORT:C156
		
	End if 
	
	$0:=MOBILE APP Get session info (This:C1470.sessionDir;$1)