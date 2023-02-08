Class constructor
	C_OBJECT:C1216($1)
	C_OBJECT:C1216($manifest)
	C_TEXT:C284($key)
	
	Case of 
		: (Count parameters:C259=0)
			// just for static method, not a real app
		: ($1=Null:C1517)
			// just for static method, not a real app
			
		: (OB Instance of:C1731($1; 4D:C1709.Folder))
			
			This:C1470.folder:=$1
			
		: (Value type:C1509($1["id"])=Is text:K8:3)
			
			This:C1470.folder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder($1.id)
			
			For each ($key; $1)
				
				This:C1470[$key]:=$1[$key]
				
			End for each 
			
		: ((Value type:C1509($1.application)=Is object:K8:27))
			
			This:C1470.folder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder(appID($1))
			
			For each ($key; $1)
				
				This:C1470[$key]:=$1[$key]
				
			End for each 
			
		Else 
			// 
			
	End case 
	
	If (This:C1470.folder#Null:C1517)
		$manifest:=This:C1470.folder.file("manifest.json")
		If ($manifest.exists)
			
			// copy all in app
			$manifest:=JSON Parse:C1218($manifest.getText())  // XXX Catch error?
			
			For each ($key; $manifest)
				
				This:C1470[$key]:=$manifest[$key]
				
			End for each 
			
		End if 
	End if 
	
	This:C1470._checkId()
	
	/// Return all App instances.
Function all()->$apps : Collection  // TODO must be static if language allow it
	
	var $Dir_mobileApps; $appFolder : 4D:C1709.Folder
	$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18; *)
	
	$apps:=New collection:C1472()
	If ($Dir_mobileApps.exists)
		
		For each ($appFolder; $Dir_mobileApps.folders())
			$apps.push(cs:C1710.App.new($appFolder))
		End for each 
		
	End if 
	
	/// Return App instances with an associated doain
Function withAssociatedDomain()->$apps : Collection  // TODO must be static if language allow it
	var $app : cs:C1710.App
	var $Dir_mobileApps; $appFolder : 4D:C1709.Folder
	$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18; *)
	
	$apps:=New collection:C1472()
	If ($Dir_mobileApps.exists)
		
		For each ($appFolder; $Dir_mobileApps.folders())
			$app:=cs:C1710.App.new($appFolder)
			If ($app.hasAssociatedDomain())
				$apps.push($app)
			End if 
		End for each 
		
	End if 
	
Function getSessionManager()->$sessionManager : cs:C1710.Session
	This:C1470._checkId()
	$sessionManager:=cs:C1710.Session.new(This:C1470.id)
	
	// recreate app manifest.json
Function create
	If (This:C1470.folder=Null:C1517)
		This:C1470._checkFolder()
	End if 
	
	This:C1470.folder.file("manifest.json").setText(JSON Stringify:C1217(This:C1470))
	
Function _checkFolder
	This:C1470._checkId()
	
	This:C1470.folder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder(This:C1470.id)
	If (Not:C34(This:C1470.folder.exists))
		This:C1470.folder.create()
	End if 
	
Function _checkId
	If (This:C1470.id=Null:C1517)
		This:C1470.id:=appID(This:C1470)
	End if 
	
Function hasAssociatedDomain()->$has : Boolean
	$has:=Length:C16(String:C10(This:C1470.associatedDomain))>0
	
Function universalLink($context : Object)->$url : Text
	
	$url:=String:C10(This:C1470.associatedDomain)
	If ($url[[Length:C16($url)]]#"/")
		$url:=$url+"/"
	End if 
	
	C_COLLECTION:C1488($apps)
	$apps:=cs:C1710.App.new().withAssociatedDomain()
	If ($apps.length=1)  // short url if one app
		$url:=$url+"mobileapp/$/"+This:C1470.contextPathAndQuery($context)
	Else 
		$url:=$url+"mobileapp/$/"+This:C1470.id+"/"+This:C1470.contextPathAndQuery($context)
	End if 
	
Function universalPath($short : Boolean)->$path : Text
	If ($short)
		$path:="/mobileapp/$/*"
	Else 
		$path:="/mobileapp/$/"+This:C1470.id+"/*"
	End if 
	
Function hasURLScheme->$has : Boolean
	$has:=Length:C16(String:C10(This:C1470.urlScheme))>0
	
Function urlSchemeURL($context : Object)->$url : Text
	$url:=String:C10(This:C1470.urlScheme)+"://mobileapp/"+This:C1470.contextPathAndQuery($context)
	
Function contextPathAndQuery($context : Object)->$query : Text
	$query:=""
	If (Length:C16(String:C10($context.dataClass))>0)  // & $1.context.dataClass#Null (String(Null) is "null")
		
		Case of 
				
			: ((Value type:C1509($context.parent)=Is object:K8:27) && ((Length:C16(String:C10($context.parent.primaryKey))>0) & (Length:C16(String:C10($context.parent.dataClass))>0)))
				// Table/DataClass, filtered by a parent record/entity relation
				
				$query:="dataClass="+queryURLEncode(String:C10($context.parent.dataClass))
				
				$query:=$query+"&entity.primaryKey="+queryURLEncode(String:C10($context.parent.primaryKey))
				
				$query:=$query+"&relationName="+queryURLEncode(String:C10($context.parent.relationName))
				
			: (Value type:C1509($context.entity)=Is object:K8:27)  // n.b. $Obj_request.context object already checked by previous method
				// Record/Entity
				$query:="dataClass="+queryURLEncode(String:C10($context.dataClass))
				
				If (Length:C16(String:C10($context.entity.primaryKey))>0)
					
					$query:=$query+"&entity.primaryKey="+queryURLEncode(String:C10($context.entity.primaryKey))
					
				End if 
				
			Else 
				// Table/DataClass
				$query:="dataClass="+queryURLEncode(String:C10($context.dataClass))
				
		End case 
		
	End if 
	
	$query:="show?"+$query
	