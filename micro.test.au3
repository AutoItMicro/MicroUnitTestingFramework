#include "micro.au3"

Func _test_($sTestName)
	$oClassObject = _AutoItObject_Class()
	$oClassObject.Create()
    $dicSteps = ObjCreate("Scripting.Dictionary")

	With $oClassObject
		.AddMethod("addStep","_addStep")
		.AddMethod("countSteps","_countSteps")
		.AddMethod("assertTrue","_assertTrue")
        .AddMethod("stepPassed","_stepPassed")
        .AddMethod("stepFailed","_stepFailed")
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
	EndWith

	Return $oClassObject.Object
EndFunc

Func _assertTrue($this, $assertText, $assertion)
	$this.addStep($assertText, $assertion)
EndFunc

Func _addStep($this,$stepText,$assertion)
	$this.StepCount = $this.StepCount + 1

    If $assertion Then
        $this.stepPassed()
    Else
        $this.testFailed()
	EndIf

	$this.Steps.Add($this.StepCount,[$stepText,$assertion])
EndFunc

Func _stepFailed($this)
    $this.pass = False
    $this.TestResult = "fail"
	$this.TestStepFailed = $this.TestStepFailed + 1
EndFunc

Func _stepPassed($this)
    $this.TestStepPassed = $this.TestStepPassed + 1
EndFunc

