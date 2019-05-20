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
     'Conduct_Family_planning' : function (formName, formFieldValues) {
        var yes = formFieldValues['Conduct_Family_planning'];
        if (yes ==  "Conduct_Family_planning_Yes") {
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