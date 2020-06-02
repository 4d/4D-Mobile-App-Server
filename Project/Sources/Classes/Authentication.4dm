  // Wrapper `On Mobile App Authentication` input
Class constructor
	C_OBJECT:C1216($1)
	This:C1470.request:=$1
	This:C1470.class:=OB Class:C1730(This:C1470)
	
	If ($1=Null:C1517)
		
		ASSERT:C1129(False:C215;"Failed to "+Current method name:C684)
		
	End if 
	
	C_OBJECT:C1216($class)
	$class:=OB Class:C1730(This:C1470)
	
	Use ($class)
		
		If ($class.folder=Null:C1517)
			
			$class.folder:=Folder:C1567(fk mobileApps folder:K87:18;*)
			
		End if 
	End use 
	
Function getAppID
	C_TEXT:C284($0)
	$0:=This:C1470.request.team.id+"."+This:C1470.request.application.id
	
Function getSessionFile
	C_OBJECT:C1216($0)
	$0:=OB Class:C1730(This:C1470).folder.folder(This:C1470.getAppID()).file(This:C1470.request.session.id)
	
Function getSessionObject
	C_OBJECT:C1216($0)
	$0:=Mobile App Session Object (This:C1470.getSessionFile())  // XXX maybe create a class also
	
Function confirmEmail
	C_OBJECT:C1216($0)
	$0:=Mobile App Email Checker (This:C1470.request)