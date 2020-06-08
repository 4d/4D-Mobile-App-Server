//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_OBJECT:C1216($Obj_result)
C_LONGINT:C283($Lon_parameters;$position)
C_TEXT:C284($pattern)

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Obj_result:=New object:C1471
	$Obj_result.success:=False:C215
	
Else 
	
	ABORT:C156
	
End if 


$pattern:="AuthKey_"

$position:=Position:C15($pattern;$1)

If ($position>0)
	
	$Obj_result.authKeyId:=Replace string:C233($1;$pattern;"")
	
	$Obj_result.success:=True:C214
	
End if 

$0:=$Obj_result