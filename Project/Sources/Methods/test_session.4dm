//%attributes = {}
var $response; $Dir_mobileApps; $Obj_session : Object

// Check there is only one application for this test

$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18; *)

ASSERT:C1129($Dir_mobileApps.folders().length=1; "Can't have more than one application in MobileApps for this test")

// Test

$Obj_session:=MobileAppServer.Session.new()

ASSERT:C1129($Obj_session.sessionDir#Null:C1517; "sessionDir should be set in Session class")



$response:=$Obj_session.getAllDeviceTokens()

If ($response.success)
	
	ASSERT:C1129($response.deviceTokens.count()>0; "There should be at least one deviceToken found")
	
Else 
	
	ASSERT:C1129($response.deviceTokens.count()=0; "No deviceToken should be found")
	
End if 



$response:=$Obj_session.getAllMailAddresses()

If ($response.success)
	
	ASSERT:C1129($response.mailAddresses.count()>0; "There should be at least one mail address found")
	
Else 
	
	ASSERT:C1129($response.mailAddresses.count()=0; "No mail address should be found")
	
End if 



$response:=$Obj_session.getSessionInfoFromMail("john@doe.com")

If ($response.success)
	
	ASSERT:C1129($response.sessions.count()>0; "There should be at least one session found")
	
Else 
	
	ASSERT:C1129($response.sessions.count()=0; "No session should be found")
	
End if 

