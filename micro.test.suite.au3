Func newTestSuite($suiteName)
	Local $oClassObject = _AutoItObject_Class()
	$oClassObject.Create()

    Local $dicTest = ObjCreate("Scripting.Dictionary")

	With $oClassObject
		.AddMethod("finish", "finish")
		.AddMethod("addTest", "AddTest")
		.AddMethod("testPassed","testPassed")
        .AddMethod("testFailed","testFailed")
        .AddMethod("reportTest","reportTest")
        .AddMethod("duration","suiteDuration")
	EndWith

	With $oClassObject
		.AddProperty("_type_", $ELSCOPE_PUBLIC, "TestSuite") ;Object type
		.AddProperty("name", $ELSCOPE_PUBLIC, $suiteName)
		.AddProperty("ci", $ELSCOPE_PUBLIC, False)
		.AddProperty("format", $ELSCOPE_PUBLIC, "html")
		.AddProperty("tests", $ELSCOPE_PUBLIC, $dicTest)
		.AddProperty("testCount", $ELSCOPE_PUBLIC, 0)
		.AddProperty("testsPassed", $ELSCOPE_PUBLIC, 0)
		.AddProperty("testsFailed", $ELSCOPE_PUBLIC, 0)
		.AddProperty("pass", $ELSCOPE_PUBLIC, True) ;0 Failed - 1 OK
		.AddProperty("result", $ELSCOPE_PUBLIC, "Passed")
		.AddProperty("beginTime", $ELSCOPE_PUBLIC, _NowCalc())
		.AddProperty("endTime", $ELSCOPE_PUBLIC, _NowCalc())
		.AddProperty("failFast", $ELSCOPE_PUBLIC, False)
	EndWith

	Return $oClassObject.Object
EndFunc

Func addTest($this, $test)
	$this.testCount = $this.testCount + 1

    If $test.pass Then
		$this.testPassed()
	Else
		$this.testFailed()
	EndIf

    $this.reportTest($test)
    $this.tests.Add($this.testCount, $test.TestResult)
EndFunc

Func testPassed($this)
    $this.testsPassed = $this.testsPassed + 1
EndFunc

Func testFailed($this)
    $this.pass = False
    $this.result = "Failed"
    $this.testsFailed = $this.testsFailed + 1
    If $this.failFast Then
        Exit 1
    EndIf
EndFunc

Func finish($this)
	$this.endTime = _NowCalc()
    ConsoleWrite(@CRLF & @CRLF)
    If $this.pass Then
        Exit 0
    Else
        Exit 1
    EndIf
EndFunc

Func suiteDuration($this)
    Return $this.endTime - $this.beginTime
EndFunc

Func _colorTagFor($boolean)
    If $boolean Then
        Return "+"
    Else
        Return "!"
    EndIf
EndFunc

Func reportTest($this, $test)
    If $this.ci Then
        appveyorAddTest($test.name, $test.testResult, $test.duration())
    Else
        ConsoleWrite(@CRLF & _colorTagFor($test.pass) & "(" & $this.testCount & ") " & $test.name & @CRLF)
        ConsoleWrite($test.steps & @CRLF)
        For $step In $test.steps
            If $test.steps.Item($step)[1] Then
                ConsoleWrite(_colorTagFor($test.steps.Item($step)[1]) & @TAB & "PASS" & @TAB & $test.steps.Item($step)[0] & @CRLF)
            Else
                ConsoleWrite(_colorTagFor($test.steps.Item($step)[1]) & @TAB & "FAIL" & @TAB & $test.steps.Item($step)[0] & @CRLF)
            EndIf
        Next
    EndIf
EndFunc
