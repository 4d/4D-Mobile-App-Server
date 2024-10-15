//%attributes = {}
#DECLARE($input : Object)->$Obj_result : Object

var $cmdPush; $cmdPush_in; $cmdPush_out; $cmdPush_err : Text

LOG EVENT:C667(Into 4D debug message:K38:5; "[Android PushNotification] "+$cmdPush)

$Obj_result:=New object:C1471("success"; False:C215)

// ENDPOINT
//________________________________________

var $message : Variant
$message:=$input.message

var $endpoint : Text
If ($input.project#Null:C1517)
	
	$endpoint:="https://fcm.googleapis.com/v1/projects/"+String:C10($input.project)+"/messages:send"
	
	If (Value type:C1509($input.message)=Is object:K8:27)
		
		If ($input.message.to#Null:C1517)
			// old format, convert
			$message:=New object:C1471("message"; New object:C1471("token"; $input.message.to; "notification"; $input.message.data))
		End if 
		
	End if 
	
Else 
	$endpoint:="https://fcm.googleapis.com/fcm/send"
End if 

var $messageText : Text
Case of 
	: (Value type:C1509($message)=Is object:K8:27)
		$messageText:=JSON Stringify:C1217($message)
	Else 
		$messageText:=String:C10($message)
End case 

If ((Length:C16(String:C10($input.serverKey))>0)\
 & (Length:C16($messageText)>0))
	
	$cmdPush:="curl"
	
	If (Is Windows:C1573)
		checkCurlWindow
		$cmdPush:=curlWinPath
	End if 
	
	var $authorizationHeader : Text
	If ($input.project#Null:C1517)
		$authorizationHeader:="Bearer "+$input.serverKey
	Else 
		$authorizationHeader:="key="+$input.serverKey
	End if 
	
	$cmdPush:=$cmdPush+" -X POST "+\
		"--header \"Authorization: "+$authorizationHeader+"\" "+\
		"--header \"Content-Type: application/json\" "+\
		$endpoint+" "+\
		"-d \""+Replace string:C233($messageText; "\""; "\\\"")+"\""
	
	LAUNCH EXTERNAL PROCESS:C811($cmdPush; $cmdPush_in; $cmdPush_out; $cmdPush_err)
	
	If (Length:C16($cmdPush_err)>0)
		
		LOG EVENT:C667(Into 4D debug message:K38:5; "[Android PushNotification] "+$cmdPush_err)
		
	End if 
	
	If (Length:C16($cmdPush_out)>0)  // If notification sending failed, $cmdPush_out contains the error
		
		LOG EVENT:C667(Into 4D debug message:K38:5; "[Android PushNotification] "+$cmdPush_out)
		
	End if 
	
	// Notification sent successfully
	
	var $response : Object
	
	$response:=JSON Parse:C1218($cmdPush_out)
	
	If (Bool:C1537($response.success))
		
		$Obj_result.success:=True:C214
		
	End if 
	
	// Else : Missing parameter in input object
	
End if 
