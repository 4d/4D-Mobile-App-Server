//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // Returned object
C_OBJECT:C1216($1)  // Notification content
C_OBJECT:C1216($2)  // Recipients collections
C_OBJECT:C1216($3)  // Authentication object
C_COLLECTION:C1488($4)  // Targets collection

C_COLLECTION:C1488($mails; $deviceTokens)
C_OBJECT:C1216($Obj_result; $Obj_auth; $status; $Obj_notification; $Obj_recipients_result)


// PARAMETERS
//________________________________________

C_LONGINT:C283($Lon_parameters)

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=4; "Missing parameter"))
	
	$Obj_result:=New object:C1471("success"; False:C215)
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


// PREPARE NOTIFICATION
//________________________________________

If (Not:C34($isMissingRecipients))
	
	
	// Build (mails + deviceTokens) collection
	//________________________________________
	
	$Obj_recipients_result:=buildRecipients($2; $Obj_auth.teamId; $Obj_auth.bundleId; $4)
	
	$Obj_result.warnings:=$Obj_recipients_result.warnings
	
	
	// SEND NOTIFICATION
	//________________________________________
	
	C_OBJECT:C1216($mailAndDeviceToken; $notificationInput; $Obj_buildNotification)
	
	For each ($mailAndDeviceToken; $Obj_recipients_result.recipients)  // Sending a notification for every single deviceToken
		
		
		// BUILD NOTIFICATION
		//________________________________________
		
		Case of 
				
			: ($mailAndDeviceToken.target="ios")
				
				$Obj_buildNotification:=buildAppleNotification($Obj_notification)
				
				C_TEXT:C284($payload)
				$payload:=JSON Stringify:C1217($Obj_buildNotification)
				
				$notificationInput:=New object:C1471(\
					"jwt"; $Obj_auth.jwt; \
					"bundleId"; $Obj_auth.bundleId; \
					"payload"; $payload; \
					"deviceToken"; $mailAndDeviceToken.deviceToken; \
					"isDevelopment"; $Obj_auth.isDevelopment)
				
				
				// SEND NOTIFICATION
				//________________________________________
				
				If (Length:C16($mailAndDeviceToken.deviceToken)=64)
					
					$status:=apple_sendNotification($notificationInput)
					
				Else 
					
					If (checkXCodeVersionForPushNotif)
						
						$status:=sim_sendNotification($notificationInput)
						
						If (Not:C34($status.success))
							
							If (Length:C16($status.error)>0)
								
								$Obj_result.errors.push($status.error)
								
							End if 
							
						End if 
						
					Else 
						
						$Obj_result.warnings.push("In order to send push notifications to simulators, you need macOS and XCode versions to be at least 11.4")
						
					End if 
					
				End if 
				
				
			: ($mailAndDeviceToken.target="android")
				
				$Obj_buildNotification:=buildAndroidNotification($Obj_notification)
				
				var $message : Object
				
				
				// only send "data" not "notification" to be handled in background because :
				// - "notification" has specific keys and notification display is handled by fcm and os
				// - "data" is fully handled by app
				
				$message:=New object:C1471(\
					"to"; $mailAndDeviceToken.deviceToken; \
					"data"; $Obj_buildNotification)
				
				$notificationInput:=New object:C1471(\
					"serverKey"; $Obj_auth.serverKey; \
					"message"; JSON Stringify:C1217($message))
				
				$status:=android_sendNotification($notificationInput)
				
			Else 
				
				$Obj_result.warnings.push("Missing target os for :\n ["+String:C10($mailAndDeviceToken.email)+" ; "+String:C10($mailAndDeviceToken.deviceToken)+"]")
				
		End case 
		
		
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
