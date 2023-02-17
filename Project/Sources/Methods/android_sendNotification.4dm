//%attributes = {}
C_OBJECT:C1216($0)  // output success object
C_OBJECT:C1216($1)  // input object
C_OBJECT:C1216($Obj_result)
C_TEXT:C284($cmdPush; $cmdPush_in; $cmdPush_out; $cmdPush_err)
C_TEXT:C284($endpoint)

LOG EVENT:C667(Into 4D debug message:K38:5; "[Android PushNotification]"+$cmdPush)

$Obj_result:=New object:C1471("success"; False:C215)


// ENDPOINT
//________________________________________

$endpoint:="https://fcm.googleapis.com/fcm/send"

If ((Length:C16(String:C10($1.serverKey))>0)\
 & (Length:C16(String:C10($1.message))>0))
	
	$cmdPush:="curl"
	
	If (Is Windows:C1573)
		checkCurlWindow
		$cmdPush:=curlWinPath
	End if 
	
	$cmdPush:=$cmdPush+" -X POST "+\
		"--header \"Authorization: key="+$1.serverKey+"\" "+\
		"--header \"Content-Type: application/json\" "+\
		$endpoint+" "+\
		"-d \""+Replace string:C233($1.message; "\""; "\\\"")+"\""
	
	LAUNCH EXTERNAL PROCESS:C811($cmdPush; $cmdPush_in; $cmdPush_out; $cmdPush_err)
	
	If (Length:C16($cmdPush_err)>0)
		
		LOG EVENT:C667(Into 4D debug message:K38:5; "[Android PushNotification]"+$cmdPush_err)
		
	Else   // Notification sent successfully
		
		$Obj_result.success:=True:C214
		
	End if 
	
	If (Length:C16($cmdPush_out)>0)  // If notification sending failed, $cmdPush_out contains the error
		
		LOG EVENT:C667(Into 4D debug message:K38:5; "[Android PushNotification]"+$cmdPush_out)
		
	End if 
	
	// Else : Missing parameter in input object
	
End if 

$0:=$Obj_result