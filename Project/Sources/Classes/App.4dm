Class constructor
	C_OBJECT:C1216($1)
	C_OBJECT:C1216($manifest)
	C_TEXT:C284($key)
	
	Case of 
		: ($1=Null:C1517)
			// just for static method, not a real app
			
		: (OB Instance of:C1731($1; 4D:C1709.Folder))
			
			This:C1470.folder:=$1
			
		: (Value type:C1509($1["id"])=Is text:K8:3)
			
			This:C1470.folder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder($1.id)
			
			For each ($key; $1)
				
				This:C1470[$key]:=$1[$key]
				
			End for each 
			
		: ((Value type:C1509($1.team)=Is object:K8:27) & (Value type:C1509($1.application)=Is object:K8:27))
			
			This:C1470.folder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder(String:C10($1.team.id)+"."+String:C10($1.application.id))
			
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
Function all  // TODO must be static if language allow it
	C_COLLECTION:C1488($0; $apps)
	C_OBJECT:C1216($Dir_mobileApps; $appFolder)
	$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18; *)
	
	$apps:=New collection:C1472()
	If ($Dir_mobileApps.exists)
		
		For each ($appFolder; $Dir_mobileApps.folders())
			$apps.push(cs:C1710.App.new($appFolder))
		End for each 
		
		
	End if 
	
	$0:=$apps
	
	/// Return App instances with an associated doain
Function withAssociatedDomain  // TODO must be static if language allow it
	C_COLLECTION:C1488($0; $apps)
	C_OBJECT:C1216($Dir_mobileApps; $appFolder)
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
	
	$0:=$apps
	
	
Function getSessionManager
	C_OBJECT:C1216($0)
	This:C1470._checkId()
	$0:=cs:C1710.Session.new(This:C1470.id)
	
	// recreate app manifest.json
Function create
	C_OBJECT:C1216($folder)
	$folder:=This:C1470.folder
	If ($folder=Null:C1517)
		This:C1470._checkFolder()
	Else 
		This:C1470.folder:=Null:C1517
	End if 
	This:C1470.folder.file("manifest.json").setText(JSON Stringify:C1217(This:C1470))
	
	This:C1470.folder:=$folder
	
Function _checkFolder
	C_OBJECT:C1216($folder)
	This:C1470._checkId()
	$folder:=Folder:C1567(fk mobileApps folder:K87:18; *).folder(This:C1470.id)
	If (Not:C34($folder.exists))
		$folder.create()
	End if 
	
Function _checkId
	If (This:C1470.id=Null:C1517)
		This:C1470.id:=String:C10(This:C1470.team.id)+"."+String:C10(This:C1470.application.id)  // could also check that but...
	End if 
	
Function hasAssociatedDomain
	C_BOOLEAN:C305($0)
	$0:=Length:C16(String:C10(This:C1470.associatedDomain))>0
	
Function universalLink
	C_TEXT:C284($0; $url)
	C_OBJECT:C1216($1; $context)
	$context:=$1
	
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
	
	$0:=$url
	
Function universalPath
	C_TEXT:C284($path; $0)
	C_BOOLEAN:C305($short; $1)
	$short:=$1
	
	If ($short)
		$path:="/mobileapp/$/*"
	Else 
		$path:="/mobileapp/$/"+This:C1470.id+"/*"
	End if 
	$0:=$path
	
Function hasURLScheme
	C_BOOLEAN:C305($0)
	$0:=Length:C16(String:C10(This:C1470.urlScheme))>0
	
Function urlSchemeURL
	C_TEXT:C284($0; $url)
	C_OBJECT:C1216($1; $context)
	$context:=$1
	
	$url:=String:C10(This:C1470.urlScheme)+"://mobileapp/"+This:C1470.contextPathAndQuery($context)
	
	$0:=$url
	
Function contextPathAndQuery
	C_TEXT:C284($0; $query)
	C_OBJECT:C1216($1; $context)
	$context:=$1
	
	$query:=""
	If (Length:C16(String:C10($context.dataClass))>0)  // & $1.context.dataClass#Null (String(Null) is "null")
		
		$query:="dataClass="+String:C10($context.dataClass)  // TODO query url encode
		
		If (Value type:C1509($context.entity)=Is object:K8:27)  // n.b. $Obj_request.context object already checked by previous method
			
			If (Length:C16(String:C10($context.entity.primaryKey))>0)
				
				$query:=$query+"&entity.primaryKey="+String:C10($context.entity.primaryKey)  // TODO query url encode
				
			End if 
		End if 
	End if 
	
	$0:="show?"+$query
	