#include "micro.au3"

Func _testSuite_($suiteName)
	Local $oClassObject = _AutoItObject_Class()
	Local $dicTest = ObjCreate("Scripting.Dictionary")
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
		.AddProperty("tests", $ELSCOPE_PUBLIC, $dicTest)
		.AddProperty("testsPassed", $ELSCOPE_PUBLIC, 0)
		.AddProperty("testsFailed", $ELSCOPE_PUBLIC, 0)
		.AddProperty("pass", $ELSCOPE_PUBLIC, True) ;0 Failed - 1 OK
		.AddProperty("result", $ELSCOPE_PUBLIC, "pass")
		.AddProperty("startTime", $ELSCOPE_PUBLIC, _NowCalc())
		.AddProperty("time", $ELSCOPE_PUBLIC, "")
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

    $this.tests.Add($this.testCount, $test.TestResult)
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
EndFunc   ;==>_Stop

