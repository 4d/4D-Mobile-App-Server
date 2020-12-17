//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // output success object
C_OBJECT:C1216($1)  // input object
C_OBJECT:C1216($Obj_result)
C_TEXT:C284($cmdPush;$cmdPush_in;$cmdPush_out;$cmdPush_err)
C_TEXT:C284($endpoint)

LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush)

$Obj_result:=New object:C1471("success";False:C215)


  // ENDPOINT
  //________________________________________

If (Not:C34(Bool:C1537($1.isDevelopment)))
	
	$endpoint:="https://api.push.apple.com"
	
Else 
	
	$endpoint:="https://api.sandbox.push.apple.com"
	
End if 

If ((Length:C16(String:C10($1.jwt))>0)\
 & (Length:C16(String:C10($1.bundleId))>0)\
 & (Length:C16(String:C10($1.payload))>0)\
 & (Length:C16(String:C10($1.deviceToken))>0))
	
	$cmdPush:="curl"
	
	If (Is Windows:C1573)
		$cmdPush:=$cmdPush+".exe"
	End if 
	
	$cmdPush:=$cmdPush+" --verbose "+\
		"--header \"content-type: application/json\" "+\
		"--header \"authorization: bearer "+$1.jwt+"\" "+\
		"--header \"apns-topic: "+$1.bundleId+"\" "+\
		"--data '"+$1.payload+"' "+\
		""+$endpoint+"/3/device/"+$1.deviceToken
	
	LAUNCH EXTERNAL PROCESS:C811($cmdPush;$cmdPush_in;$cmdPush_out;$cmdPush_err)
	
	If (Length:C16($cmdPush_err)>0)
		
		LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush_err)
		
	End if 
	
	If (Length:C16($cmdPush_out)>0)  // If notification sending failed, $cmdPush_out contains the error
		
		LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush_out)
		
	Else   // Notification sent successfully
		
		$Obj_result.success:=True:C214
		
	End if 
	
	  // Else : Missing parameter in input object
	
End if 

$0:=$Obj_result