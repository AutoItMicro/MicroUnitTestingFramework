;License:
;	This script is distributed under the MIT License
;
;Author:
;	oscar.tejera
;
;Description:
; Simple test module
;Function: _test_
;Test object
;
;Parameters:
;	$sTestName - String Test name
;
;Returns:
;	Test object

Global $aResult[2]
$aResult[0] = "fail"
$aResult[1] = "pass"

Global $sHTMLTemplate = "/lib/report.html"

;Initializes
_AutoItObject_Startup()

Func _test_($sTestName)
	Local $oClassObject = _AutoItObject_Class()
	Local $dicSteps = ObjCreate("Scripting.Dictionary")
	$oClassObject.Create()

	;Methods
	With $oClassObject
		.AddMethod("step","_addStepResult")
		.AddMethod("removeSteps","_removeSteps")
		.AddMethod("getStep","_getLastStep")
		.AddMethod("countSteps","_countSteps")
		.AddMethod("addToSuite","_addToSuite")
		.AddMethod("saveResult","_saveResult")
		.AddMethod("assertEquals","_assertEquals")
		.AddMethod("assertNotEquals","_assertNotEquals")
		.AddMethod("assertFalse","_assertFalse")
		.AddMethod("assertTrue","_assertTrue")
		.AddMethod("assertType","_assertType")
		.AddMethod("assertLessThan","_assertLessThan")
		.AddMethod("assertLessThanOrEqual","_assertLessThanOrEqual")
		.AddMethod("assertGreaterThanOrEqual","_assertGreaterThanOrEqual")
		.AddMethod("assertGreaterThan","_assertGreaterThan")
		.AddMethod("assertFileExists","_assertFileExists")
		.AddMethod("assertFileNotExists","_assertFileNotExists")
		.AddMethod("assertFileEquals","_assertFileEquals")
	EndWith

	;Property
	With $oClassObject
		.AddProperty("_type_", $ELSCOPE_PUBLIC, "_test_") ;Object type
		.AddProperty("Name", $ELSCOPE_PUBLIC,$sTestName)
		.AddProperty("Steps", $ELSCOPE_PUBLIC, $dicSteps) ;Dictionary with test case steps
		.AddProperty("StepCount",$ELSCOPE_PRIVATE,0)
		.AddProperty("TestResult",$ELSCOPE_PRIVATE,1) ;0 Failed - 1 OK
        .AddProperty("TestResultText",$ELSCOPE_PRIVATE,"pass") ;0 Failed - 1 OK
		.AddProperty("TestStepFailed",$ELSCOPE_PRIVATE,0)
		.AddProperty("TestStepPassed",$ELSCOPE_PRIVATE,0)
		.AddProperty("TestStart",$ELSCOPE_PUBLIC,_NowCalc())
		.AddProperty("TestEnd",$ELSCOPE_PUBLIC,"")
		.AddProperty("Duration",$ELSCOPE_PUBLIC,"")
		.AddProperty("TestSuite",$ELSCOPE_PUBLIC,"") ;_testSuite_ object
	EndWith

	Return $oClassObject.Object
EndFunc

;Function: _addToSuite
; Add test case into the test suite and print the result.
;
;Parameters:
;	$objTestSuite - _testSuite_ objetc
;
;Returns:
;	void
Func _addToSuite($this,$objTestSuite)
	Local $sResult
	Local $iDuration
	Local $sReportFilePath

	$sResult = $aResult[$this.TestResult] ;Get the test result
	$this.TestEnd = _NowCalc()
	$this.Duration = _DateDiff('s', $this.TestStart, $this.TestEnd) ;Calculated the test duration

	;Add test case into the test suite
	If IsObj($objTestSuite) Then
		$this.TestSuite = $objTestSuite
		$this.TestSuite.addTest($this.name,$this.TestResult)
	EndIf

	_saveResult($this)
EndFunc

;Function: _saveResult
;
;
;Parameters:
;	$sMessage- String
;	$sReportFile - String
;
;Returns:
;	void
Func _saveResult($this)
	Local $sReportContent = ""
	Local $sTestDetail
	Local $hFile
	Local $sTestMark = '<div id="testcase" style="visibility:hidden"></div>'

	$sReportContent = FileRead($this.TestSuite.reportFilePath)

	;Add test result into Test suite report by format
	If($this.TestSuite.format = "html") Then
		$sTestDetail = _reportHTML($this) & $sTestMark
		$sReportContent = StringReplace($sReportContent,$sTestMark,$sTestDetail,0)
		$hFile = FileOpen($this.TestSuite.reportFilePath,2)
		FileWrite($hFile,$sReportContent)
		FileClose($hFile)

	Else ;txt format
		$hFile = FileOpen($this.TestSuite.reportFilePath,2)
		$sReportContent = $sReportContent & _reportTxt($this)
		FileWrite($hFile,$sReportContent)
		FileClose($hFile)
	EndIf
EndFunc

;Function: _addStepResult
; Add setp result
;
;Parameters:
;	$sMessage- String
;	$sReportFile - String
;
;Returns:
;	void
Func _addStepResult($this,$sStepName,$iResult)
	$dicTemp = $this.Steps
	$this.StepCount = $this.StepCount + 1

    If $iResult = 0 Then
		$this.TestResult = 0
        $this.TestResultText = "fail"
		$this.TestStepFailed = $this.TestStepFailed + 1
	Else
		$this.TestStepPassed = $this.TestStepPassed + 1
	EndIf

	$dicTemp.Add($this.StepCount,[$sStepName,$iResult])
	$this.Steps = _CloneDict($dicTemp)
EndFunc

