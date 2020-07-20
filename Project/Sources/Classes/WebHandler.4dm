
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
			
		: ($1=String:C10(This:C1470.activationPath))
			
			$0:=Activate Sessions($1).success
			
		Else 
			
	End case 
	
	
	$0:=$handled
	
/*
Send app information to support UniversalLinks
https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html
*/
Function appleAppSiteAssociation
	C_BOOLEAN:C305($0; $handled)
	C_COLLECTION:C1488($apps; $details)
	C_OBJECT:C1216($info; $app)
	
	$apps:=cs:C1710.App.new().all()
	If ($apps.length>0)
		$details:=New collection:C1472()
		If ($apps.length=1)
			$app:=$apps[0]
			$details.push(New object:C1471("appID"; $app.id; "paths"; New collection:C1472("/mobilelink/*")))
		Else 
			
			For each ($app; $apps)
				
				$details.push(New object:C1471("appID"; $app.id; "paths"; New collection:C1472("/mobilelink/"+$app.id+"/*")))
				
			End for each 
			
		End if 
		
		$info:=New object:C1471("applinks"; New object:C1471(\
			"apps"; New collection:C1472(); \
			"details"; $details))
		
		
		// send as json string
		ARRAY TEXT:C222($headerFields; 1)
		ARRAY TEXT:C222($headerValues; 1)
		$headerFields{1}:="Content-Type"
		$headerValues{1}:="application/json"
		WEB SET HTTP HEADER:C660($headerFields; $headerValues)
		
		WEB SEND TEXT:C677(JSON Stringify:C1217($info))
		$handled:=True:C214
	Else 
		$handled:=False:C215
	End if 