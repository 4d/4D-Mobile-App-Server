//%attributes = {"invisible":true,"shared":true}
C_OBJECT:C1216($0)
C_TEXT:C284($1)
SESSION INIT 
  //check if the parameter file exists
If (parameters.success)
	If (Position:C15(parameters.activation.path;$1)=2)
		$0:=Activate Sessions ($1)
	End if 
Else 
	WEB SEND TEXT:C677("Please contact administrator to unlock your session")
	$0.success:=False:C215
	$0.errors:=New collection:C1472("Configuration to active session is not available";parameters.statusText)
End if 
