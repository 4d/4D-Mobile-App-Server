//%attributes = {"invisible":true}
C_OBJECT:C1216($Json_File;$Path_File_Session;$template;$session)
C_TEXT:C284($1;$bodyMessage;$htmlContent;$token)
C_BOOLEAN:C305($active)
ARRAY TEXT:C222($anames;0)
ARRAY TEXT:C222($avalues;0)
C_LONGINT:C283($lon_i)
stringError:=""
  //get the path to the html email activation template
$template:=Folder:C1567(fk resources folder:K87:11;*).folder("4D Mobile App Server").file(parameters.template.emailConfirmActivation)
$bodyMessage:="Please contact administrator to unlock your session"
  //check if the file exists
If ($template.exists)
	  //get token value from the url
	WEB GET VARIABLES:C683($anames;$avalues)
	For ($lon_i;1;Size of array:C274($anames))
		If ($anames{$lon_i}="token")
			$token:=$avalues{$lon_i}
		End if 
	End for 
	  //get user session
	$session:=Storage:C1525.pendingSessions[$token]
	  //check if the session exists
	If ($session#Null:C1517)
		  //compare the current timestamp with that when creating the session
		If ((Milliseconds:C459-$session.time)<parameters.timeout)
			  //if the difference is less than the value of the settings file: active the session
			  //get the session file
			$Path_File_Session:=Folder:C1567(fk mobileApps folder:K87:18;*).folder($session.team+"."+$session.application).file($token)
			If ($Path_File_Session.exists)
				$Json_File:=JSON Parse:C1218($Path_File_Session.getText())
				  //update status value
				$Json_File.status:="accepted"
				$Path_File_Session.setText(JSON Stringify:C1217($Json_File))
				Use (Storage:C1525.pendingSessions)
					  //delete session
					OB REMOVE:C1226(Storage:C1525.pendingSessions;$token)
				End use 
/*
The MOBILE APP REFRESH SESSIONS command checks all mobile application session files located in the MobileApps folder of the server, 
and updates existing session contents in memory for any edited files.
*/
				MOBILE APP REFRESH SESSIONS:C1596
				$bodyMessage:=parameters.message.successActiveSessionsMessage
				$active:=True:C214
			End if 
		Else 
			$bodyMessage:=parameters.message.expireActiveSessionsMessage
		End if 
	Else 
		$bodyMessage:=parameters.message.expireActiveSessionsMessage
	End if 
Else 
	stringError:="Missing file "+$template.platformPath
End if 
  //write the value of $bodyMessage in the web page
$htmlContent:=$template.getText()
$htmlContent:=Replace string:C233($htmlContent;"{{message}}";$bodyMessage)
WEB SEND TEXT:C677($htmlContent)

  //return the information in to the database method
$0:=New object:C1471("success";$active;"message";$bodyMessage;"error";stringError)