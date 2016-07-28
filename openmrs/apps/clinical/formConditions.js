Bahmni.ConceptSet.FormConditions.rules = {
    'Diastolic Data' : function (formName, formFieldValues) {
        var systolic = formFieldValues['Systolic'];
        var diastolic = formFieldValues['Diastolic'];
        if (systolic || diastolic) {
            return {
                enable: ["Posture"]
            }
        } else {
            return {
                disable: ["Posture"]
            }
        }
    },
    'Systolic Data' : function (formName, formFieldValues) {
        var systolic = formFieldValues['Systolic'];
        var diastolic = formFieldValues['Diastolic'];
        if (systolic || diastolic) {
            return {
                enable: ["Posture"]
            }
        } else {
            return {
                disable: ["Posture"]
            }
        }
    },
    'Diabetes, Last A1C result known?' : function (formName, formFieldValues) {
        var a1c_known = formFieldValues['Diabetes, Last A1C result known?'];
        if (a1c_known) {
            return {
                enable: ["Diabetes, Last known A1C"]
            }
        } else {
            return {
                disable: ["Diabetes, Last known A1C"],
				error: "Please order A1C lab test if available"
            }
        }
    }
};