//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
C_OBJECT:C1216($1;$request;$response;$0;$session)
$request:=$1
$response:=New object:C1471



  //initialize shared variables
SESSION INIT 

  //check if the parameter file exists
If (parameters.success)
	  //get user session
	$session:=Storage:C1525.pendingSessions[$request.session.id]
	  //check if the session exists
	If ($session#Null:C1517)
		  //compare the current timestamp with that when creating the session
		If ((Milliseconds:C459-$session.time)<=parameters.timeout)
			  //if the difference is less than the value of the settings file: message to wait before sending an email again
			$response.statusText:=parameters.message.waitSendMailConfirmationMessage
		Else 
			  //the timeout value is exceeded and send a new email
			SEND EMAIL ($request;$response)
		End if 
	Else 
		  //send a confirmation email the 1st time
		SEND EMAIL ($request;$response)
	End if 
	
	  //put the session on pending
	$response.verify:=True:C214
Else 
	$response.success:=False:C215
	$response.statusText:="Authentication failed, please contact the administrator for further assistance"
	$response.errors:=New collection:C1472("Configuration to send validation email is not available";parameters.statusText)
End if 
$0:=$response