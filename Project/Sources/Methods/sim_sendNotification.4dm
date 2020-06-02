//%attributes = {"invisible":true,"preemptive":"capable"}
  // This methods sends a push notification on a simulator.
  // This can only be performed with XCode 11.4 (with macOS Catalina)

C_OBJECT:C1216($0)  // output success object
C_OBJECT:C1216($1)  // input object
C_OBJECT:C1216($Obj_result;$payloadFile;$tmpFolder)
C_TEXT:C284($cmdSimPush;$cmdSimPush_in;$cmdSimPush_out;$cmdSimPush_err)

LOG EVENT:C667(Into 4D debug message:K38:5;$cmdSimPush)

$Obj_result:=New object:C1471("success";False:C215)

If ((Length:C16(String:C10($1.bundleId))>0)\
 & (Length:C16(String:C10($1.payload))>0)\
 & (Length:C16(String:C10($1.deviceToken))>0))
	
	  // write payload file
	
	$tmpFolder:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2)
	
	$payloadFile:=$tmpFolder.file("tmp_payload_"+$1.deviceToken+".json")
	$payloadFile.create()
	
	If ($payloadFile.exists)
		
		$payloadFile.setText($1.payload)
		
		$cmdSimPush:="xcrun simctl push"
		
		$cmdSimPush:=$cmdSimPush+" "+$1.deviceToken+" "+$1.bundleId+" "+$payloadFile.path
		
		LAUNCH EXTERNAL PROCESS:C811($cmdSimPush;$cmdSimPush_in;$cmdSimPush_out;$cmdSimPush_err)
		
		If (Length:C16($cmdSimPush_err)>0)
			
			LOG EVENT:C667(Into 4D debug message:K38:5;$cmdSimPush_err)
			$Obj_result.error:=$cmdSimPush_err
			
		End if 
		
		If (Length:C16($cmdSimPush_out)>0)
			
			  // Notification sent successfully
			$Obj_result.success:=True:C214
			
		End if 
		
		$payloadFile.delete()
		
		  // Else : payload file creation failed
		
	End if 
	
End if 

$0:=$Obj_result