//%attributes = {}
var $branch; $head; $major; $version : Text
var $success : Boolean
var $c : Collection
var $file : 4D:C1709.File

ARRAY LONGINT:C221($len; 0)
ARRAY LONGINT:C221($pos; 0)

$file:=File:C1566("/PACKAGE/.git/HEAD")

If ($file.exists)
	
	$head:=$file.getText()
	
	If (Match regex:C1019("(?m-si)ref: refs/heads/(.*)[[:space:]]"; $head; 1; $pos; $len))
		
		$branch:=Substring:C12($head; $pos{1}; $len{1})
		
		$c:=Split string:C1554(Application version:C493; "")
		$major:=$c[0]+$c[1]
		
		If (Application version:C493(*)="A@")
			
			$version:="DEV ("+$major+"R"+$c[2]+")"
			$success:=$branch="main"
			
		Else 
			
			$version:=$major+Choose:C955($c[2]="0"; ("."+$c[3]); ("R"+$c[2]))
			
			If ($c[2]#"0")
				
				$version:=$major+"R"+$c[2]
				$success:=($branch=($major+"RX")) | ($branch=($major+"R"+$c[2]))
				
			Else 
				
				$version:=$major+"."+$c[3]
				$success:=$branch=($major+".X")
				
			End if 
		End if 
		
		If (Not:C34($success))
			
			ALERT:C41("WARNING:\n\nYou are editing the \""+$branch+"\" branch of \""+$file.parent.parent.name+"\" with a "+$version+" version of 4D.")
			
		End if 
	End if 
End if 