//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($data : Object)->$id : Text

If (($data.team=Null:C1517) || (Length:C16($data.team.id)=0))
	$id:=String:C10($data.application.id)
Else 
	$id:=String:C10($data.team.id)+"."+String:C10($data.application.id)
End if 