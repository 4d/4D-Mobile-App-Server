/*
Construct a jwt object.

MobileAppServer .jwt.new( settings ) -> jwt

settings.type: "RSA" or "ECDSA" to generate new keys. "PEM" to load an existing key from settings.pem
settings.size: size of RSA key to generate (2048 by default)
settings.curve: curve of ECDSA to generate ("prime256v1" for ES256 (default), "secp384r1" for ES384, "secp521r1" for ES512)
settings.pem: PEM definition of an encryption key to load
settings.secret: default password to use for HS@ algorithm
*/
Class constructor($settings : Object)
	
	If (Count parameters:C259()>0)
		
		This:C1470.secret:=String:C10($settings.secret)  // for HMAC
		This:C1470.key:=4D:C1709.CryptoKey.new($settings)  // load a pem or generate a new ECDSA/RSA key
		
	Else 
		
		This:C1470.secret:=""
		This:C1470.key:=Null:C1517
		
	End if 
	
/*
Builds a JSON Web token from its payload.
	
jwt.sign( payloadObject ; options) -> tokenString
	
options.algorithm: a JWT algorithm ES256, ES384, RS256, HS256, etc...
options.secret : password for HS@ algorithms
*/
Function sign($headerObj : Object; $payloadObj : Object; $options : Object) : Text
	
	var $signOptions : Object
	
	var $header; $payload; $signature; $hash : Text
	BASE64 ENCODE:C895(JSON Stringify:C1217($headerObj); $header; *)
	BASE64 ENCODE:C895(JSON Stringify:C1217($payloadObj); $payload; *)
	$signature:=""
	$hash:=This:C1470._hashFromAlgorithm($options.algorithm)
	
	Case of 
			
			//________________________________________
		: ($options.algorithm="ES@")\
			 | ($options.algorithm="RS@")\
			 | ($options.algorithm="PS@")
			
			// need a private key
			If (Asserted:C1132(This:C1470.key#Null:C1517))
				
				$signOptions:=New object:C1471(\
					"hash"; $hash; \
					"pss"; $options.algorithm="PS@"; \
					"encoding"; "Base64URL")
				$signature:=This:C1470.key.sign($header+"."+$payload; $signOptions)
				
			End if 
			
			//________________________________________
		: ($options.algorithm="HS@")
			
			C_TEXT:C284($secret)
			$secret:=Choose:C955($options.secret=Null:C1517; String:C10(This:C1470.secret); String:C10($options.secret))
			$signature:=This:C1470.HMAC($secret; $header+"."+$payload; $hash)
			
			//________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "unknown algorithm")
			
			//________________________________________
	End case 
	
	return $header+"."+$payload+"."+$signature
	
/*
Verify and decode a JSON Web token.
	
jwt.verify( tokenString ; options) -> status
	
options.secret : password for HS@ algorithms
	
status.success : true if token is valid
status.header: token header object
status.payload : token payload object
*/
Function verify($token : Text; $options : Object) : Object
	C_TEXT:C284($header; $payload; $signature; $hash; $alg; $verifiedSignature)
	C_TEXT:C284($headerDecoded; $payloadDecoded)
	C_LONGINT:C283($pos1; $pos2)
	C_OBJECT:C1216($headerObject; $payloadObject; $signOptions)
	C_BOOLEAN:C305($verified)
	
	
	$pos1:=Position:C15("."; $token; *)
	
	If ($pos1>0)
		
		$header:=Substring:C12($token; 1; $pos1-1)
		$pos2:=Position:C15("."; $token; $pos1+1; *)
		
		If ($pos2>0)
			
			$payload:=Substring:C12($token; $pos1+1; $pos2-$pos1-1)
			$signature:=Substring:C12($token; $pos2+1; Length:C16($token))
			
		End if 
	End if 
	
	BASE64 DECODE:C896($header; $headerDecoded; *)
	BASE64 DECODE:C896($payload; $payloadDecoded; *)
	
	$headerObject:=JSON Parse:C1218($headerDecoded)
	$payloadObject:=JSON Parse:C1218($payloadDecoded)
	
	If (Value type:C1509($headerObject)=Is object:K8:27)\
		 & (Value type:C1509($payloadObject)=Is object:K8:27)
		
		$alg:=String:C10($headerObject.alg)
		$hash:=This:C1470._hashFromAlgorithm($alg)
		
		Case of 
				
				//________________________________________
			: ($alg="HS@")  // HMAC
				
				C_TEXT:C284($secret)
				$secret:=Choose:C955($options.secret=Null:C1517; String:C10(This:C1470.secret); String:C10($options.secret))
				$verifiedSignature:=This:C1470.HMAC($secret; $header+"."+$payload; $hash)
				$verified:=(Length:C16($signature)=Length:C16($verifiedSignature)) & (Position:C15($signature; $verifiedSignature; *)=1)
				
				//________________________________________
			: ($alg="ES@")\
				 | ($alg="RS@")\
				 | ($alg="PS@")
				
				If (Asserted:C1132(This:C1470.key#Null:C1517))
					
					$signOptions:=New object:C1471(\
						"hash"; $hash; \
						"pss"; $alg="PS@"; \
						"encoding"; "Base64URL")
					$verified:=This:C1470.key.verify($header+"."+$payload; $signature; $signOptions).success
					
				End if 
				
				//________________________________________
		End case 
	End if 
	
	return New object:C1471(\
		"success"; $verified; \
		"header"; $headerObject; \
		"payload"; $payloadObject)
	
Function HMAC($keyData : Variant; $messageData : Variant; $algoName : Text)->$result : Text
	
	
	// accept blob or text for key and message
	C_BLOB:C604($key; $message)
	
	Case of 
			
			//________________________________________
		: (Value type:C1509($keyData)=Is text:K8:3)
			
			TEXT TO BLOB:C554($keyData; $key; UTF8 text without length:K22:17)
			
			//________________________________________
		: (Value type:C1509($keyData)=Is BLOB:K8:12)
			
			$key:=$keyData
			
			//________________________________________
	End case 
	
	Case of 
			
			//________________________________________
		: (Value type:C1509($messageData)=Is text:K8:3)
			
			TEXT TO BLOB:C554($messageData; $message; UTF8 text without length:K22:17)
			
			//________________________________________
		: (Value type:C1509($messageData)=Is BLOB:K8:12)
			
			$message:=$messageData
			
			//________________________________________
	End case 
	
	C_BLOB:C604($outerKey; $innerKey; $b)
	C_LONGINT:C283($blockSize; $i; $byte; $algo)
	
	Case of 
			
			//________________________________________
		: ($algoName="SHA1")
			
			$algo:=SHA1 digest:K66:2
			$blockSize:=64
			
			//________________________________________
		: ($algoName="SHA256")
			
			$algo:=SHA256 digest:K66:4
			$blockSize:=64
			
			//________________________________________
		: ($algoName="SHA512")
			
			$algo:=SHA512 digest:K66:5
			$blockSize:=128
			
			//________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "bad hash algo")
			
			//________________________________________
	End case 
	
	If (BLOB size:C605($key)>$blockSize)
		
		BASE64 DECODE:C896(Generate digest:C1147($key; $algo; *); $key; *)
		
	End if 
	
	If (BLOB size:C605($key)<$blockSize)
		
		SET BLOB SIZE:C606($key; $blockSize; 0)
		
	End if 
	
	ASSERT:C1129(BLOB size:C605($key)=$blockSize)
	
	SET BLOB SIZE:C606($outerKey; $blockSize)
	SET BLOB SIZE:C606($innerKey; $blockSize)
	
	//%r-
	For ($i; 0; $blockSize-1; 1)
		
		$byte:=$key{$i}
		$outerKey{$i}:=$byte ^| 0x005C
		$innerKey{$i}:=$byte ^| 0x0036
		
	End for 
	
	//%r+
	
	// append $message to $innerKey
	COPY BLOB:C558($message; $innerKey; 0; $blockSize; BLOB size:C605($message))
	BASE64 DECODE:C896(Generate digest:C1147($innerKey; $algo; *); $b; *)
	
	// append hash(innerKey + message) to outerKey
	COPY BLOB:C558($b; $outerKey; 0; $blockSize; BLOB size:C605($b))
	$result:=Generate digest:C1147($outerKey; $algo; *)
	
Function _hashFromAlgorithm($wanted : Text)->$algo : Text
	
	Case of 
			
			//________________________________________
		: ($wanted="@256")
			
			$algo:="SHA256"
			
			//________________________________________
		: ($wanted="@384")
			
			$algo:="SHA384"
			
			//________________________________________
		: ($wanted="@512")
			
			$algo:="SHA512"
			
			//________________________________________
	End case 