;Function: _removeSteps
;
;
;Returns:
;	void
Func _removeSteps($this)
	Local $dicTemp
	$dicTemp = $this.Steps
	$dicTemp.RemoveAll
	$this.StepCount = 0
EndFunc

;Function: _getLastStep
;
;
;Returns:
; int
Func _GetLastStep($this)
	Local $iTotal
	Local $dicTemp

	$dicTemp = $this.Steps
	if $dicTemp.Exists($this.StepCount) Then
		Return $dicTemp.item($this.StepCount)
	Else
		Return 0
    EndIf
EndFunc

;Function: _CountSteps
;
;
;Returns:
; int
Func _CountSteps($this)
	Return $this.StepCount
EndFunc

;Function: _CloneDict
;Clone dictionary
;
;Parameters:
;	$Dict = Scripting Dictioanry
;
;Return:
;	Scripting Dictionary
Func _CloneDict($Dict)
  Local $newDict
  $newDict = ObjCreate("Scripting.Dictionary")

  For $key in $Dict.Keys
    $newDict.Add($key, $Dict($key))
  Next
  $newDict.CompareMode = $Dict.CompareMode
  Return $newDict
EndFunc

; === Report format ===

;Function:
;
;
;Parameters:
;	$objTest - _test_ object
;
;Return:
;	String - Report with test case details


; === Assertions ===

;Function: _assertEquals
;	Asserts that two variables are equal.
;
;Parameters:
;	$expected - Variant
;	$actual - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertEquals($this,$expected, $actual)
	Local $sResult

	If ($expected = $actual) Then
		Return 1
	Else
		Return 0
	EndIf

EndFunc   ;==>_assertEquals

;Function: _assertNotEquals
;Asserts that two variables not are equal.
;
;Parameters:
;	$expected - Variant
;	$actual - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertNotEquals($this,$expected, $actual)
	Local $sResult

	If ($expected <> $actual) Then
		Return 1
	Else
		Return 0
	EndIf

EndFunc   ;==>_assertNotEquals

;Function: _assertFalse
;Asserts that a condition is false.
;
;Parameters:
;	$condition - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertFalse($this,$condition)

	If ($condition = False) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_assertFalse

;Function: _assertTrue
;Asserts that a condition is True.
;
;Parameters:
;	$condition - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertTrue($this,$condition)
	Local $sResult

	If ($condition = True) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_assertTrue

;Function: _assertType
; Asserts that a variable is of a given type.
;
;Parameters:
;	$condition - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertType($this,$expected, $actual)
	Select
		Case $expected = "string"
			If (IsString($actual) = True) Then
				Return 1
			Else
				Return 0
			EndIf
		Case $expected = "number"
			If (IsNumber($actual) = True) Then
				Return 1
			Else
				Return 0
			EndIf
		Case $expected = "int"
			If (IsInt($actual) = True) Then
				Return 1
			Else
				Return 0
			EndIf
		Case $expected = "float"
			If (IsFloat($actual) = True) Then
				Return 1
			Else
				Return 0
			EndIf
		Case $expected = "array"
			If (IsArray($actual) = True) Then
				Return 1
			Else
				Return 0
			EndIf
		Case Else
			Return 0
	EndSelect

EndFunc   ;==>_assertType

;Function: _assertLessThan
;Asserts that a value is smaller than another value.
;
;Parameters:
;	$expected - Variant
;	$actual - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertLessThan($this,$expected, $actual)

	If ($expected < $actual) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_assertLessThan

;Function: _assertLessThanOrEqual
;Asserts that a value is smaller than or equal to another value.
;
;Parameters:
;	$expected - Variant
;	$actual - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertLessThanOrEqual($this,$expected, $actual)

	If ($expected <= $actual) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_assertLessThanOrEqual

;Function: _assertGreaterThanOrEqual
;Asserts that a value is greater than or equal to another value.
;
;Parameters:
;	$expected - Variant
;	$actual - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertGreaterThanOrEqual($this,$expected, $actual)

	If ($expected >= $actual) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_assertGreaterThanOrEqual

;Function: _assertGreaterThan
;Asserts that a value is greater than another value.
;
;Parameters:
;	$expected - Variant
;	$actual - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertGreaterThan($this,$expected, $actual)

	If ($expected > $actual) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_assertGreaterThan

;Function: _assertFileExists
;Asserts that a file exists.
;
;Parameters:
;	$filename - String
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertFileExists($this,$filename)

	If (FileExists($filename) = 1) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_assertFileExists

;Function: _assertFileNotExists
;Asserts that a file does not exists.
;
;Parameters:
;	$filename - String
;
;Returns:
;	int, 1 if the expression evaluates to true, otherwise returns 0
Func _assertFileNotExists($this,$filename)

	If (FileExists($filename) = 1) Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_assertFileExists

;Function: _assertFileEquals
;Asserts that the contents of one file is equal to the contents of another file.
;
;Parameters:
;	$expected - Variant
;	$actual - Variant
;
;Returns:
;	int, 1 if the expression evaluates to true, return 2 if function FileReadToarray falied, otherwise returns 0
Func _assertFileEquals($this,$expected, $actual)
	Local $aRecordsOne
	Local $aRecordsTwo
	Local $sContentOne
	Local $sContentTwo

	If Not _FileReadToArray($expected, $aRecordsOne) Or _FileReadToArray($actual, $aRecordsTwo) Then
		Return 0
	Else
		$sContentOne = _ArrayToString($aRecordsOne)
		$sContentTwo = _ArrayToString($aRecordsTwo)
		If ($sContentOne = $sContentTwo) Then
			Return 1
		Else
			Return 0
		EndIf
	EndIf
EndFunc   ;==>_assertFileEquals