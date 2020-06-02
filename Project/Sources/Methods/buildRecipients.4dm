//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // output recipients collection and warnings for failures
C_OBJECT:C1216($1)  // input object containing recipients collections
C_TEXT:C284($2)  // teamId
C_TEXT:C284($3)  // bundleId
C_COLLECTION:C1488($mails;$deviceTokens;$mailAndDeviceTokenCollection)
C_OBJECT:C1216($Obj_result;$session)

If (Asserted:C1132(Count parameters:C259>=3;"Missing parameter"))
	
	ASSERT:C1129(Value type:C1509($2)=Is text:K8:3;"Second parameter is TeamId, a text is expected")
	ASSERT:C1129(Value type:C1509($3)=Is text:K8:3;"Third parameter is BundleId, a text is expected")
	
Else 
	ABORT:C156
End if 

$Obj_result:=New object:C1471("success";False:C215)


  // Build (mails + deviceTokens) collection
  //________________________________________

$deviceTokens:=$1.deviceTokens
$mails:=$1.mails


$Obj_result.recipients:=New collection:C1472
$Obj_result.warnings:=New collection:C1472

If ($deviceTokens.length>0)
	
	C_TEXT:C284($dt)
	
	For each ($dt;$deviceTokens)
		
		  // For each deviceToken we build an object with mail address information to match session result collection
		
		$Obj_result.recipients.push(New object:C1471(\
			"email";"No mail address specified, raw deviceToken was given";\
			"deviceToken";$dt))
		
	End for each 
	
	  // Else : no deviceTokens given in entry
	
End if 


  // GET SESSION INFO
  //________________________________________

If ($mails.length>0)
	
	C_TEXT:C284($mail)
	C_OBJECT:C1216($Obj_session)
	
	For each ($mail;$mails)
		
		$Obj_session:=MobileAppServer .Session.new($2;$3)
		
		$Obj_session:=$Obj_session.getSessionInfoFromMail($mail)
		
		If ($Obj_session.success)
			
			C_BOOLEAN:C305($atLeastOneFound)
			$atLeastOneFound:=False:C215
			
			For each ($session;$Obj_session.sessions)
				
				If (Length:C16(String:C10($session.device.token))>0)
					
					$Obj_result.recipients.push(New object:C1471(\
						"email";$mail;\
						"deviceToken";$session.device.token))
					
					$atLeastOneFound:=True:C214
					
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