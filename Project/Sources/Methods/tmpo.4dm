//%attributes = {}

var $pushNotification : Object
var $notification : Object
var $response : Object
var $target : Collection

$target:=New collection:C1472("ios"; "android")
//$pushNotification:=MobileAppServer.PushNotification.new($target)
$pushNotification:=MobileAppServer.PushNotification.new("android")

$notification:=New object:C1471
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"
$notification.imageUrl:="https://placebear.com/200/300"
$notification.userInfo:=New object:C1471
$notification.userInfo.dataSynchro:=False:C215

$pushNotification.auth.serverKey:="AAAAZWXc1Zw:APA91bGLiar8zyADQkyJk3PG1_gC6kPZ_ke9XQ301HLC7F0_Fendar0zZxfrhJJAxI7WU5fMvhLLlfznzolod4bEozmPGQh55ffQWa8PR_dUpuFKoGnyTThKXs9fI0BbdJrEUB4oZaot"

$response:=$pushNotification.sendAll($notification)

ASSERT:C1129(True:C214)