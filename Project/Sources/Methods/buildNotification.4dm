//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // Returned notification object
C_OBJECT:C1216($1)  // Input notification
C_OBJECT:C1216($notification;$alert)

C_BOOLEAN:C305($isAPN)

$isAPN:=True:C214


  // BUILD NOTIFICATION
  //________________________________________

$notification:=New object:C1471

If ($isAPN)
	
	  // Fill title
	
	If (Length:C16(String:C10($1.title))>0)  // Mandatory notification title
		
		$alert:=New object:C1471("title";$1.title)
		
	Else 
		
		$alert:=New object:C1471("title";"Empty title")
		
	End if 
	
	  // Fill subtitle
	
	If (Length:C16(String:C10($1.subtitle))>0)
		
		$alert.subtitle:=$1.subtitle
		
	End if 
	
	  // Fill body
	
	If (Length:C16(String:C10($1.body))>0)
		
		$alert.body:=$1.body
		
	End if 
	
	
	$notification.aps:=New object:C1471("alert";$alert)
	
	
	  // Fill badge
	
	If (Length:C16(String:C10($1.badge))>0)
		
		$notification.aps.badge:=$1.badge
		
	End if 
	
	  // Fill sound
	
	If (Length:C16(String:C10($1.sound))>0)
		
		$notification.aps.sound:=$1.sound
		
	End if 
	
	  // Fill mutable-content
	
	If (Length:C16(String:C10($1["mutable-content"]))>0)
		
		$notification.aps["mutable-content"]:=1
		
	End if 
	
	  // Fill category
	
	If (Length:C16(String:C10($1.category))>0)
		
		$notification.aps.category:=$1.category
		
	End if 
	
	  // Fill url
	
	If (Length:C16(String:C10($1.url))>0)
		
		$notification.aps.url:=$1.url
		
	End if 
	
	  // Fill data
	
	If (Length:C16(String:C10($1.imageUrl))>0)
		
		$notification.data:=New object:C1471("media-url";$1.imageUrl)
		$notification.aps["mutable-content"]:=1  // Allow rich notification display
		
	End if 
	
	
	  // Else : Android notification
	
End if 


$0:=$notification



