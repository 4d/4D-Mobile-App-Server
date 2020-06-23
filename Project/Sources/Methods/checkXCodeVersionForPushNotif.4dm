//%attributes = {"invisible":true,"preemptive":"capable"}
C_BOOLEAN:C305($0)  // output success object
C_OBJECT:C1216($xcode)
C_COLLECTION:C1488($Col_version)

$xcode:=getXCodeVersion 

$0:=False:C215

If ($xcode.success)
	
	$Col_version:=Split string:C1554($xcode.version;".")
	
	  // Checking that XCode version is at least 11.4
	
	$0:=((($Col_version[0]="11") & ($Col_version[1]>"3")) | ($Col_version[0]>"11"))
	
	
End if 