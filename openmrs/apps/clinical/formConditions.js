Bahmni.ConceptSet.FormConditions.rules = {
    'Diastolic Data': function(formName, formFieldValues) {
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
    "PP_Key_population" (formName, formFieldValues) {
        var dia = formFieldValues["PP_Key_population"];
        if (dia === "PP_Key_population_Yes") {
            return {
                show: ["PP_If_Key_population_yes"]
            }
        } else {
            return {
                hide: ["PP_If_Key_population_yes"]
            }
        }
    },
    "PP_Vulnerable_Population" (formName, formFieldValues) {
        var dia = formFieldValues["PP_Vulnerable_Population"];
        if (dia === "PP_Vulnerable_Population_Yes") {
            return {
                show: ["PP_IF_Vulnerable_Population_Yes"]
            }
        } else {
            return {
                hide: ["PP_IF_Vulnerable_Population_Yes"]
            }
        }
    },
    'Systolic Data': function(formName, formFieldValues) {
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
    "Reference_Other_Services" (formName, formFieldValues) {
        var value = formFieldValues["Reference_Other_Services"];
        
        if (value === "Reference_Other") {
            return {
                show: ["Reference_Other_Text"]
            }
        } else {
            return {
                hide: ["Reference_Other_Text"]
            }
        }
    },
    "Reference_Eligible" (formName, formFieldValues) {
        var value = formFieldValues["Reference_Eligible"];
        
        if (value) {
            return {
                show: ["Reference_GA","Reference_AF","Reference_CA","Reference_PU","Reference_FR","Reference_DT","Reference_DC","Reference_MDC_Other"]
            }
        } else {
            return {
                hide: ["Reference_GA","Reference_AF","Reference_CA","Reference_PU","Reference_FR","Reference_DT","Reference_DC","Reference_MDC_Other"]
            }
        }
    }
};