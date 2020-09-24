//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // output result

C_TEXT:C284($cmd;$cmd_in;$cmd_out;$cmd_err)
C_OBJECT:C1216($Obj_result;$Obj_buffer)
ARRAY LONGINT:C221($pos_found_array;0)
ARRAY LONGINT:C221($length_found_array;0)

$Obj_result:=New object:C1471("success";False:C215)

If (Not:C34(Is Windows:C1573))
	
	$cmd:="xcodebuild -version"
	
	LAUNCH EXTERNAL PROCESS:C811($cmd;$cmd_in;$cmd_out;$cmd_err)
	
	If (Asserted:C1132(OK=1;"LEP failed: "+$cmd))
		
		If (Length:C16($cmd_out)>0)
			
			C_TEXT:C284($pattern)
			
			$pattern:="(?s-mi)Xcode (\\d{1,}(?:\\.\\d)*).*version\\s*([A-Z0-9]*)"
			
			$Obj_result.success:=Match regex:C1019($pattern;$cmd_out;1;$pos_found_array;$length_found_array)
			
			If ($Obj_result.success)
				
				$Obj_result.version:=Substring:C12($cmd_out;$pos_found_array{1};$length_found_array{1})
				$Obj_result.build:=Substring:C12($cmd_out;$pos_found_array{2};$length_found_array{2})
				
			End if 
			
		Else 
			
			$Obj_result.error:=$cmd_err
			
		End if 
		
	End if 
	
End if 

$0:=$Obj_result