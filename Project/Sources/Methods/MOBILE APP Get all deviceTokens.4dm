//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // Returned object
C_OBJECT:C1216($1)  // Session folder

C_LONGINT:C283($session_indx)
C_OBJECT:C1216($Obj_result;$sessionFolder;$sessionFile;$session)
C_TEXT:C284($sessionFilePath)

ARRAY TEXT:C222($sessionFilesList;0)


  // PARAMETERS
  //________________________________________

If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	$Obj_result:=New object:C1471
	$Obj_result.success:=False:C215
	$Obj_result.deviceTokens:=New collection:C1472
	
Else 
	ABORT:C156
End if 

If (Bool:C1537($1.isFolder) & Bool:C1537($1.exists))
	
	$sessionFolder:=$1
	
	  // Each file corresponds to a session
	DOCUMENT LIST:C474($sessionFolder.platformPath;$sessionFilesList)
	
	For ($session_indx;1;Size of array:C274($sessionFilesList);1)
		
		$sessionFile:=$sessionFolder.file($sessionFilesList{$session_indx})
		
		$session:=JSON Parse:C1218($sessionFile.getText())
		
		If (Length:C16(String:C10($session.device.token))>0)
			
			$Obj_result.deviceTokens.push($session.device.token)
			
		End if 
		
	End for 
	
	  // Else : parameter is not a folder or does not exist
	
End if 

If ($Obj_result.deviceTokens.count()>0)
	
	$Obj_result.success:=True:C214
	$Obj_result.deviceTokens:=$Obj_result.deviceTokens.distinct()
	
End if 

$0:=$Obj_result
