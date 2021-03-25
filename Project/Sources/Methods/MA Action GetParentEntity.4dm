//%attributes = {"invisible":true,"preemptive":"capable"}
  // Utility method to return the parent entity to apply action from `$1` context in `On Mobile App Action` database method.
C_OBJECT:C1216($1)  // Object containing `context.dataClass`, `context.entity.primaryKey`, `context.parent.primaryKey`, `context.parent.relationName` and `context.parent.dataClass` ie. same input as `On Mobile App Action`
C_OBJECT:C1216($0)  // Return the parent entity corresponding to the action.

C_OBJECT:C1216($Obj_parent_dataClass;$Obj_entity_in;$Obj_entity_out)

If (Value type:C1509($1.context)=Is object:K8:27)
	
	If (Value type:C1509($1.context.parent)=Is object:K8:27)
		
		If (Length:C16(String:C10($1.context.parent.dataClass))>0)  // & $1.context.parent.dataClass#Null (String(Null) is "null")
			
			$Obj_parent_dataClass:=ds:C1482[$1.context.parent.dataClass]
			
			If (Length:C16(String:C10($1.context.parent.primaryKey))>0)
				
				$Obj_entity_out:=QueryByPrimaryKey ($Obj_parent_dataClass;$1.context.parent)
				
			End if 
		End if 
	End if 
End if 

$0:=$Obj_entity_out