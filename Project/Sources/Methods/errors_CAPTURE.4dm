//%attributes = {"invisible":true,"preemptive":"capable"}
ARRAY LONGINT:C221($codes;0)
ARRAY TEXT:C222($components;0)
ARRAY TEXT:C222($desc;0)

lastError:=New object:C1471(\
"error";ERROR;\
"method";ERROR METHOD;\
"line";ERROR LINE;\
"formula";ERROR FORMULA;\
"stack";New collection:C1472)

GET LAST ERROR STACK:C1015($codes;$components;$desc)
ARRAY TO COLLECTION:C1563(lastError.stack;$codes;"code";$components;"component";$desc;"desc")