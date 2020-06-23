//%attributes = {"invisible":true,"preemptive":"capable"}
C_COLLECTION:C1488($1)  // Collection of warnings or errors
C_TEXT:C284($2)  // Alert title

C_TEXT:C284($concat;$issue)

$concat:=""

If ($1=Null:C1517)
	ASSERT:C1129(False:C215;"Missing collection")
End if 

If ($1.length>0)
	
	For each ($issue;$1)
		
		$concat:=$concat+$issue+"\n"
		
	End for each 
	
	If ($2#Null:C1517)
		
		$concat:=$2+" :\n"+$concat
		
	End if 
	
	ALERT:C41($concat)
	
End if 
