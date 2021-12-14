//%attributes = {"invisible":true}
  //create a share collection accessible from several processes
If (Storage:C1525.pendingSessions=Null:C1517)
	Use (Storage:C1525)
		Storage:C1525.pendingSessions:=New shared object:C1526
	End use 
End if 
  //create an object accessible from the current process
If (parameters=Null:C1517)
	parameters:=Get settings 
End if 