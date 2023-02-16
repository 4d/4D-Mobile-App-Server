//%attributes = {}
var $response; $notification; $pushNotification : Object

// Define notification

$notification:=New object:C1471(\
"title"; "Testing notification"; \
"body"; "This is the content of a test notification")

var $bundleId : Text

$bundleId:="com.test.pntest"

// Create test session
createTestSession($bundleId)

// Test
var $target : Text
$target:="android"

$pushNotification:=MobileAppServer.PushNotification.new($bundleId; $target)

$pushNotification.auth.serverKey:="test"

$response:=$pushNotification.sendAll($notification)

If ($response.success)
	
	ASSERT:C1129($response.errors.count()=0; "There should not be any error on success")
	
Else 
	
	ASSERT:C1129((($response.errors.count()#0) | ($response.warnings.count()#0)); "There should be at least one error or warning on failure")
	
End if 



$response:=$pushNotification.send($notification)

ASSERT:C1129(Not:C34($response.success); "Function should fail")

ASSERT:C1129($response.errors.count()#0; "There should not be an error on missing recipient")



$response:=$pushNotification.send($notification; "john@doe.com")

ASSERT:C1129(Not:C34($response.success); "Function should fail")

ASSERT:C1129($response.warnings.count()#0; "There should not be a warning on no matching session")


deleteTestSession($bundleId)
