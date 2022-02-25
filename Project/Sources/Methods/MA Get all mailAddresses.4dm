//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($sessionFolder : Object)->$result : Object

var $sessionFile : 4D:C1709.File
var $session : Object


// PARAMETERS
//________________________________________

ASSERT:C1129(Count parameters:C259>=1; "Missing parameter")

$result:=New object:C1471(\
"success"; False:C215; \
"mailAddresses"; New collection:C1472)

If (Bool:C1537($sessionFolder.isFolder) & Bool:C1537($sessionFolder.exists))
	
	// Each file corresponds to a session
	For each ($sessionFile; $sessionFolder.files())
		
		If ($sessionFile.extension="")
			
			$session:=JSON Parse:C1218($sessionFile.getText())
			
			If (Length:C16(String:C10($session.email))>0)
				
				$result.mailAddresses.push($session.email)
				
			End if 
			
			// Else : not a session file
			
		End if 
		
	End for each 
	
	// Else : parameter is not a folder or does not exist
	
End if 

If ($result.mailAddresses.length>0)
	
	$result.success:=True:C214
	$result.mailAddresses:=$result.mailAddresses.distinct()
	
End if 

