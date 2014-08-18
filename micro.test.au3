Func _test_($sTestName)
	$oClassObject = _AutoItObject_Class()
	$oClassObject.Create()
    $dicSteps = ObjCreate("Scripting.Dictionary")

	With $oClassObject
		.AddMethod("addStep","addStep")
		.AddMethod("countSteps","countSteps")
		.AddMethod("assertTrue","assertTrue")
        .AddMethod("stepPassed","stepPassed")
        .AddMethod("stepFailed","stepFailed")
        .AddMethod("duration","duration")
	EndWith

	;Property
	With $oClassObject
		.AddProperty("_type_", $ELSCOPE_PUBLIC, "_test_") ;Object type
		.AddProperty("Name", $ELSCOPE_PUBLIC,$sTestName)
		.AddProperty("Steps", $ELSCOPE_PUBLIC, $dicSteps) ;Dictionary with test case steps
		.AddProperty("StepCount",$ELSCOPE_PRIVATE,0)
		.AddProperty("pass",$ELSCOPE_PUBLIC,True)
        .AddProperty("TestResult",$ELSCOPE_PUBLIC,"pass") ;0 Failed - 1 OK
		.AddProperty("TestStepsFailed",$ELSCOPE_PUBLIC,0)
		.AddProperty("TestStepsPassed",$ELSCOPE_PUBLIC,0)
        .AddProperty("beginTime",$ELSCOPE_PRIVATE,_NowCalc())
        .AddProperty("endTime",$ELSCOPE_PRIVATE,_NowCalc())
	EndWith

	Return $oClassObject.Object
EndFunc

Func assertTrue($this, $assertText, $assertion)
	$this.addStep($assertText, $assertion)
    $this.endTime = _NowCalc()
EndFunc

Func addStep($this,$stepText,$assertion)
	Local $step[2] = [$stepText,$assertion]
    $this.StepCount = $this.StepCount + 1
    $this.Steps.Add($this.StepCount, $step)

    If $assertion Then
        $this.stepPassed()
    Else
        $this.testFailed()
	EndIf
EndFunc

Func stepFailed($this)
    $this.pass = False
    $this.TestResult = "fail"
	$this.TestStepFailed = $this.TestStepFailed + 1
EndFunc

Func stepPassed($this)
    $this.TestStepPassed = $this.TestStepPassed + 1
EndFunc

Func duration($this)
    Return $this.endTime - $this.beginTime
EndFunc

