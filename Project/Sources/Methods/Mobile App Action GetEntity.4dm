//%attributes = {"invisible":true,"preemptive":"capable"}
  // Utility method to return the entity to apply action from `$1` context in `On Mobile App Action` database method.
C_OBJECT:C1216($1)  // Object containing `context.dataClass` and `context.entity.primaryKey` ie. same input as `On Mobile App Action`
C_OBJECT:C1216($0)  // Return the entity corresponding to the action.

C_OBJECT:C1216($Obj_request;$Obj_dataClass;$Obj_entity)

$Obj_request:=$1

$Obj_dataClass:=Mobile App Action GetDataClass ($Obj_request)

If ($Obj_dataClass#Null:C1517)
	
	If (Value type:C1509($Obj_request.context.entity)=Is object:K8:27)  // n.b. $Obj_request.context object already checked by previous method
		
		If (Length:C16(String:C10($Obj_request.context.entity.primaryKey))>0)
			
			$Obj_entity:=QueryByPrimaryKey ($Obj_dataClass;$Obj_request.context.entity)
			
		End if 
	End if 
End if 

$0:=$Obj_entity