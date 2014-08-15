#include "micro.au3"

Func _testSuite_($suiteName)
	Local $oClassObject = _AutoItObject_Class()
	Local $dicTest = ObjCreate("Scripting.Dictionary")
	Local $hFile
	$oClassObject.Create()

	;Methods
	With $oClassObject
		.AddMethod("finish", "_finish")
		.AddMethod("addTest", "_AddTest")
		.AddMethod("testPassed","_testPassed")
        .AddMethod("testFailed","_testFailed")
	EndWith

	;Property
	With $oClassObject
		.AddProperty("_type_", $ELSCOPE_PUBLIC, "_testSuite_") ;Object type
		.AddProperty("name", $ELSCOPE_PUBLIC, $suiteName)
		.AddProperty("format", $ELSCOPE_PUBLIC, "html")
		.AddProperty("reportFilePath", $ELSCOPE_PUBLIC, $sReportFilePath)
		.AddProperty("reportFile", $ELSCOPE_PUBLIC, $hFile)
		.AddProperty("tests", $ELSCOPE_PUBLIC, $dicTest)
		.AddProperty("testsPassed", $ELSCOPE_PUBLIC, 0)
		.AddProperty("testsFailed", $ELSCOPE_PUBLIC, 0)
		.AddProperty("testCount", $ELSCOPE_PUBLIC, 0)
		.AddProperty("pass", $ELSCOPE_PUBLIC, True) ;0 Failed - 1 OK
		.AddProperty("result", $ELSCOPE_PUBLIC, "pass")
		.AddProperty("startTime", $ELSCOPE_PUBLIC, _NowCalc())
		.AddProperty("startTime", $ELSCOPE_PUBLIC, _NowCalc())
		.AddProperty("HtmlTemplate", $ELSCOPE_PUBLIC, "/micro/resources/report.html")
		.AddProperty("reportFilePath", $ELSCOPE_PUBLIC, @ScriptDir & "/report.html")
	EndWith

	Return $oClassObject.Object
EndFunc   ;==>_testSuite_

Func _addTest($this, $test)
	$this.testCount = $this.testCount + 1

    If $test.pass Then
		$this.testPassed()
	Else
		$this.testFailed()
	EndIf

    $this.tests.Add(($this.testCount, $test.TestResult)
EndFunc   ;==>_AddTest

Func _testPassed($this)
    $this.testsPassed = $this.testsPassed + 1
EndFunc

Func _testFailed($this)
    $this.pass = False
    $this.result = "fail"
    $this.testsFailed = $this.testsFailed + 1
EndFunc

Func _finish($this)
	$this.time = _DateDiff('s', $this.startTime, _NowCalc())

    If $this.pass Then
        Exit(0)
    Else
        Exit(1)
    EndIf
;~ 	If ($this.format = "html") Then
;~ 		$sReportContent = FileRead($this.reportFilePath)
;~ 		$sReportContent = StringReplace($sReportContent,'<($TestSuiteResult)>',$aResult[$this.resultText],0)
;~ 		$sReportContent = StringReplace($sReportContent,'<($Duration)>',$testDuration,0)
;~ 		$sReportContent = StringReplace($sReportContent,'<($TestCount)>',$this.testCount,0)
;~ 		$sReportContent = StringReplace($sReportContent,'<($TestFailed)>',$this.testsFailed,0)
;~ 		$sReportContent = StringReplace($sReportContent,'<($TestPassed)>',$this.testsPassed,0)
;~ 		$hFile = FileOpen($this.reportFilePath,2)
;~ 		FileWrite($hFile,$sReportContent)
;~ 		FileClose($hFile)
;~ 	Else
;~ 		FileWriteLine($this.reportFilePath, @CRLF & "=======================================")
;~ 		FileWriteLine($this.reportFilePath, "Test suite: " & $this.name & @CRLF)
;~ 		FileWriteLine($this.reportFilePath, "Global result: " & $aResult[$this.result] & @CRLF)
;~ 		FileWriteLine($this.reportFilePath, "Finished in: " & $iDuration & " seconds." & $this.testCount & " tests," & $this.testsFailed & " failures," & $this.testsPassed & " passed" & @CRLF)
;~ 		FileClose($this.reportFilePath)
;~ 	EndIf
EndFunc   ;==>_Stop





Func _testReportHtml($this, $test)
	Local $sTestDetail
	Local $hFile
	Local $testCaseDivTag = '<div id="testcase" style="visibility:hidden"></div>'

	$html = FileRead($this.TestSuite.reportFilePath)

	;Add test result into Test suite report by format

    $sTestDetail = _reportHTML($this) & $testCaseDivTag
    $html = StringReplace($html,$testCaseDivTag,$sTestDetail,0)
    $hFile = FileOpen($this.TestSuite.reportFilePath,2)
    FileWrite($hFile,$sReportContent)
    FileClose($hFile)


EndFunc

Func _testReportTxt($this, $test)
		$hFile = FileOpen($this.reportFilePath,2)
		$sReportContent = $sReportContent & _reportTxt($this)
		FileWrite($hFile,$sReportContent)
		FileClose($hFile)
    EndFunc

Func _reportHTML($objTest)
	 Local $sTestResult  = $aResult[$objTest.TestResult]
	 Local $htmlTestHeader = '<h2 class="'& $sTestResult &'">' & $objTest.Name & '<span class="result"><span class="green">'& $objTest.TestStepPassed &'</span>/<span class="red">' & $objTest.TestStepFailed &'</span></span></h2>' & @CRLF
	 Local $htmlStepHeader = '<ul class="tests">' & @CRLF
	 Local $htmlSteps = ""
	 Local $htmlReport  = ""

	;Get all steps in the test case
	For $iStep = 1 To $objTest.StepCount
		Local $dicTemp = $objTest.Steps
		local $aStep = $dicTemp.item($iStep)
		$htmlSteps = $htmlSteps & '<li><span class="type ' & $aResult[$aStep[1]] & '">'& $aStep[0]  &'</span><span class="file">Step '& $iStep &'</span></li>' & @CRLF
	Next

	$htmlReport = $htmlTestHeader & $htmlStepHeader & $htmlSteps & "</ul>" & @CRLF
	return $htmlReport
EndFunc

;Function:
;
;
;Parameters:
;	$objTest - _test_ object
;
;Return:
;	String - Report with test case details
Func _reportTxt($test)
	 Local $sTestResult  = $aResult[$objTest.TestResult]
	 Local $txtTestHeader = "------------------------------------" & @CRLF
	 $txtTestHeader = $txtTestHeader & 'Test Name: ' & $test.Name & @CRLF & 'Test Result: '& $test.testResultText & @CRLF
	 Local $txtSteps = ""
	 Local $txtReport  = ""

	;Get all steps in the test case
	For $iStep = 1 To $objTest.StepCount
		Local $dicTemp = $objTest.Steps
		local $aStep = $dicTemp.item($iStep)
		$txtSteps = $txtSteps & '==> Step: Result: ' & $aStep[0] & ' Result: ' & $aResult[$aStep[1]] & @CRLF
	Next

	$txtReport = $txtTestHeader & @CRLF & $txtSteps & @CRLF
	return $txtReport
EndFunc

;Function: _countTest
;Count the test cases in test set
;
;
;Returns:
; int
Func _countTests($this)
	Return $this.testCount
EndFunc   ;==>_CountTests
