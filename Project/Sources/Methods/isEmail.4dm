//%attributes = {"invisible":true,"preemptive":"capable"}
C_BOOLEAN:C305($0)  // If input text is a mail address
C_TEXT:C284($1)  // Input text


If ($1=Null:C1517)
	ASSERT:C1129(False:C215;"Missing parameter")
End if 

C_TEXT:C284($motif)

$motif:="^([-a-zA-Z0-9_]+(?:\\.[-a-zA-Z0-9_]+)*)(?:@)([-a-zA-Z0-9\\_]+(?:\\.[a-zA-Z0-9]{2,})+)$"

$0:=Match regex:C1019($motif;$1;1)