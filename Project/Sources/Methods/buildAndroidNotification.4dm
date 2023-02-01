//%attributes = {}
C_OBJECT:C1216($0)  // Returned notification object
C_OBJECT:C1216($1)  // Input notification
C_OBJECT:C1216($notification)

// BUILD ANDROID NOTIFICATION
//________________________________________

$notification:=New object:C1471

// Fill title

If (Length:C16(String:C10($1.title))>0)
	
	$notification.title:=$1.title
	
End if 

// Fill body

If (Length:C16(String:C10($1.body))>0)
	
	$notification.body:=$1.body
	
End if 

$notification.android_channel_id:="qmobile_channel_id"


// Fill sound

If (Length:C16(String:C10($1.sound))>0)
	// Supports "default" or the filename of a sound resource bundled in the app. Sound files must reside in /res/raw/.
	
	$notification.sound:=$1.sound
	
End if 

If (Length:C16(String:C10($1.color))>0)
	// The notification's icon color, expressed in #rrggbb format.
	
	$notification.color:=$1.color
	
End if 

If (Value type:C1509($1.userInfo)=Is object:K8:27)
	
	C_VARIANT:C1683($key)
	
	For each ($key; $1.userInfo)
		
		$notification[$key]:=$1.userInfo[$key]
		
	End for each 
	
End if 

If (Length:C16(String:C10($1.imageUrl))>0)
	
	$notification.imageUrl:=String:C10($1.imageUrl)
	
End if 

$0:=$notification
