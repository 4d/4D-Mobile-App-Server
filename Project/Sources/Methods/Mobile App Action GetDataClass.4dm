//%attributes = {"invisible":true,"preemptive":"capable"}
  // Utility method to return the dataClass to apply action from `$1` context in `On Mobile App Action` database method.
C_OBJECT:C1216($1)  // Object containing `context.dataClass` ie. same input as `On Mobile App Action`
C_OBJECT:C1216($0)  // Return the dataClass corresponding to the action.

If (Value type:C1509($1.context)=Is object:K8:27)
	
	If (Length:C16(String:C10($1.context.dataClass))>0)  // & $1.context.dataClass#Null (String(Null) is "null")
		
		$0:=ds:C1482[$1.context.dataClass]
		
	End if 
End if 