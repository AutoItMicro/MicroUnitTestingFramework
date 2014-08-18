Func _testSuite_($suiteName)
	Local $oClassObject = _AutoItObject_Class()
	$oClassObject.Create()

    Local $dicTest = ObjCreate("Scripting.Dictionary")

	With $oClassObject
		.AddMethod("finish", "finish")
		.AddMethod("addTest", "AddTest")
		.AddMethod("testPassed","testPassed")
        .AddMethod("testFailed","testFailed")
        .AddMethod("duration","suiteDuration")
	EndWith

	With $oClassObject
		.AddProperty("_type_", $ELSCOPE_PUBLIC, "_testSuite_") ;Object type
		.AddProperty("name", $ELSCOPE_PUBLIC, $suiteName)
		.AddProperty("ci", $ELSCOPE_PUBLIC, False)
		.AddProperty("format", $ELSCOPE_PUBLIC, "html")
		.AddProperty("tests", $ELSCOPE_PUBLIC, $dicTest)
		.AddProperty("testsPassed", $ELSCOPE_PUBLIC, 0)
		.AddProperty("testsFailed", $ELSCOPE_PUBLIC, 0)
		.AddProperty("pass", $ELSCOPE_PUBLIC, True) ;0 Failed - 1 OK
		.AddProperty("result", $ELSCOPE_PUBLIC, "Passed")
		.AddProperty("beginTime", $ELSCOPE_PUBLIC, _NowCalc())
		.AddProperty("endTime", $ELSCOPE_PUBLIC, _NowCalc())
	EndWith

	Return $oClassObject.Object
EndFunc   ;==>_testSuite_

Func addTest($this, $test)
	$this.testCount = $this.testCount + 1

    If $test.pass Then
		$this.testPassed()
	Else
		$this.testFailed()
	EndIf

    appveyorAddTest($test.name, $test.testResult, $test.duration)
    $this.tests.Add($this.testCount, $test.TestResult)
EndFunc   ;==>_AddTest

Func testPassed($this)
    $this.testsPassed = $this.testsPassed + 1
EndFunc

Func testFailed($this)
    $this.pass = False
    $this.result = "Failed"
    $this.testsFailed = $this.testsFailed + 1
EndFunc

Func finish($this)
	$this.endTime = _NowCalc()

    If $this.pass Then
        ConsoleWrite("0" & @CRLF)
        Exit 0
    Else
        ConsoleWrite("1" & @CRLF)
        Exit 1
    EndIf
EndFunc   ;==>_Stop

Func suiteDuration($this)
    Return $this.endTime - $this.beginTime
EndFunc

