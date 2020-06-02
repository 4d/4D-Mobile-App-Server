//%attributes = {"preemptive":"capable"}
C_OBJECT:C1216($response)


  // NOTIFICATION
  //________________________________________

C_OBJECT:C1216($notification)

$notification:=New object:C1471
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"
$notification.imageUrl:="https://media.giphy.com/media/eWW9O2a4IdpWU/giphy.gif"


  // RECIPIENTS
  //________________________________________

C_COLLECTION:C1488($deviceTokens;$mails;$simulators)
C_OBJECT:C1216($recipientsOk;$recipientsWithNoMail;$recipientsWithNoDeviceToken;$recipientsEmpty)

$deviceTokens:=New collection:C1472(\
"XXXXXf3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a";\
"YYYYYf3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a")

$mails:=New collection:C1472(\
"abc@gmail.com";\
"def@gmail.com";\
"ghi@gmail.com";\
"123@gmail.com")

  // Not unit tested because it depends on XCode version installed on the running machine
$simulators:=New collection:C1472(\
"8354843-F30C-4F63-A295-BE352517A287";\
"9B5A7F83-F30C-4F63-A295-BE352517A287")

$recipientsOk:=New object:C1471
$recipientsOk.mails:=$mails
$recipientsOk.deviceTokens:=$deviceTokens

$recipientsWithNoMail:=New object:C1471
$recipientsWithNoMail.deviceTokens:=$deviceTokens

$recipientsWithNoDeviceToken:=New object:C1471
$recipientsWithNoDeviceToken.mails:=$mails

$recipientsEmpty:=New object:C1471


  // AUTHENTICATION
  //________________________________________

C_TEXT:C284($bundleId;$authKeyId;$teamId)
C_OBJECT:C1216($authOk;$authWithWrongBundleId;$authWithWrongAuthKey;$authOkIncomplete;$authKeyOk;$authKeyDoesNotExist)

$bundleId:="com.sample.xxx"

$authKeyOk:=File:C1566("/RESOURCES/AuthKey_4W2QJ2R2WS.p8")
ASSERT:C1129($authKeyOk.exists;"AuthKey file is required to run tests")
$authKeyDoesNotExist:=File:C1566("/RESOURCES/AuthKey_XXXXX.p8")

$authKeyId:="4W2QJ2R2WS"
$teamId:="UTT7VDX8W5"

$authOk:=New object:C1471(\
"bundleId";$bundleId;\
"authKey";$authKeyOk;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$authWithWrongAuthKey:=New object:C1471(\
"bundleId";$bundleId;\
"authKey";$authKeyDoesNotExist;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$authOkIncomplete:=New object:C1471(\
"bundleId";$bundleId;\
"authKey";$authKeyOk;\
"authKeyId";$authKeyId)


  // ASSERTS
  //________________________________________

C_OBJECT:C1216($pushNotification)

$pushNotification:=MobileAppServer .PushNotification.new($authOk)



$response:=$pushNotification.send($notification;$recipientsOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=6;"Problem with warnings count")  // 4x "No session file found" for mail addresses + 2x wrong deviceTokens



$response:=$pushNotification.send($notification;$recipientsWithNoDeviceToken)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=4;"Problem with warnings count")  // 4x "No session file found" for mail addresses



$response:=$pushNotification.send($notification;$recipientsWithNoMail)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=2;"Problem with warnings count")  // 2x wrong deviceTokens



$response:=$pushNotification.send($notification;$recipientsEmpty)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Empty recipients collections

ASSERT:C1129($response.warnings.count()=0;"Problem with warnings count")