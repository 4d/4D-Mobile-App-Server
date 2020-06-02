//%attributes = {}
  // RECIPIENTS
  //________________________________________

C_COLLECTION:C1488($deviceTokens;$mails;$simulators)
C_OBJECT:C1216($output_Object)

$deviceTokens:=New collection:C1472(\
"XXXXXf3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a";\
"YYYYYf3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a")

$mails:=New collection:C1472(\
"abc@gmail.com";\
"def@gmail.com";\
"ghi@gmail.com";\
"123@gmail.com")

$simulators:=New collection:C1472(\
"83548743-F30C-4F63-A495-BD352517A287";\
"9B667F83-F30C-4F63-A245-BE3525177287")


  // Testing case isObject

C_OBJECT:C1216($input_Object)

$input_Object:=New object:C1471
$input_Object.mails:=$mails
$input_Object.deviceTokens:=$deviceTokens
$input_Object.simulators:=$simulators
$output_Object:=manageEntryRecipient ($input_Object)
ASSERT:C1129($output_Object.deviceTokens.count()=($deviceTokens.count()+$simulators.count());"simulators collection was not merged into deviceTokens")


$input_Object:=New object:C1471
$input_Object.mails:=$mails
$input_Object.simulators:=New collection:C1472
$output_Object:=manageEntryRecipient ($input_Object)
ASSERT:C1129(Value type:C1509($output_Object.deviceTokens)=Is collection:K8:32;"deviceTokens collection was not created")
$input_Object.simulators:=$simulators
$output_Object:=manageEntryRecipient ($input_Object)
ASSERT:C1129($output_Object.deviceTokens.count()=$simulators.count();"simulators collection was not merged into deviceTokens")


  // Testing case isCollection

C_COLLECTION:C1488($input_Col)

$input_Col:=New collection:C1472
$input_Col.push("abc@gmail.com")
$input_Col.push("YYYYYf3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a")
$input_Col.push("8354843-F30C-4F63-A295-BE352517A287")
$output_Object:=manageEntryRecipient ($input_Col)
ASSERT:C1129(Value type:C1509($output_Object.mails)=Is collection:K8:32;"mails collection was not created")
ASSERT:C1129(Value type:C1509($output_Object.deviceTokens)=Is collection:K8:32;"deviceTokens collection was not created")
ASSERT:C1129($output_Object.mails.count()=1;"mail was not extracted")
ASSERT:C1129($output_Object.deviceTokens.count()=2;"deviceTokens and simulators were not merged together")


  // Testing case isText

C_TEXT:C284($input_Text)

$input_Text:="abc@gmail.com"
$output_Object:=manageEntryRecipient ($input_Text)
ASSERT:C1129(Value type:C1509($output_Object.mails)=Is collection:K8:32;"mails collection was not created")
ASSERT:C1129($output_Object.mails[0]=$input_Text;"mails are different")
ASSERT:C1129(Value type:C1509($output_Object.deviceTokens)#Is collection:K8:32;"deviceTokens collection should not be created")
