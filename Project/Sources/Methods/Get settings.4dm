//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_OBJECT:C1216($template;$info;$file;$settingFolder)
C_TEXT:C284($Txt_methodOnErrorCall)
$settingFolder:=Folder:C1567(fk resources folder:K87:11;*).folder("4D Mobile App Server")
$template:=$settingfolder.file("settings.json")
If ($template.exists)
	$Txt_methodOnErrorCall:=Method called on error:C704
	ON ERR CALL:C155("GET ERROR INFO")
	$0:=JSON Parse:C1218($template.getText())
	ON ERR CALL:C155($Txt_methodOnErrorCall)
	If ($0.activation=Null:C1517)
		$0.activation:=New object:C1471
	End if 
	$info:=WEB Get server info:C1531()
	If ($0.activation.scheme=Null:C1517)
		$0.activation.scheme:=Choose:C955($info.security.HTTPSEnabled;"https";"http")
	End if 
	If ($0.activation.hostname=Null:C1517)
		$0.activation.hostname:=$info.options.webIPAddressToListen[0]
	End if 
	If ($0.activation.port=Null:C1517)
		$0.activation.port:=String:C10(Choose:C955($info.security.HTTPSEnabled;$info.options.webHTTPSPortID;$info.options.webPortID))
	End if 
	If ($0.activation.path=Null:C1517)
		$0.activation.path:="activation"
	End if 
	If ($0.activation.otherParameters=Null:C1517)
		$0.activation.otherParameters:=""
	End if 
	
	If ($0.emailSubject=Null:C1517)
		$0.emailSubject:="Application Name: Sign in confirmation"
	End if 
	If ($0.timeout=Null:C1517)
		$0.timeout:=300000
	End if 
	If ($0.message=Null:C1517)
		$0.message:=New object:C1471
	End if 
	If ($0.message.successConfirmationMailMessage=Null:C1517)
		$0.message.successConfirmationMailMessage:="Verify your email address"
	End if 
	If ($0.message.waitSendMailConfirmationMessage=Null:C1517)
		$0.message.waitSendMailConfirmationMessage:="The mail is already sent thank you to wait before sending again"
	End if 
	If ($0.message.successActiveSessionsMessage=Null:C1517)
		$0.message.successActiveSessionsMessage:="You are successfully authenticated"
	End if 
	If ($0.message.expireActiveSessionsMessage=Null:C1517)
		$0.message.expireActiveSessionsMessage:="This email confirmation link has expired!"
	End if 
	If ($0.template=Null:C1517)
		$0.template:=New object:C1471
	End if 
	If ($0.template.emailToSend=Null:C1517)
		$0.template.emailToSend:="ConfirmMailTemplate.html"
	End if 
	$file:=$settingFolder.file($0.template.emailToSend)
	If (Not:C34($file.exists))
		Folder:C1567(fk resources folder:K87:11).folder("Mail Authentication Verification").file("ConfirmMailTemplate.html").copyTo($settingFolder)
	End if 
	If ($0.template.emailConfirmActivation=Null:C1517)
		$0.template.emailConfirmActivation:="ActiveSessionTemplate.html"
	End if 
	$file:=$settingFolder.file($0.template.emailConfirmActivation)
	If (Not:C34($file.exists))
		Folder:C1567(fk resources folder:K87:11).folder("Mail Authentication Verification").file("ActiveSessionTemplate.html").copyTo($settingFolder)
	End if 
	
	$0.success:=True:C214
	
Else 
	
	$0:=New object:C1471("success";False:C215;"statusText";"Missing configuration files "+$template.platformPath)
	
	If (Not:C34($settingFolder.exists))
		$settingFolder.create()
	End if 
	
	$file:=$settingFolder.file("settings.sample.json")
	If (Not:C34($file.exists))
		Folder:C1567(fk resources folder:K87:11).folder("Mail Authentication Verification").file("settings.sample.json").copyTo($settingFolder)
	End if 
	
End if 