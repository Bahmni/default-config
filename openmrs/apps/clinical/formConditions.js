Bahmni.ConceptSet.FormConditions.rulesOverride = {
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
    var returnShowValues = [];
    var returnHideValues = [];

    if (dia === "Extrapulmonary (Sensitive/Resistant)") {

            returnShowValues.push("TB Type is Extrapulmonary");
            returnHideValues.push("TB Type is Extrapulmonary_Sensitive");

        } 
        else if (dia === "Extrapulmonary_Resistant_SP") {

            returnShowValues.push("TB Type is Extrapulmonary_Sensitive");
            returnHideValues.push("TB Type is Extrapulmonary");

        } else {
            
            returnHideValues.push("TB Type is Extrapulmonary");
            returnHideValues.push("TB Type is Extrapulmonary_Sensitive");

        }
    return {

            show: returnShowValues,
            hide: returnHideValues
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
"Conduct_Family_planning" (formName, formFieldValues) {
        var yes = formFieldValues["Conduct_Family_planning"];
        if (yes ===  "Conduct_Family_planning_Yes") {
            return {
                show: ["Conduct_Contraceptive_Methods_PRES_Condom_button","Conduct_Contraceptive_Methods_PIL_Oral_Contraceptive_button",
"Conduct_Contraceptive_Methods_INJ_Injection_button","Conduct_Contraceptive_Methods_IMP_Implant_button","Conduct_Contraceptive_Methods_DIU_Intra_button",
"Conduct_Contraceptive_Methods_Uterine_device_button","Conduct_Contraceptive_Methods_LT_Tubal_Ligation_button","Conduct_Contraceptive_Methods_VAS_Vasectomy_button",
"Conduct_Contraceptive_Methods_MAL_Lactational_Amenorrhea_Method_button","Conduct_Contraceptive_Methods_OUT_Other_button"]
            }
        } else {
            return {
                hide: ["Conduct_Contraceptive_Methods_PRES_Condom_button","Conduct_Contraceptive_Methods_PIL_Oral_Contraceptive_button",
"Conduct_Contraceptive_Methods_INJ_Injection_button","Conduct_Contraceptive_Methods_IMP_Implant_button","Conduct_Contraceptive_Methods_DIU_Intra_button",
"Conduct_Contraceptive_Methods_Uterine_device_button","Conduct_Contraceptive_Methods_LT_Tubal_Ligation_button","Conduct_Contraceptive_Methods_VAS_Vasectomy_button",
"Conduct_Contraceptive_Methods_MAL_Lactational_Amenorrhea_Method_button","Conduct_Contraceptive_Methods_OUT_Other_button"]
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
            };
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