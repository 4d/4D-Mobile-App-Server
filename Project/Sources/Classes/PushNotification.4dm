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

Specifying targets :
MobileAppServer .PushNotification.new("android") -> pushNotification // only if one application
MobileAppServer .PushNotification.new( "TEAM123456.com.sample.myappname"; "android" ) -> pushNotification
MobileAppServer .PushNotification.new( "TEAM123456.com.sample.myappname"; New Collection("android"; "ios") ) -> pushNotification

/!\ FOR TESTING ON SIMULATOR ONLY : Press Shift down

Use (MobileAppServer.PushNotification)
   MobileAppServer.PushNotification.allowSimulatorOnly:=Shift down
End use 

*/
Class constructor($id : Variant; $target : Variant)
	
	C_OBJECT:C1216($session; $Obj_manifest; $Obj_authKey)
	C_BOOLEAN:C305($isObject; $isText)
	C_COLLECTION:C1488($sessions)
	
	This:C1470.auth:=New object:C1471()
	This:C1470.lastResult:=New object:C1471
	
	This:C1470.isIos:=True:C214
	This:C1470.isAndroid:=True:C214
	
	
	// iOS
	This:C1470.onlySimulator:=(Bool:C1537(MobileAppServer.PushNotification.allowSimulatorOnly) | Shift down:C543)
	This:C1470.auth.isDevelopment:=False:C215
	
	// Android
	This:C1470.auth.serverKey:=""
	
	
	$isObject:=False:C215
	$isText:=False:C215
	$sessions:=New collection:C1472
	
	Case of 
			
		: (Count parameters:C259=0)
			
			$isText:=True:C214
			
			$session:=MobileAppServer.Session.new()
			
		: (Count parameters:C259=1)
			
			Case of 
					
				: (Value type:C1509($id)=Is text:K8:3)
					
					$isText:=True:C214
					
					Case of 
							
						: (Lowercase:C14($id)="ios")
							
							This:C1470.isAndroid:=False:C215
							
							$session:=MobileAppServer.Session.new()
							
							If ($session.sessionDir#Null:C1517)
								$sessions.push($session)
							End if 
							
						: (Lowercase:C14($id)="android")
							
							This:C1470.isIos:=False:C215
							
							$session:=MobileAppServer.Session.new()
							
							If ($session.sessionDir#Null:C1517)
								$sessions.push($session)
							End if 
							
						Else 
							
							$session:=MobileAppServer.Session.new($id)
							
							$sessions.push($session)
							
							// Adding sessions with teamId prefix
							$session:=MobileAppServer.Session.new("___."+$id)
							If ($session.sessionDir#Null:C1517)
								$sessions.push($session)
							End if 
							
					End case 
					
				: (Value type:C1509($id)=Is collection:K8:32)
					
					$isText:=True:C214
					
					This:C1470.isAndroid:=Bool:C1537($id.map(Formula:C1597(Lowercase:C14($1.value))).lastIndexOf("android")#-1)
					This:C1470.isIos:=Bool:C1537($id.map(Formula:C1597(Lowercase:C14($1.value))).lastIndexOf("ios")#-1)
					
					$session:=MobileAppServer.Session.new()
					
					If ($session.sessionDir#Null:C1517)
						$sessions.push($session)
					End if 
					
				: (Value type:C1509($id)=Is object:K8:27)
					
					$isObject:=True:C214
					
			End case 
			
		: (Count parameters:C259=2)
			
			Case of 
					
				: (Value type:C1509($id)=Is text:K8:3)
					
					$isText:=True:C214
					
					$session:=MobileAppServer.Session.new($id)
					
					$sessions.push($session)
					
					// Adding sessions with teamId prefix
					$session:=MobileAppServer.Session.new("___."+$id)
					If ($session.sessionDir#Null:C1517)
						$sessions.push($session)
					End if 
					
				: (Value type:C1509($id)=Is object:K8:27)
					
					$isObject:=True:C214
					
			End case 
			
			Case of 
					
				: (Value type:C1509($target)=Is text:K8:3)
					
					This:C1470.isAndroid:=Not:C34(Bool:C1537(Lowercase:C14($target)="ios"))
					This:C1470.isIos:=Not:C34(Bool:C1537(Lowercase:C14($target)="android"))
					
				: (Value type:C1509($target)=Is collection:K8:32)
					
					This:C1470.isAndroid:=Bool:C1537($target.map(Formula:C1597(Lowercase:C14($1.value))).lastIndexOf("android")#-1)
					This:C1470.isIos:=Bool:C1537($target.map(Formula:C1597(Lowercase:C14($1.value))).lastIndexOf("ios")#-1)
					
			End case 
			
	End case 
	
	Case of 
			
		: ($isText)
			
			var $s : Object
			var $found : Boolean
			$found:=False:C215
			
			If ($sessions.count()>1)
				
				For each ($s; $sessions) Until $found
					
					// Choosing the session with teamId that will contain .p8 file
					var $Col_app : Collection
					$Col_app:=Split string:C1554($s.sessionDir.fullName; ".")
					
					If ($Col_app.count()=4)
						
						$found:=True:C214
						
					End if 
					
				End for each 
				
			Else 
				
				$s:=$sessions[0]
				
			End if 
			
			$Obj_manifest:=getManifest($s.sessionDir)
			
			If ($Obj_manifest.success)
				
				This:C1470.auth.bundleId:=$Obj_manifest.manifest.application.id
				
				If (This:C1470.isIos)
					
					This:C1470.auth.teamId:=$Obj_manifest.manifest.team.id
					
				End if 
				
			Else 
				
				ASSERT:C1129(False:C215; "Could not get manifest info")
				
			End if 
			
			If ((Not:C34(This:C1470.onlySimulator)) & (This:C1470.isIos))
				
				$Obj_authKey:=getAuthenticationKey($s.sessionDir)
				
				If ($Obj_authKey.success)
					
					This:C1470.auth.authKey:=$Obj_authKey.authKey
					This:C1470.auth.authKeyId:=$Obj_authKey.authKeyId
					
				Else 
					
					ASSERT:C1129(False:C215; "Could not find authentication key for Apple push notification")
					
				End if 
				
				// Else : no need to generate jwt with .p8 key
			End if 
			
			
		: ($isObject)
			
			If (Bool:C1537($id.isTesting))
				This:C1470.onlySimulator:=True:C214
				This:C1470.auth.jwt:="testing"
			End if 
			
			If (Length:C16(String:C10($id.bundleId))>0)
				
				This:C1470.auth.bundleId:=$id.bundleId
				
			Else 
				
				ASSERT:C1129(False:C215; "No bundle ID provided")
				
			End if 
			
			If (This:C1470.isIos)
				
				If ((Length:C16(String:C10($id.teamId))>0) | (Bool:C1537($id.isTesting)))
					
					This:C1470.auth.teamId:=$id.teamId
					
				Else 
					
					ASSERT:C1129(False:C215; "No team ID provided for Apple push notification")
					
				End if 
				
			End if 
			
			If ((Not:C34(This:C1470.onlySimulator)) & (This:C1470.isIos))
				
				C_BOOLEAN:C305($authKeySuccess)
				
				$authKeySuccess:=False:C215
				
				// Try to get the authentication key from the entry object
				
				If ($id.authKey#Null:C1517)
					
					$Obj_authKey:=getAuthenticationKey($id.authKey)
					
					If ($Obj_authKey.success)
						
						$authKeySuccess:=True:C214
						
						This:C1470.auth.authKey:=$Obj_authKey.authKey
						This:C1470.auth.authKeyId:=$Obj_authKey.authKeyId
						
					End if 
					
				End if 
				
				// If it failed, try to find the authentication key file in the appropriate session folder
				
				If (Not:C34($authKeySuccess))
					
					If (String:C10(This:C1470.auth.teamId)#"")
						$session:=MobileAppServer.Session.new(This:C1470.auth.teamId+"."+This:C1470.auth.bundleId)
					Else 
						$session:=MobileAppServer.Session.new(This:C1470.auth.bundleId)
					End if 
					
					If ($session.sessionDir#Null:C1517)
						
						$Obj_authKey:=getAuthenticationKey($session.sessionDir)
						
						If ($Obj_authKey.success)
							
							This:C1470.auth.authKey:=$Obj_authKey.authKey
							This:C1470.auth.authKeyId:=$Obj_authKey.authKeyId
							
						Else 
							
							ASSERT:C1129(False:C215; "Could not find authentication key for Apple push notification")
							
						End if 
						
					Else 
						
						ASSERT:C1129(False:C215; "Session folder could not be found")
						
					End if 
					
					// Else : $1.authKey was valid
					
				End if 
				
				// Else : no need to generate jwt with .p8 key
			End if 
			
			
			If (Bool:C1537($id.isDevelopment))
				
				This:C1470.auth.isDevelopment:=True:C214
				
			End if 
			
			If (Length:C16(String:C10($id.serverKey))>0)
				
				This:C1470.auth.serverKey:=$id.serverKey
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215; "Incompatible entry parameter type")
			
	End case 
	
	
	If ((Not:C34(This:C1470.onlySimulator)) & (This:C1470.isIos))
		
		// Generate JWT
		
		If ((Length:C16(String:C10(This:C1470.auth.bundleId))>0)\
			 & (Length:C16(String:C10(This:C1470.auth.authKeyId))>0)\
			 & (Length:C16(String:C10(This:C1470.auth.teamId))>0))
			
			C_OBJECT:C1216($Obj_auth_result)
			
			// Get JSON Web Token
			$Obj_auth_result:=authJWT(This:C1470.auth)
			
			If (($Obj_auth_result.success)\
				 & (Length:C16(String:C10($Obj_auth_result.jwt))>0))
				
				This:C1470.auth.jwt:=$Obj_auth_result.jwt
				
			Else 
				
				ASSERT:C1129(False:C215; "Failed to generate JSON Web Token")
				
			End if 
			
		End if 
		
		If (This:C1470.auth.jwt=Null:C1517)
			
			ASSERT:C1129(False:C215; "Class initialization failed")
			
		End if 
		
		// Else : no need to generate jwt with .p8 key
	End if 
	
	
	//-------------------------------------------------------------------------
Function send($notification : Object; $recipients : Variant) : Object
	
	If ((This:C1470.auth.jwt=Null:C1517) & (Not:C34(This:C1470.onlySimulator)) & (This:C1470.isIos))
		
		ASSERT:C1129(False:C215; "Class initialization failed")
		
	End if 
	
	If ((String:C10(This:C1470.auth.serverKey)="") & (This:C1470.isAndroid))
		
		ASSERT:C1129(False:C215; "Class initialization failed : missing server key for Android push notifications")
		
	End if 
	
	// Reinitializing lastResult
	This:C1470.lastResult.success:=False:C215
	This:C1470.lastResult.warnings:=New collection:C1472
	This:C1470.lastResult.errors:=New collection:C1472
	
	This:C1470.targets:=New collection:C1472
	If (This:C1470.isAndroid)
		This:C1470.targets.push("android")
	End if 
	
	If (This:C1470.isIos)
		This:C1470.targets.push("ios")
	End if 
	
	Case of 
			
			//________________________________________
		: (Count parameters:C259>1)
			
			This:C1470.lastResult:=Mobile App Push Notification($notification; manageEntryRecipient($recipients); This:C1470.auth; This:C1470.targets)
			
			//________________________________________
		: (This:C1470.recipients#Null:C1517)  // Recipients were set, but not given in send() function parameters
			
			This:C1470.lastResult:=Mobile App Push Notification($notification; manageEntryRecipient(This:C1470.recipients); This:C1470.auth; This:C1470.targets)
			
			//________________________________________
		Else 
			
			This:C1470.lastResult.errors.push("No recipient given")
			
			//________________________________________
	End case 
	
	return This:C1470.lastResult
	
	//-------------------------------------------------------------------------
Function sendAll($notification : Object) : Object
	
	If ((This:C1470.auth.jwt=Null:C1517) & (Not:C34(This:C1470.onlySimulator)) & (This:C1470.isIos))
		
		ASSERT:C1129(False:C215; "Class initialization failed")
		
	End if 
	
	If ((String:C10(This:C1470.auth.serverKey)="") & (This:C1470.isAndroid))
		
		ASSERT:C1129(False:C215; "Class initialization failed : missing server key for Android push notifications")
		
	End if 
	
	// Reinitializing lastResult
	This:C1470.lastResult.success:=False:C215
	This:C1470.lastResult.warnings:=New collection:C1472
	This:C1470.lastResult.errors:=New collection:C1472
	
	var $Obj_session; $Obj_deviceTokens : Object
	
	var $sessions : Collection
	
	$sessions:=New collection:C1472
	
	$Obj_session:=MobileAppServer.Session.new(This:C1470.auth.bundleId)
	
	$sessions.push($Obj_session)
	
	// Adding sessions with teamId prefix
	If (String:C10(This:C1470.auth.teamId)#"")
		
		$Obj_session:=MobileAppServer.Session.new(This:C1470.auth.teamId+"."+This:C1470.auth.bundleId)
		If ($Obj_session.sessionDir#Null:C1517)
			$sessions.push($Obj_session)
		End if 
		
	End if 
	
	var $s : Object
	var $col_deviceTokens : Collection
	
	$col_deviceTokens:=New collection:C1472
	
	For each ($s; $sessions)
		
		$Obj_deviceTokens:=$s.getAllDeviceTokens()
		
		If ($Obj_deviceTokens.success)
			
			$col_deviceTokens.combine($Obj_deviceTokens.deviceTokens)
			
		End if 
		
	End for each 
	
	$col_deviceTokens:=$col_deviceTokens.distinct()
	
	
	If ($col_deviceTokens.count()>0)
		
		This:C1470.lastResult:=This:C1470.send($notification; $col_deviceTokens)
		
	Else 
		
		This:C1470.lastResult.errors.push("No recipient found")
		
	End if 
	
	return This:C1470.lastResult
	
	//-------------------------------------------------------------------------
	
/*
Sends a push notification to open a DataClass List form or an Entity Detail form
- context : Variant (Text or Object)
- notification: Object
- recipients: Variant (Text, Object, or Collection)
	
Context can be a DataClass name, a DataClass object, or an Entity object.
*/
Function open($context : Variant; $notification : Object; $recipients : Variant)->$result : Object
	
	
	If (Count parameters:C259<3)
		
		ASSERT:C1129(False:C215; "Missing parameters")
		
		// Else : all ok
	End if 
	
	
	var $userInfo : Object
	$userInfo:=$notification.userInfo
	
	$result:=New object:C1471("success"; True:C214)
	
	If ($userInfo=Null:C1517)
		
		$userInfo:=New object:C1471
		$notification.userInfo:=$userInfo
		
	End if 
	
	Case of 
			
		: (Value type:C1509($context)=Is object:K8:27)
			
			Case of 
				: (OB Instance of:C1731($context; 4D:C1709.DataClass))
					
					$userInfo.dataClass:=$context.getInfo().name
					
				: (OB Instance of:C1731($context; 4D:C1709.Entity))
					
					C_OBJECT:C1216($dataClass)
					
					$dataClass:=$context.getDataClass()
					
					$userInfo.dataClass:=$dataClass.getInfo().name
					$userInfo.entity:=New object:C1471("primaryKey"; $context[$dataClass.getInfo().primaryKey])
					
					If ($userInfo.dataSynchro=Null:C1517)
						$userInfo.dataSynchro:=True:C214
						// Else : $userInfo.dataSynchro already defined
					End if 
					
				: (Value type:C1509($context.dataClass)=Is text:K8:3)
					
					$userInfo.dataClass:=$context.dataClass
					
					If (Value type:C1509($context.entity)=Is object:K8:27)
						
						$userInfo.entity:=$context.entity
						
						If ($userInfo.dataSynchro=Null:C1517)
							$userInfo.dataSynchro:=True:C214
							// Else : $userInfo.dataSynchro already defined
						End if 
						
					End if 
					
				Else 
					
					$result.success:=False:C215
					$result.errors:=New collection:C1472("DataClass is not defined correctly")
					
			End case 
			
			
		: (Value type:C1509($context)=Is text:K8:3)
			
			If (Length:C16($context)>0)
				
				$userInfo.dataClass:=$context
				
			Else 
				
				$result.success:=False:C215
				$result.errors:=New collection:C1472("DataClass name cannot be empty")
				
			End if 
			
		Else 
			
			$result.success:=False:C215
			$result.errors:=New collection:C1472("First parameter must be a DataClass, an Entity or a Text (dataClass name)")
			
	End case 
	
	If ($result.success)
		
		$result:=This:C1470.send($notification; $recipients)
		
	End if 