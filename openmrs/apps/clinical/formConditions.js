Bahmni.ConceptSet.FormConditions.rules = {
    'Blood Pressure' : function (formName, formFieldValues) {
        var bloodPressure = formFieldValues['Blood Pressure'];
        var regex = /\d/g;
        if (regex.test(bloodPressure)) {
            return {
                enable: ["Posture"]
            }
        } else {
            return {
                disable: ["Posture"]
            }
        }
    },
    'Diastolic Data' : function (formName, formFieldValues) {
        var diastolic = formFieldValues['Diastolic Data'];
        if (diastolic) {
            return {
                enable: ["Posture"]
            }
        } else {
            return {}
        }
    },
    'Systolic Data' : function (formName, formFieldValues) {
        var systolic = formFieldValues['Systolic Data'];
        if (systolic) {
            return {
                enable: ["Posture"]
            }
        } else {}
    }
};