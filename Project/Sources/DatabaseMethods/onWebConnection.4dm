var $handler : cs:C1710.WebHandler
$handler:=MobileAppServer.WebHandler.new()

Case of 
	: ($handler.handle($1; $2; $3; $4; $5; $6))
		// Managed by default mobile code
	Else 
		
		// your web code
		
End case 