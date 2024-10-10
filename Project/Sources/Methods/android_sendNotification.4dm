//%attributes = {}
#DECLARE($input : Object)->$Obj_result : Object

var $cmdPush; $cmdPush_in; $cmdPush_out; $cmdPush_err : Text

LOG EVENT:C667(Into 4D debug message:K38:5; "[Android PushNotification] "+$cmdPush)

$Obj_result:=New object:C1471("success"; False:C215)

// ENDPOINT
//________________________________________
var $endpoint : Text
If ($input.project#Null:C1517)
	$endpoint:="https://fcm.googleapis.com/v1/projects/"+String:C10($input.project)+"/messages:send"
Else 
	$endpoint:="https://fcm.googleapis.com/fcm/send"
End if 

If ((Length:C16(String:C10($input.serverKey))>0)\
 & (Length:C16(String:C10($input.message))>0))
	
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
		"-d \""+Replace string:C233($input.message; "\""; "\\\"")+"\""
	
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
