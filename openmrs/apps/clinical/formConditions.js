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
    "TB_Type" (formName, formFieldValues) {
    var dia = formFieldValues["TB_Type"];

    if (dia === "Extrapulmonary (Sensitive/Resistant)") {
        return {
            show: ["TB Type is Extrapulmonary"]
        }
    } else {
        return {
            hide: ["TB Type is Extrapulmonary"]
        }
    }
},
"Has TB Symptoms" (formName, formFieldValues) {
    var dia = formFieldValues["Has TB Symptoms"];

    if (dia === true) {
        return {

            show: ["Symptoms Prophylaxis_New"]
        }
    } else {
        return {
            hide: ["Symptoms Prophylaxis_New"]
        }
    }
},
"Has STI Symptoms" (formName, formFieldValues) {
    var dia = formFieldValues["Has STI Symptoms"];

    if (dia === true) {
        return {

            show: ["STI Diagnosis_Prophylaxis"]
        }
    } else {
        return {
            hide: ["STI Diagnosis_Prophylaxis"]
        }
    }
},
"Received nutritional support" (formName, formFieldValues) {
    var dia = formFieldValues["Received nutritional support"];

    if (dia === true) {
        return {

            show: ["Received nutritional education"]
        }
    } else {
        return {
            hide: ["Received nutritional education"]
        }
    }
},
"STI Diagnosis_Prophylaxis" (formName, formFieldValues) {
    var dia = formFieldValues["STI Diagnosis_Prophylaxis"];

    if (dia === "Syndromic Approach") {
        return {

            show: ["Syndromic Approach_STI"]
        }
    } else {
        return {
            hide: ["Syndromic Approach_STI"]
        }
    }
},
"Type_Prophylaxis" (formName, formFieldValues) {
    var dia = formFieldValues["Type_Prophylaxis"];
    var returnShowValue = [];
    var returnHideValue = [];
    

        if (dia.includes("INH")) {

            returnShowValue.push("INH_Details");

        } else {
            returnHideValue.push("INH_Details");

        }
        if (dia.includes("CTZ")) {

            returnShowValue.push("CTZ_Details");

        } else {
            returnHideValue.push("CTZ_Details");

        }
        if (dia.includes("Fluconazol")) {

            returnShowValue.push("Fluconazol_Details");

        } else {
            returnHideValue.push("Fluconazol_Details");

        }

        return {

            show: returnShowValue,
            hide: returnHideValue
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
            };
        }
    }
};