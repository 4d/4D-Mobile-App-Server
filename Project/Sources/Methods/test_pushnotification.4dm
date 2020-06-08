//%attributes = {}
C_OBJECT:C1216($response;$notification;$Dir_mobileApps;$pushNotification)
ARRAY TEXT:C222($appFoldersList;0)

  // Define notification

$notification:=New object:C1471(\
"title";"Testing notification";\
"body";"This is the content of a test notification")

  // Check there is only one application for this test

$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18;*)

FOLDER LIST:C473($Dir_mobileApps.platformPath;$appFoldersList)

ASSERT:C1129(Size of array:C274($appFoldersList)=1;"Can't have more than one application in MobileApps for this test")

  // Test

$pushNotification:=MobileAppServer .PushNotification.new()



$response:=$pushNotification.sendAll($notification)

If ($response.success)
	
	ASSERT:C1129($response.errors.count()=0;"There should not be any error on success")
	
Else 
	
	ASSERT:C1129((($response.errors.count()#0) | ($response.warnings.count()#0));"There should be at least one error or warning on failure")
	
End if 



$response:=$pushNotification.send($notification)

ASSERT:C1129(Not:C34($response.success);"Function should fail")

ASSERT:C1129($response.errors.count()#0;"There should not be an error on missing recipient")



$response:=$pushNotification.send($notification;"john@doe.com")

ASSERT:C1129(Not:C34($response.success);"Function should fail")

ASSERT:C1129($response.warnings.count()#0;"There should not be a warning on no matching session")
