//%attributes = {}
#DECLARE($sessionFolder : Object; $deviceToken : Text)->$result : Object

var $sessionFile : 4D:C1709.File
var $session : Object

// PARAMETERS
//________________________________________

ASSERT:C1129(Count parameters:C259>=2; "Missing parameter")

$result:=New object:C1471(\
"success"; False:C215; \
"session"; Null:C1517)

If (Bool:C1537($sessionFolder.isFolder) & Bool:C1537($sessionFolder.exists))
	
	// Each file corresponds to a session
	For each ($sessionFile; $sessionFolder.files())
		
		If ($sessionFile.extension="")
			
			$session:=JSON Parse:C1218($sessionFile.getText())
			
			If ($devicetoken=String:C10($session.device.token))
				
				$result.session:=$session
				
				$result.success:=True:C214
				
				return 
				
			End if 
			
			// Else : not a session file
			
		End if 
		
	End for each 
	
	// Else : parameter is not a folder or does not exist
	
End if 

