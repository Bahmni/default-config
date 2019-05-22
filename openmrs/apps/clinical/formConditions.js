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
    var dia = formFieldValues['Received nutritional support'];

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
    var returnShowValue = new Array();
    var returnHideValue = new Array();
    if (dia && dia.length) {

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

    } else {

        return {
            hide: ["CTZ_Details", "INH_Details", "Fluconazol_Details"]

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