var onBloodPressureChange = function (formName, formFieldValues) {
    var systolic = formFieldValues['Systolic Data'];
    var diastolic = formFieldValues['Diastolic Data'];
    if (systolic || diastolic) {
        return {
            enable: ["Posture"]
        }
    } else {
        return {
            disable: ["Posture"]
        }
    }
};
Bahmni.ConceptSet.FormConditions.rules = {
    'Diastolic Data': onBloodPressureChange,
    'Systolic Data': onBloodPressureChange,
    'Diabetes, Last A1C result known?': function (formName, formFieldValues) {
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