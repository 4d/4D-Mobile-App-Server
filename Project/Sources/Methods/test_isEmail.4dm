//%attributes = {}
C_COLLECTION:C1488($input_Col)
C_TEXT:C284($email)

  // List of Valid Email Addresses

$input_Col:=New collection:C1472(\
"EMAIL@example.com";\
"email@example.com";\
"firstname.lastname@example.com";\
"email@subdomain.example.com";\
"email@123.123.123.123";\
"1234567890@example.com";\
"email@example-one.com";\
"_______@example.com";\
"email@example.name";\
"email@example.museum";\
"email@example.co.jp";\
"firstname-lastname@example.com")


For each ($email;$input_Col)
	
	ASSERT:C1129(isEmail ($email);"Invalid mail address : "+$email)
	
End for each 


  // List of Invalid Email Addresses

$input_Col:=New collection:C1472(\
"";\
"plainaddress";\
"\n#@%^%#$@#$@#.com";\
"@example.com";\
"@@text.com";\
"ee@test..com";\
"Joe Smith <email@example.com>";\
"\"email\"@example.com";\
"email@example";\
"email@example@example.com";\
".email@example.com";\
"email.@example.com";\
"email..email@example.com";\
"あいうえお@example.com";\
"email@example.com (Joe Smith)";\
"Abc..123@example.com";\
"”(),:;<>[\\]@example.com";\
"just”not”right@example.com";\
"\nthis\\ is\"really\"not\\allowed@example.com";\
"very.”(),:;<>[]”.VERY.”very@\\ \"very”.unusual@strange.example.com";\
"very.unusual.”@”.unusual.com@example.com";\
"much.”more\\ unusual”@example.com";\
"email@[123.123.123.123]";\
"firstname+lastname@example.com")


For each ($email;$input_Col)
	
	ASSERT:C1129(Not:C34(isEmail ($email));"Valid mail address : "+$email)
	
End for each 
