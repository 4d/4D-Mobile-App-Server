//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // Returned object
C_OBJECT:C1216($1)  // Notification content
C_OBJECT:C1216($2)  // Recipients collections
C_OBJECT:C1216($3)  // Authentication object

C_COLLECTION:C1488($mails;$deviceTokens)
C_OBJECT:C1216($Obj_result;$Obj_notification;$Obj_auth;$status;$Obj_recipients_result)


  // PARAMETERS
  //________________________________________

C_LONGINT:C283($Lon_parameters)

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	$Obj_result:=New object:C1471("success";False:C215)
	$Obj_result.errors:=New collection:C1472
	$Obj_result.warnings:=New collection:C1472
	
	
	$Obj_notification:=$1
	
	$deviceTokens:=$2.deviceTokens
	$mails:=$2.mails
	
	$Obj_auth:=$3
	
	
	C_BOOLEAN:C305($isMissingRecipients)
	
	If (Not:C34($mails.length>0) & (Not:C34($deviceTokens.length>0)))  // Both mails and deviceTokens collections are empty
		
		$isMissingRecipients:=True:C214
		
		$Obj_result.errors.push("Both mails and deviceTokens collections are empty")
		
	End if 
	
End if 


  // PREPARE NOTIFICATION SENDING
  //________________________________________

If (Not:C34($isMissingRecipients))
	
	
	  // Build (mails + deviceTokens) collection
	  //________________________________________
	
	$Obj_recipients_result:=buildRecipients ($2;$Obj_auth.teamId;$Obj_auth.bundleId)
	
	$Obj_result.warnings:=$Obj_recipients_result.warnings
	
	
	  // BUILD NOTIFICATION
	  //________________________________________
	
	C_TEXT:C284($payload)
	
	$payload:=JSON Stringify:C1217(buildNotification ($Obj_notification))
	
	
	  // SEND NOTIFICATION
	  //________________________________________
	
	C_OBJECT:C1216($mailAndDeviceToken;$notificationInput)
	
	For each ($mailAndDeviceToken;$Obj_recipients_result.recipients)  // Sending a notification for every single deviceToken
		
		$notificationInput:=New object:C1471(\
			"jwt";$Obj_auth.jwt;\
			"bundleId";$Obj_auth.bundleId;\
			"payload";$payload;\
			"deviceToken";$mailAndDeviceToken.deviceToken;\
			"isDevelopment";$Obj_auth.isDevelopment)
		
		If (Length:C16($mailAndDeviceToken.deviceToken)=64)
			
			$status:=apple_sendNotification ($notificationInput)
			
		Else 
			
			If (checkXCodeVersionForPushNotif )
				
				$status:=sim_sendNotification ($notificationInput)
				
				If (Not:C34($status.success))
					
					If (Length:C16($status.error)>0)
						
						$Obj_result.errors.push($status.error)
						
					End if 
					
				End if 
				
			Else 
				
				$Obj_result.warnings.push("In order to send push notifications to simulators, you need macOS and XCode version must be at least 11.4")
				
			End if 
			
		End if 
		
		
		If ($status.success)  // Notification sent successfully
			
			$Obj_result.success:=True:C214  // At least one notification was sent successfully, other potential failures are pushed in warnings collection
			
		Else 
			  // Adding notfication sending failure message to the returned object for further treatment
			$Obj_result.warnings.push("Failed to send push notification to :\n ["+String:C10($mailAndDeviceToken.email)+" ; "+String:C10($mailAndDeviceToken.deviceToken)+"]")
			
		End if 
		
	End for each 
	
	  // Else : errors occurred, already pushed in $Obj_result.errors
	
End if 


$0:=$Obj_result
