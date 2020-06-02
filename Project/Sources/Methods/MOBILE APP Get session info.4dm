//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // Returned object
C_OBJECT:C1216($1)  // Session folder
C_TEXT:C284($2)  // input mail address

C_LONGINT:C283($session_indx)
C_OBJECT:C1216($Obj_result;$sessionFolder;$sessionFile;$session)
C_TEXT:C284($mail;$sessionFilePath)

ARRAY TEXT:C222($sessionFilesList;0)


  // PARAMETERS
  //________________________________________

If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	$mail:=$2
	
	$Obj_result:=New object:C1471
	$Obj_result.success:=False:C215
	$Obj_result.sessions:=New collection:C1472
	
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
		
		If ($mail=String:C10($session.email))
			
			$Obj_result.sessions.push($session)
			
		End if 
		
	End for 
	
	  // Else : parameter is not a folder or does not exist
	
End if 

If ($Obj_result.sessions.count()>0)
	
	$Obj_result.success:=True:C214
	
End if 

$0:=$Obj_result