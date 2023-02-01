//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // output recipients collection and warnings for failures
C_OBJECT:C1216($1)  // input object containing recipients collections
C_TEXT:C284($2)  // team ID
C_TEXT:C284($3)  // bundle ID
C_COLLECTION:C1488($4)  // targets os
C_COLLECTION:C1488($mails; $deviceTokens; $mailAndDeviceTokenCollection)
C_OBJECT:C1216($Obj_result; $session; $Obj_session)
C_TEXT:C284($mail; $target)

If (Asserted:C1132(Count parameters:C259>=3; "Missing parameter"))
	
	ASSERT:C1129(Value type:C1509($2)=Is text:K8:3; "Second parameter is team ID, a text is expected")
	ASSERT:C1129(Value type:C1509($3)=Is text:K8:3; "Third parameter is bundle ID, a text is expected")
	
End if 

$Obj_result:=New object:C1471("success"; False:C215)


// Build (mails + deviceTokens) collection
//________________________________________

$deviceTokens:=$1.deviceTokens.distinct()
$mails:=$1.mails


$Obj_result.recipients:=New collection:C1472
$Obj_result.warnings:=New collection:C1472

C_BOOLEAN:C305($isAndroid; $isIos)

$isAndroid:=Bool:C1537($4.lastIndexOf("android")#-1)
$isIos:=Bool:C1537($4.lastIndexOf("ios")#-1)

//$Obj_session:=MobileAppServer.Session.new($2+"."+$3)
$Obj_session:=MobileAppServer.Session.new($3)

If ($deviceTokens.length>0)
	
	C_TEXT:C284($dt)
	
	For each ($dt; $deviceTokens)
		
		$Obj_session:=$Obj_session.getSessionInfoFromDeviceToken($dt)
		
		If ($Obj_session.success)
			
			$target:=Lowercase:C14(String:C10($Obj_session.session.device.os))
			
			Case of 
					
				: ((($target="ios") & ($isIos)) | (($target="android") & ($isAndroid)))
					
					$Obj_result.recipients.push(New object:C1471(\
						"email"; String:C10($Obj_session.session.email); \
						"deviceToken"; $dt; \
						"target"; $target))
					
				: (($target="ios") & (Not:C34($isIos)))
					// error
					$Obj_result.warnings.push("Target iOS was not chosen, but the following device token belongs to an iOS device : "+$dt)
					
				: (($target="android") & (Not:C34($isAndroid)))
					// error
					$Obj_result.warnings.push("Target Android was not chosen, but the following device token belongs to an Android device : "+$dt)
					
				: ((Not:C34($target="ios")) & (Not:C34($target="android")))
					// no target for session
					$Obj_result.warnings.push("No os target found in session for the following device token: "+$dt)
					
			End case 
			
		Else   // No session found for current device token
			
			$Obj_result.warnings.push("No session file was found for the following device token: "+$dt)
			
		End if 
		
	End for each 
	
	// Else : no deviceTokens given in entry
	
End if 


// GET SESSION INFO
//________________________________________

If ($mails.length>0)
	
	For each ($mail; $mails)
		
		$Obj_session:=$Obj_session.getSessionInfoFromMail($mail)
		
		If ($Obj_session.success)
			
			C_BOOLEAN:C305($atLeastOneFound)
			$atLeastOneFound:=False:C215
			
			For each ($session; $Obj_session.sessions)
				
				If (Length:C16(String:C10($session.device.token))>0)
					
					If ($deviceTokens.indexOf($session.device.token)<0)  // avoiding doubles
						
						$target:=Lowercase:C14(String:C10($session.device.os))
						
						Case of 
								
							: ((($target="ios") & ($isIos)) | (($target="android") & ($isAndroid)))
								
								$deviceTokens.push($session.device.token)  // avoiding doubles
								
								$Obj_result.recipients.push(New object:C1471(\
									"email"; $mail; \
									"deviceToken"; $session.device.token; \
									"target"; $target))
								
								$atLeastOneFound:=True:C214
								
							: (($target="ios") & (Not:C34($isIos)))
								// error
								$Obj_result.warnings.push("Target iOS was not chosen, but the following device token belongs to an iOS device : "+$dt)
								
							: (($target="android") & (Not:C34($isAndroid)))
								// error
								$Obj_result.warnings.push("Target Android was not chosen, but the following device token belongs to an Android device : "+$dt)
								
							: ((Not:C34($target="ios")) & (Not:C34($target="android")))
								// no target for session
								$Obj_result.warnings.push("No os target found in session for the following device token: "+$dt)
								
						End case 
						
					End if 
					
				End if 
				
			End for each 
			
			If (Not:C34($atLeastOneFound))
				
				$Obj_result.warnings.push("We couldn't find related deviceTokens to the following mail address : "+$mail)
				
			End if 
			
		Else   // No session found for current mail address 
			
			$Obj_result.warnings.push("No session file was found for the following mail address : "+$mail)
			
		End if 
		
	End for each 
	
	// Else : no mail given in entry
	
End if 

$0:=$Obj_result