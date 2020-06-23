//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($1;$file)
C_OBJECT:C1216($0;$object)

C_TEXT:C284($text;$errorMethod)

$file:=$1

If (Bool:C1537($file.exists))
	$text:=$file.getText()
	
	$errorMethod:=Method called on error:C704
	ON ERR CALL:C155("noError")
	If (Position:C15("{";$text)=1)
		
		$object:=JSON Parse:C1218($text)
		$object.file:=$file
		$object.save:=Formula:C1597(This:C1470.file.setText(JSON Stringify:C1217(This:C1470)))
		
	End if 
	
	ON ERR CALL:C155($errorMethod)
	
End if 


$0:=$object
