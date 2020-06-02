//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // output success object
C_OBJECT:C1216($1)  // input auth object
C_OBJECT:C1216($Obj_result)

$Obj_result:=New object:C1471("success";False:C215)

  // Parameters already verified in calling class


  // GENERATE JSON WEB TOKEN
  //________________________________________

C_OBJECT:C1216($settings;$key;$header;$payload;$status)
C_TEXT:C284($signature;$message)

$settings:=New object:C1471
$settings.type:="PEM"
$settings.pem:=$1.authKey.getText()


  // Get CryptoKey class reference

$key:=MobileAppServer .jwt.new($settings)

$header:=New object:C1471("alg";"ES256";"kid";$1.authKeyId)

  // Get current date and time avoiding timezone issues

C_TIME:C306($currentTime;$timeGMT)
C_DATE:C307($dateGMT)
$currentTime:=Current time:C178
$timeGMT:=Time:C179(Replace string:C233(Delete string:C232(String:C10(Current date:C33;ISO date GMT:K1:10;$currentTime);1;11);"Z";""))
$dateGMT:=Date:C102(Delete string:C232(String:C10(Current date:C33;ISO date GMT:K1:10;$currentTime);12;20)+"00:00:00")

  // Convert date and time in number of seconds

C_LONGINT:C283($iat)
$iat:=(($dateGMT-Add to date:C393(!00-00-00!;1970;1;1))*86400)+($timeGMT+0)
$payload:=New object:C1471("iss";$1.teamId;"iat";$iat)

  // Sign

$signature:=$key.sign($header;$payload;New object:C1471("hash";"HASH256";"algorithm";"ES256"))

  // Verify

$status:=$key.verify($signature;New object:C1471("hash";"HASH256"))

$Obj_result.success:=$status.success
$Obj_result.jwt:=$signature

$0:=$Obj_result