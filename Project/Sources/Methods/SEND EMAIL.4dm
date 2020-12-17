//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($htmlContent;$Txt_methodOnErrorCall;$value)
C_OBJECT:C1216($0;$1;$2;$request;$status;$template;$o;$transporter;$result;$response;$session)
C_LONGINT:C283($minutes)
stringError:=""
$request:=$1
$response:=$2
  //get the path to the html email confirmation template
$template:=Folder:C1567(fk resources folder:K87:11;*).folder("4D Mobile App Server").file(parameters.template.emailToSend)
  //check if the file exists
If (Asserted:C1132($template.exists;"Missing file "+$template.platformPath))
	  //method to send email
	$o:=New object:C1471
	$o.smtp:=New object:C1471
	$o.smtp.host:=parameters.smtp.host
	$o.smtp.acceptUnsecureConnection:=False:C215
	$o.smtp.port:=Choose:C955($o.smtp.acceptUnsecureConnection;465;587)
	$o.smtp.user:=parameters.smtp.user
	$o.smtp.password:=parameters.smtp.password
	$o.smtp.keepAlive:=True:C214
	$o.smtp.connectionTimeOut:=30
	$o.smtp.sendTimeOut:=100
	
	$o.mail:=New object:C1471
	$o.mail.from:=parameters.smtp.from  //get "from" value from settings file
	$o.mail.to:=$request.email  //get "email" value from settings file
	$o.mail.subject:=parameters.emailSubject  //get "emailSubject" value from settings file
	$htmlContent:=$template.getText()
	  //create server address for session activation
	  //scheme: http or https
	  // hostname: 172.0.0.1
	  // port: 80
	  // path: activation
	  // session.id: ID de la session
	  // otherParameters: More parameters
	$value:=parameters.activation.scheme+"://"+parameters.activation.hostname+":"+parameters.activation.port+"/"+parameters.activation.path+"?token="+$request.session.id+"&"+parameters.activation.otherParameters
	$htmlContent:=Replace string:C233($htmlContent;"{{url}}";$value)
	  //convert milliseconde to Minute 
	$minutes:=(parameters.timeout/60000)
	  //display the timeout value in the email
	$htmlContent:=Replace string:C233($htmlContent;"{{expirationminutes}}";String:C10($minutes))
	$o.mail.htmlBody:=$htmlContent
	$transporter:=SMTP New transporter:C1608($o.smtp)
	$Txt_methodOnErrorCall:=Method called on error:C704
	ON ERR CALL:C155("GET ERROR INFO")
	$status:=$transporter.send($o.mail)
	ON ERR CALL:C155($Txt_methodOnErrorCall)
	  //check if the email is sent
	If ($status.success)
		  //get user session
		$session:=Storage:C1525.pendingSessions[$request.session.id]
		Use (Storage:C1525.pendingSessions)
			If ($session#Null:C1517)
				  //update the timestamp if we send a new email after the expiration of the 1st connection
				$session.time:=Milliseconds:C459
			Else 
				  //add new session
				Storage:C1525.pendingSessions[$request.session.id]:=New shared object:C1526(\
					"team";$request.team.id;\
					"application";$request.application.id;\
					"time";Milliseconds:C459)
			End if 
		End use 
	End if 
	$result:=New object:C1471("status";$status.success;"statusText";$status.statusText;"error";stringError)
Else 
	$result:=New object:C1471("status";False:C215;"statusText";$template.platformPath+" is not found";"error";stringError)
End if 

If ($result.status)
	$response.statusText:=parameters.message.successConfirmationMailMessage
Else 
	$response.statusText:=$result.statusText
End if 

$response.emailInfo:=$result
$response.success:=$result.status