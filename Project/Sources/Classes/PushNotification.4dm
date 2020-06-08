/*
Construct a PushNotification object.

If you have only one application in your Session files (`MobileApps/`),
you can call the constructor with no parameter. 
However, if you have more than one, you will need to provide parameters 
to identify which application you want to send push notifications to.

MobileAppServer .PushNotification.new() -> pushNotification // only if one application
MobileAppServer .PushNotification.new( "TEAM123456.com.sample.myappname" ) -> pushNotification
MobileAppServer .PushNotification.new( "com.sample.myappname" ) -> pushNotification
MobileAppServer .PushNotification.new( "myappname" ) -> pushNotification
MobileAppServer .PushNotification.new( New object("bundleId";"com.sample.myappname";"teamId";"TEAM123456") ) -> pushNotification
*/
Class constructor
	C_VARIANT:C1683($1)
	
	C_OBJECT:C1216($session;$Obj_manifest;$Obj_authKey)
	
	This:C1470.auth:=New object:C1471
	
	This:C1470.auth.isDevelopment:=False:C215
	
	If (($1=Null:C1517) | (Value type:C1509($1)=Is text:K8:3))
		
		$session:=MobileAppServer .Session.new($1)
		
		If ($session.sessionDir#Null:C1517)
			
			$Obj_manifest:=getManifest ($session.sessionDir)
			
			If ($Obj_manifest.success)
				
				This:C1470.auth.bundleId:=$Obj_manifest.manifest.application.id
				This:C1470.auth.teamId:=$Obj_manifest.manifest.team.id
				
			Else 
				
				ASSERT:C1129(False:C215;"Could not get manifest info")
				
			End if 
			
			
			$Obj_authKey:=getAuthenticationKey ($session.sessionDir)
			
			If ($Obj_authKey.success)
				
				This:C1470.auth.authKey:=$Obj_authKey.authKey
				This:C1470.auth.authKeyId:=$Obj_authKey.authKeyId
				
			Else 
				
				ASSERT:C1129(False:C215;"Could not find authentication key")
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215;"Could not find application info in Session")
			
		End if 
		
	Else 
		
		If ((Value type:C1509($1)=Is object:K8:27))
			
			If (Length:C16(String:C10($1.bundleId))>0)
				
				This:C1470.auth.bundleId:=$1.bundleId
				
			Else 
				
				ASSERT:C1129(False:C215;"No bundle ID provided")
				
			End if 
			
			If (Length:C16(String:C10($1.teamId))>0)
				
				This:C1470.auth.teamId:=$1.teamId
				
			Else 
				
				ASSERT:C1129(False:C215;"No team ID provided")
				
			End if 
			
			C_BOOLEAN:C305($authKeySuccess)
			
			$authKeySuccess:=False:C215
			
			If ($1.authKey#Null:C1517)
				
				$Obj_authKey:=getAuthenticationKey ($1.authKey)
				
				If ($Obj_authKey.success)
					
					$authKeySuccess:=True:C214
					
					This:C1470.auth.authKey:=$Obj_authKey.authKey
					This:C1470.auth.authKeyId:=$Obj_authKey.authKeyId
					
				End if 
				
			End if 
			
			If (Not:C34($authKeySuccess))
				
				$session:=MobileAppServer .Session.new(This:C1470.auth.teamId+"."+This:C1470.auth.bundleId)
				
				If ($session.sessionDir#Null:C1517)
					
					$Obj_authKey:=getAuthenticationKey ($session.sessionDir)
					
					If ($Obj_authKey.success)
						
						This:C1470.auth.authKey:=$Obj_authKey.authKey
						This:C1470.auth.authKeyId:=$Obj_authKey.authKeyId
						
					Else 
						
						ASSERT:C1129(False:C215;"Could not find authentication key")
						
					End if 
					
					ASSERT:C1129(False:C215;"Session folder could not be found")
					
				End if 
				
				  // Else : $1.authKey was valid
				
			End if 
			
			
			If (Bool:C1537($1.isDevelopment))
				
				This:C1470.auth.isDevelopment:=True:C214
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215;"Incompatible entry parameter type")
			
		End if 
		
	End if 
	
	
	
	
	  // Generate JWT
	
	If ((Length:C16(String:C10(This:C1470.auth.bundleId))>0)\
		 & (Length:C16(String:C10(This:C1470.auth.authKeyId))>0)\
		 & (Length:C16(String:C10(This:C1470.auth.teamId))>0))
		
		C_OBJECT:C1216($Obj_auth_result)
		
		  // Get JSON Web Token
		$Obj_auth_result:=authJWT (This:C1470.auth)
		
		If (($Obj_auth_result.success)\
			 & (Length:C16(String:C10($Obj_auth_result.jwt))>0))
			
			This:C1470.auth.jwt:=$Obj_auth_result.jwt
			This:C1470.lastResult:=New object:C1471
			
		Else 
			
			ASSERT:C1129(False:C215;"Failed to generate JSON Web Token")
			
		End if 
		
	End if 
	
	If (This:C1470.auth.jwt=Null:C1517)
		
		ASSERT:C1129(False:C215;"Class initialization failed")
		
	End if 
	
	
	
	  //-------------------------------------------------------------------------
Function send
	
	C_OBJECT:C1216($0)
	C_OBJECT:C1216($1)  // Notification content
	C_VARIANT:C1683($2)  // Recipient(s)
	
	If (This:C1470.auth.jwt=Null:C1517)
		
		ASSERT:C1129(False:C215;"Class initialization failed")
		ABORT:C156
		
	End if 
	
	  // Reinitializing lastResult
	This:C1470.lastResult.success:=False:C215
	This:C1470.lastResult.warnings:=New collection:C1472
	This:C1470.lastResult.errors:=New collection:C1472
	
	Case of 
			
			  //________________________________________
		: (Count parameters:C259>1)
			
			This:C1470.lastResult:=Mobile App Push Notification ($1;manageEntryRecipient ($2);This:C1470.auth)
			
			  //________________________________________
		: (This:C1470.recipients#Null:C1517)  // Recipients were set, but not given in send() function parameters
			
			This:C1470.lastResult:=Mobile App Push Notification ($1;manageEntryRecipient (This:C1470.recipients);This:C1470.auth)
			
			  //________________________________________
		Else 
			
			This:C1470.lastResult.errors.push("No recipient given")
			
			  //________________________________________
	End case 
	
	$0:=This:C1470.lastResult
	
	  //-------------------------------------------------------------------------
Function sendAll
	
	C_OBJECT:C1216($0)
	C_OBJECT:C1216($1)  // Notification content
	
	If (This:C1470.auth.jwt=Null:C1517)
		
		ASSERT:C1129(False:C215;"Class initialization failed")
		ABORT:C156
		
	End if 
	
	  // Reinitializing lastResult
	This:C1470.lastResult.success:=False:C215
	This:C1470.lastResult.warnings:=New collection:C1472
	This:C1470.lastResult.errors:=New collection:C1472
	
	C_OBJECT:C1216($Obj_session;$Obj_deviceTokens)
	
	$Obj_session:=MobileAppServer .Session.new(This:C1470.auth.teamId+"."+This:C1470.auth.bundleId)
	
	If ($Obj_session.sessionDir=Null:C1517)
		
		This:C1470.lastResult.errors.push("Could not find application info in Session")
		
	Else 
		
		$Obj_deviceTokens:=$Obj_session.getAllDeviceTokens()
		
		If ($Obj_deviceTokens.success)
			
			This:C1470.lastResult:=This:C1470.send($1;$Obj_deviceTokens.deviceTokens)
			
		Else 
			
			This:C1470.lastResult.errors.push("No recipient found")
			
		End if 
		
	End if 
	
	$0:=This:C1470.lastResult