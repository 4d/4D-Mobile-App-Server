//%attributes = {"invisible":true}
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($i;$l)
C_TEXT:C284($t)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($aT_words;0)

If (False:C215)
	C_TEXT:C284(dev IndexName ;$0)
	C_TEXT:C284(dev IndexName ;$1)
End if 

/***********************************
Transform to lower camel case
************************************/

  // Replace, if any, the underscore with a blank character
$t:=Replace string:C233($1;"_";" ")

  // To detect camelCase notation,
  // extract words as is
$c:=New collection:C1472
COLLECTION TO ARRAY:C1562(Split string:C1554($t;"");$aT_words)

  // Put the initial string in lowercase
$t:=Lowercase:C14($t)
$l:=1

For ($i;2;Size of array:C274($aT_words);1)
	
	If (Character code:C91($aT_words{$i})#Character code:C91($t[[$i]]))  // Cesure
		
		$c.push(Substring:C12($t;$l;$i-$l))
		$l:=$i
		
	End if 
End for 

$c.push(Substring:C12($t;$l))

  // Make a separated words string
$t:=$c.join(" ")

  // Finally capitalize the first letter of the second word and the following ones
GET TEXT KEYWORDS:C1141($t;$aT_words)
$c:=New collection:C1472

For ($i;1;Size of array:C274($aT_words);1)
	
	$aT_words{$i}:=Lowercase:C14($aT_words{$i})
	
	If ($i>1)
		
		$aT_words{$i}[[1]]:=Uppercase:C13($aT_words{$i}[[1]])
		
	End if 
	
	$c.push($aT_words{$i})
	
End for 

  // Return the camelCase
$0:=$c.join()