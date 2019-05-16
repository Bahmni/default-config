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
    'PP_Key_population' : function (formName, formFieldValues) {
        var dia = formFieldValues['PP_Key_population'];
        if (dia ==  "PP_Key_population_Yes") {
            return {
                show: ["PP_If_Key_population_yes"]
            }
        } else {
            return {
                hide: ["PP_If_Key_population_yes"]
            }
        }
     },
     'PP_Vulnerable_Population' : function (formName, formFieldValues) {
        var dia = formFieldValues['PP_Vulnerable_Population'];
        if (dia ==  "PP_Vulnerable_Population_Yes") {
            return {
                show: ["PP_IF_Vulnerable_Population_Yes"]
            }
        } else {
            return {
                hide: ["PP_IF_Vulnerable_Population_Yes"]
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
    }
};