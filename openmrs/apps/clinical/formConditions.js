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
    
    if (dia === "INH") {

            returnShowValue.push("INH_Details");

        } else {
            returnHideValue.push("INH_Details");

        }
        if (dia === "CTZ") {

            returnShowValue.push("CTZ_Details");

        } else {
            returnHideValue.push("CTZ_Details");

        }
        if (dia ==="Fluconazol") {

            returnShowValue.push("Fluconazol_Details");

        } else {
            returnHideValue.push("Fluconazol_Details");

        }

        return {

            show: returnShowValue,
            hide: returnHideValue
        }

    
    
},
"Family_Planning_Methods" (formName, formFieldValues, patient) {
    
    if (patient.gender === "M") {
        return {
            show: ["Family_Planning_Contraceptive_Methods_PRES_Condom_button", "Family_Planning_Contraceptive_Methods_VAS_Vasectomy_button",
                "Family_Planning_Contraceptive_Methods_OUT_Other_button"],
            hide: ["Family_Planning_Contraceptive_Methods_INJ_Injection_button", "Family_Planning_Contraceptive_Methods_IMP_Implant_button",
                "Family_Planning_Contraceptive_Methods_DIU_Intra_button", "Family_Planning_Contraceptive_Methods_Uterine_device_button",
                "Family_Planning_Contraceptive_Methods_LT_Tubal_Ligation_button","Family_Planning_Contraceptive_Methods_PIL_Oral_Contraceptive_button", "Family_Planning_Contraceptive_Methods_MAL_Lactational_Amenorrhea_Method_button"]
        }
    }
    else {
        return {
            show: ["Family_Planning_Contraceptive_Methods_PIL_Oral_Contraceptive_button",
                "Family_Planning_Contraceptive_Methods_INJ_Injection_button", "Family_Planning_Contraceptive_Methods_IMP_Implant_button",
                "Family_Planning_Contraceptive_Methods_DIU_Intra_button", "Family_Planning_Contraceptive_Methods_Uterine_device_button",
                "Family_Planning_Contraceptive_Methods_LT_Tubal_Ligation_button", "Family_Planning_Contraceptive_Methods_MAL_Lactational_Amenorrhea_Method_button"],
            hide: ["Family_Planning_Contraceptive_Methods_VAS_Vasectomy_button"]
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
     "Apss_Pre_TARV_counselling" (formName, formFieldValues) {
        var yes = formFieldValues["Apss_Pre_TARV_counselling"];
        if (yes === "Apss_Pre_TARV_counselling_Yes") {
            return {
                show: ["Apss_Pre_TARV_counselling_comments"]
            }
        } else {
            return {
                hide: ["Apss_Pre_TARV_counselling_comments"]
            }
        }
    },
    "Apss_Psychosocial_factors_affecting_adherence" (formName, formFieldValues) {
        var yes = formFieldValues["Apss_Psychosocial_factors_affecting_adherence"];
        if (yes === "Apss_Psychosocial_factors_affecting_adherence_Yes") {
            return {
                show: ["Apss_Psychosocial_factors_Reasons"]
            }
        } else {
            return {
                hide: ["Apss_Psychosocial_factors_Reasons"]
            }
        }
    },
    "Apss_Adherence_follow_up_Has_informed_someone" (formName, formFieldValues) {
        var yes = formFieldValues["Apss_Adherence_follow_up_Has_informed_someone"];
        if (yes === "Apss_Adherence_follow_up_Has_informed_someone_Yes") {
            return {
                show: ["Apss_Adherence_follow_up_Has_informed_Full_Name","Apss_Adherence_follow_up_Has_informed_Relationship"]
            }
        } else {
            return {
                hide: ["Apss_Adherence_follow_up_Has_informed_Full_Name","Apss_Adherence_follow_up_Has_informed_Relationship"]
            }
        }
    },
    "Apss_Adherence_follow_up_Who_administers_ARV" (formName, formFieldValues) {
        var yes = formFieldValues["Apss_Adherence_follow_up_Who_administers_ARV"];
        if (yes === "Apss_Adherence_follow_up_Who_administers_ARV_Yes") {
            return {
                show: ["Apss_Adherence_follow_up_Who_administers_Full_Name","Apss_Adherence_follow_up_Who_administers_Relationship"]
            }
        } else {
            return {
                hide: ["Apss_Adherence_follow_up_Who_administers_Full_Name","Apss_Adherence_follow_up_Who_administers_Relationship"]
            }
        }
    },
    "Apss_Support_Groups_Other" (formName, formFieldValues) {
        var yes = formFieldValues["Apss_Support_Groups_Other"];
        if (yes === "Apss_Support_Groups_Start")   {
            return {
                show: ["Apss_Support_Groups_Specify_group"]
            }
        }  else if (yes === "Apss_Support_Groups_In_Progress") {

            return {
                show: ["Apss_Support_Groups_Specify_group"]
            }
        } 
         else if (yes === "Apss_Support_Groups_End") {

            return {
                show: ["Apss_Support_Groups_Specify_group"]
            }
        }
         else {
            return {
                hide: ["Apss_Support_Groups_Specify_group"]
            }
        }
    },
    "Apss_Differentiated_Models_Other" (formName, formFieldValues) {
        var yes = formFieldValues["Apss_Differentiated_Models_Other"];
        if (yes === "Apss_Differentiated_Models_Start")   {
            return {
                show: ["Apss_Differentiated_Models_Specify Model"]
            }
        }  else if (yes === "Apss_Differentiated_Models_In_Progress") {

            return {
                show: ["Apss_Differentiated_Models_Specify Model"]
            }
        } 
         else if (yes === "Apss_Differentiated_Models_End") {

            return {
                show: ["Apss_Differentiated_Models_Specify Model"]
            }
        }
         else {
            return {
                hide: ["Apss_Differentiated_Models_Specify Model"]
            }
        }
    },
    "Apss_Agreement_Terms_Patient_Caregiver_agrees_contacted" (formName, formFieldValues) {
        var yes = formFieldValues["Apss_Agreement_Terms_Patient_Caregiver_agrees_contacted"];
        if (yes === "Apss_Agreement_Terms_Patient_Caregiver_agrees_contacted_Yes")  {
            return {
                show: ["Apss_Agreement_Terms_Type_Contact"]
            }
        } else {
            return {
                hide: ["Apss_Agreement_Terms_Type_Contact"]
            }
        }
    },
    "Apss_Agreement_Terms_Confidant_agrees_contacted" (formName, formFieldValues) {
        var yes = formFieldValues["Apss_Agreement_Terms_Confidant_agrees_contacted"];
        if (yes === "Apss_Agreement_Terms_Confidant_agrees_contacted_Yes")  {
            return {
                show: ["Apss_Agreement_Terms_Confidant_agrees_contacted_Type_of_TC_Contact"]
            }
        } else {
            return {
                hide: ["Apss_Agreement_Terms_Confidant_agrees_contacted_Type_of_TC_Contact"]
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
    },
    "Pregnancy_Yes_No" (formName, formFieldValues) {
        var pregValue = formFieldValues["Pregnancy_Yes_No"];

        if (pregValue === "Pregnancy_Yes") {
            return {
                show: ["Probable delivery date"]
            }
        } else {
            return {
                hide: ["Probable delivery date"]

            }
        }
    },
    "Date of Delivery" (formName, formFieldValues) {
        var delivValue = formFieldValues["Date of Delivery"];

        if (delivValue) {
            return {
                show: ["Number of Alive Babies Born", "Number of Still Babies Born"]
            }
        } else {
            return {
                hide: ["Number of Alive Babies Born", "Number of Still Babies Born"]
            }
        }
    },
    "CONFIDENT_HIV_TEST" (formName, formFieldValues) {
        var value = formFieldValues["CONFIDENT_HIV_TEST"];

        if (value === "CONFIDENT_HIV_POSITIVE") {
            return {
                show: ["CONFIDENT_HIV_CARE"]
            }
        } else {
            return {
                hide: ["CONFIDENT_HIV_CARE"]
            }
        }
    },
    "Gynecology/Obstetrics" (formName, formFieldValues, patient) {
        if (patient.gender === "F") {
            return {
                show: ["Gynecology/Obstetrics"],
            }
        } else {
            return {
                hide: ["Gynecology/Obstetrics"],
            }
        }
    },
    "CONFIDENT_AGE_TYPE" (formName, formFieldValues) {
        var ageType = formFieldValues["CONFIDENT_AGE_TYPE"];
        var ageVal = formFieldValues["CONFIDENT_AGE"];

        if(ageVal > 0){
            if(ageVal < 5 && (ageType === "Years" || ageType === "Anos" || ageType === "CONFIDENT_AGE_TYPE_YEARS")){
                return {
                    show: ["CONFIDENT_CCR"]
                }
            } else if (ageVal < 60 && (ageType === "Months" || ageType === "Meses" || ageType === "CONFIDENT_AGE_TYPE_MONTHS")){
                return {
                    show: ["CONFIDENT_CCR"]
                }
            }else {
                return {
                    hide: ["CONFIDENT_CCR"]
                }
            }
        } else {
            return {
                hide: ["CONFIDENT_CCR"]
            }
        }
    },
    "CONFIDENT_AGE" (formName, formFieldValues) {
        var ageType = formFieldValues["CONFIDENT_AGE_TYPE"];
        var ageVal = formFieldValues["CONFIDENT_AGE"];

        if(ageVal > 0){
            if(ageVal < 5 && (ageType === "Years" || ageType === "Anos" || ageType === "CONFIDENT_AGE_TYPE_YEARS")){
                return {
                    show: ["CONFIDENT_CCR"]
                }
            } else if (ageVal < 60 && (ageType === "Months" || ageType === "Meses" || ageType === "CONFIDENT_AGE_TYPE_MONTHS")){
                return {
                    show: ["CONFIDENT_CCR"]
                }
            }else {
                return {
                    hide: ["CONFIDENT_CCR"]
                }
            }
        } else {
            return {
                hide: ["CONFIDENT_CCR"]
            }
        }
    }

};
