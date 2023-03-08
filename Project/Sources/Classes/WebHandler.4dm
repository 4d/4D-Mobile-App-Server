
Class constructor
	SESSION INIT
	If (parameters.success)
		This:C1470.activationPath:=parameters.activation.path
	End if 
	
	
/*
Handler on web connection
- Manage /.well-known/apple-app-site-association with app from /MobileApps
- Session activation if settings is done
*/
Function handle
	C_BOOLEAN:C305($0; $handled)
	C_TEXT:C284($1; $2; $3; $4; $5; $6)
	
	$handled:=False:C215
	
	Case of 
		: ($1="/.well-known/apple-app-site-association")
			
			$handled:=This:C1470.appleAppSiteAssociation()
			
		: ($1="/.well-known/assetlinks.json")
			
			$handled:=This:C1470.assetlinks()
			
		: ($1=String:C10(This:C1470.activationPath))
			
			$handled:=Activate Sessions($1).success
			
		: (Position:C15("/mobileapp/$/"; $1)=1)
			
			If (This:C1470.handleUniversalLinks#Null:C1517)
				
				$handled:=This:C1470.handleUniversalLinks.call(This:C1470; cs:C1710.UniversalLink.new($1))
				
			End if 
			
		Else 
			
	End case 
	
	$0:=$handled
	
Function assetlinks
	var $apps : Collection
	$apps:=cs:C1710.App.new().withAssociatedDomain()  // .all()
	var $info : Collection
	$info:=New collection:C1472
	var $app; $object; $signingReport : Object
	
	For each ($app; $apps)
		
		$signingReport:=$app["signingReport"]
		
		If (($signingReport#Null:C1517) && ($signingReport["SHA-256"]#Null:C1517))
			$object:=New object:C1471
			$object.relation:=New collection:C1472("delegate_permission/common.handle_all_urls")
			$object.target:=New object:C1471("namespace"; "android_app"; "package_name"; Lowercase:C14($app.id))
			$object.target.sha256_cert_fingerprints:=New collection:C1472($signingReport["SHA-256"])
			$info.push($object)
		End if 
		
	End for each 
	
	
	// send as json string
	ARRAY TEXT:C222($headerFields; 1)
	ARRAY TEXT:C222($headerValues; 1)
	$headerFields{1}:="Content-Type"
	$headerValues{1}:="application/json"
	WEB SET HTTP HEADER:C660($headerFields; $headerValues)
	
	WEB SEND TEXT:C677(JSON Stringify:C1217($info; *))
	
/*
Send app information to support UniversalLinks
https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html
*/
Function appleAppSiteAssociation
	C_BOOLEAN:C305($0; $handled)
	C_COLLECTION:C1488($apps; $details; $appIDs)
	C_OBJECT:C1216($info; $app)
	
	$apps:=cs:C1710.App.new().withAssociatedDomain()
	$appIDs:=New collection:C1472()
	$details:=New collection:C1472()
	If ($apps.length>0)
		If ($apps.length=1)
			$app:=$apps[0]
			$details.push(New object:C1471("appID"; $app.id; "paths"; New collection:C1472($app.universalPath(True:C214))))
			$appIDs.push($app.id)
		Else 
			For each ($app; $apps)
				$details.push(New object:C1471("appID"; $app.id; "paths"; New collection:C1472($app.universalPath(False:C215))))
				$appIDs.push($app.id)
			End for each 
		End if 
		
		$info:=New object:C1471("applinks"; New object:C1471(\
			"apps"; New collection:C1472(); \
			"details"; $details); "activitycontinuation"; New object:C1471("apps"; $appIDs))
		
		// send as json string
		ARRAY TEXT:C222($headerFields; 1)
		ARRAY TEXT:C222($headerValues; 1)
		$headerFields{1}:="Content-Type"
		$headerValues{1}:="application/json"
		WEB SET HTTP HEADER:C660($headerFields; $headerValues)
		
		WEB SEND TEXT:C677(JSON Stringify:C1217($info; *))
		$handled:=True:C214
	Else 
		$handled:=False:C215
	End if 
	$0:=$handled
	
/* Provide some information if web page opening by mobile app, like dataclass or entity */
Function getContext()->$context : cs:C1710.WebContext
	$context:=cs:C1710.WebContext.new()
	