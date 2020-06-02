Class constructor
	C_OBJECT:C1216($1)
	
	If ($1=Null:C1517)
		
		ASSERT:C1129(False:C215;"Failed to "+Current method name:C684)
		
	End if 
	
	  // If authKey file is given as path
	If (Value type:C1509($1.authKey)=Is text:K8:3)
		
		$1.authKey:=File:C1566($1.authKey)
		
	End if 
	
	  // If authKey is not a file
	If (Not:C34(Bool:C1537($1.authKey.isFile)))
		
		ASSERT:C1129(False:C215;"Unknown authentication key type : "+String:C10(Value type:C1509($1.authKey)))
		
	End if 
	
	  // If authKey file does not exist
	If (Not:C34(Bool:C1537($1.authKey.exists)))
		
		ASSERT:C1129(False:C215;"Could not find authentication key file")
		
	End if 
	
	  // Check if authKey file is an alias, and get original
	If ($1.authKey.isAlias)
		
		$1.authKey:=$1.authKey.original
		
	End if 
	
	If ((Length:C16(String:C10($1.bundleId))=0)\
		 | (Length:C16(String:C10($1.authKeyId))=0)\
		 | (Length:C16(String:C10($1.teamId))=0))  // Incomplete authentication object
		
		ASSERT:C1129(False:C215;"Incomplete authentication object")
		
	Else 
		
		C_OBJECT:C1216($Obj_auth_result)
		
		  // Get JSON Web Token
		$Obj_auth_result:=authJWT ($1)
		
		If (Not:C34($Obj_auth_result.success)\
			 | Not:C34(Length:C16(String:C10($Obj_auth_result.jwt))>0))
			
			ASSERT:C1129(False:C215;"Failed to generate JSON Web Token")
			
		Else 
			
			This:C1470.auth:=$1
			This:C1470.auth.jwt:=$Obj_auth_result.jwt
			This:C1470.lastResult:=New object:C1471
			
			If ($1.isDevelopment#Null:C1517)
				
				This:C1470.auth.isDevelopment:=$1.isDevelopment
				
			Else 
				
				This:C1470.auth.isDevelopment:=False:C215
				
			End if 
		End if 
	End if 
	
	  //-------------------------------------------------------------------------
Function send
	
	C_OBJECT:C1216($0)
	C_OBJECT:C1216($1)  // Notification content
	C_VARIANT:C1683($2)  // Recipient(s)
	
	If (This:C1470.auth=Null:C1517)
		
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
	
	If (This:C1470.auth=Null:C1517)
		
		ASSERT:C1129(False:C215;"Class initialization failed")
		ABORT:C156
		
	End if 
	
	  // Reinitializing lastResult
	This:C1470.lastResult.success:=False:C215
	This:C1470.lastResult.warnings:=New collection:C1472
	This:C1470.lastResult.errors:=New collection:C1472
	
	C_OBJECT:C1216($Obj_session;$Obj_deviceTokens)
	
	$Obj_session:=MobileAppServer .Session.new(This:C1470.auth.teamId;This:C1470.auth.bundleId)
	
	$Obj_deviceTokens:=$Obj_session.getAllDeviceTokens()
	
	  //$Obj_deviceTokens:=MOBILE APP Get all deviceTokens (This.auth.teamId;This.auth.bundleId)
	
	If ($Obj_deviceTokens.success)
		
		This:C1470.lastResult:=This:C1470.send($1;$Obj_deviceTokens.deviceTokens)
		
	Else 
		
		This:C1470.lastResult.errors.push("No recipient found")
		
	End if 
	
	$0:=This:C1470.lastResult