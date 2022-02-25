/*
Construct a Session object.

If you have only one application in your Session files (`MobileApps/`),
you can call the constructor with no parameter. 
However, if you have more than one, you will need to provide parameters 
to identify which application you want to send push notifications to.

MobileAppServer .Session.new() -> session // only if one application
MobileAppServer .Session.new( "TEAM123456.com.sample.myappname" ) -> session
MobileAppServer .Session.new( "com.sample.myappname" ) -> session
MobileAppServer .Session.new( "myappname" ) -> session
*/
Class constructor($appID : Text)  // Application ID (teamID.bundleID) or Bundle ID or Application name or empty entry
	var $folder_indx : Integer
	var $emptyParameter : Boolean
	var $appFoldersList : Collection
	
	var $Dir_mobileApps; $appFolder : 4D:C1709.Folder
	$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18; *)
	
	If ($Dir_mobileApps.exists)
		
		// Each folder corresponds to an application
		$appFoldersList:=$Dir_mobileApps.folders()
		
		Case of 
				
			: (Count parameters:C259=0)
				
				$emptyParameter:=True:C214
				
			: (Length:C16(String:C10($appID))=0)
				
				$emptyParameter:=True:C214
				
			Else 
				
				$emptyParameter:=False:C215
				
		End case 
		
		If (Bool:C1537($emptyParameter))  // Empty entry
			
			Case of 
					
				: ($appFoldersList.length=0)
					
					ASSERT:C1129(False:C215; "There is no application folder found")
					
				: ($appFoldersList.length=1)
					
					$appFolder:=$appFoldersList[0]
					This:C1470.sessionDir:=$appFolder
					
				Else 
					
					ASSERT:C1129(False:C215; "There are several application folders, can't select appropriate application")
					
			End case 
			
		Else   // Application ID (teamID.bundleID) or Bundle ID or Application name
			
			$folder_indx:=$appFoldersList.indexOf($appID)
			
			var $folder_name : Text
			var $Col_app : Collection
			var $pos : Integer
			
			
			// Application ID (teamID.bundleID)
			
			If ($folder_indx>0)
				
				$appFolder:=$appFoldersList[$folder_indx]
				
				If ($appFolder.exists)
					
					This:C1470.sessionDir:=$appFolder
					
					// Else : application directory doesn't exist
					
				End if 
				
				// Else : Application ID (teamID.bundleID) not found
				
			End if 
			
			
			// Application name
			
			If (This:C1470.sessionDir=Null:C1517)
				
				For each ($appFolder; $appFoldersList)
					
					$folder_name:=$appFolder.fullName
					
					$Col_app:=Split string:C1554($folder_name; ".")
					
					If ($Col_app[$Col_app.length-1]=$appId)
						
						If ($appFolder.exists)
							
							This:C1470.sessionDir:=$appFolder
							
							// Else : application directory doesn't exist (not possible or just deleted)
							
						End if 
						
						// Else : Application name not found
						
					End if 
					
				End for each 
				
				// Else : sessionDir already found
				
			End if 
			
			
			// Bundle ID
			
			If (This:C1470.sessionDir=Null:C1517)
				
				For each ($appFolder; $appFoldersList)
					
					$folder_name:=$appFolder.fullName
					
					$pos:=Position:C15($appId; $folder_name)
					
					If ($pos>0)
						
						If ($appFolder.exists)
							
							This:C1470.sessionDir:=$appFolder
							
							// Else : application directory doesn't exist
							
						End if 
						
						// Else : BundleId found
						
					End if 
					
				End for each 
				
				// Else : sessionDir already found
				
			End if 
			
			
		End if 
		
		// Else : couldn't find MobileApps folder in host database
		
	End if 
	
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215; "Session folder could not be found")
		
	End if 
	
	//-------------------------------------------------------------------------
Function getAllDeviceTokens()->$tokens : Object
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215; "Session folder could not be found")
		
	End if 
	
	$tokens:=MOBILE APP Get all deviceTokens(This:C1470.sessionDir)
	
	//-------------------------------------------------------------------------
Function getAllMailAddresses()->$mailAddresses : Object
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215; "Session folder could not be found")
		
	End if 
	
	$mailAddresses:=MA Get all mailAddresses(This:C1470.sessionDir)
	
	//-------------------------------------------------------------------------
Function getSessionInfoFromMail($mail : Text)->$sessionInfo : Object
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215; "Session folder could not be found")
		
	End if 
	
	If (Asserted:C1132(Count parameters:C259>=1; "Missing mail address parameter"))
		
		ASSERT:C1129(Value type:C1509($mail)=Is text:K8:3; "The function requires a mail address, a text is expected")
		
	End if 
	
	$sessionInfo:=MOBILE APP Get session info(This:C1470.sessionDir; $mail)
	
	//-------------------------------------------------------------------------
Function getSessionObjects()->$sessionObjects : Collection
	$sessionObjects:=New collection:C1472()
	If (This:C1470.sessionDir=Null:C1517)
		
		ASSERT:C1129(False:C215; "Session folder could not be found")
		
	End if 
	var $sessionFile : 4D:C1709.File
	For each ($sessionFile; This:C1470.sessionDir.files())
		
		If ($sessionFile.extension="")
			
			$sessionObjects.push(cs:C1710.SessionObject.new($sessionFile))
			
		End if 
		
	End for each 
	