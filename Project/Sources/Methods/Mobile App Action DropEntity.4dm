//%attributes = {"invisible":true,"preemptive":"capable"}
  // Utility method to drop the entity from `$1` context in `On Mobile App Action` database method.
C_OBJECT:C1216($1)  // Object containing `context.dataClass` and `context.entity.primaryKey` ie. same input as `On Mobile App Action`
C_OBJECT:C1216($0)  // Return the status of drop

C_OBJECT:C1216($Obj_request;$Obj_result;$Obj_entity)

$Obj_request:=$1

$Obj_entity:=Mobile App Action GetEntity ($Obj_request)

If ($Obj_entity#Null:C1517)
	
	$Obj_result:=$Obj_entity.drop()
	
Else 
	
	$Obj_result:=New object:C1471("success";True:C214)  // choose to success if already dropped, for user experience
	
End if 

$0:=$Obj_result