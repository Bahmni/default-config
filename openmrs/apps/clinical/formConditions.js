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

            show: ["Received nutritional education", "Nutrition Supplement"]
        }
    } else {
        return {
            hide: ["Received nutritional education", "Nutrition Supplement"]
        }
    }
},
"Nutrition Supplement" (formName, formFieldValues) {
    var dia = formFieldValues["Nutrition Supplement"];

    if (dia) {
        return {

            show: ["Quantity of Nutritional Supplement", "SP_Measurement_Unit"]
        }
    } else {
        return {
            hide: ["Quantity of Nutritional Supplement", "SP_Measurement_Unit"]
        }
    }
},
"STI Diagnosis_Prophylaxis" (formName, formFieldValues, patient) {
    var dia = formFieldValues["STI Diagnosis_Prophylaxis"];

    if (dia === "Syndromic Approach") {
        if (patient.gender === "M") {
            return {
                show: ["Syndromic Approach_STI_M"]
            }
    } else {
            return {
                show: ["Syndromic Approach_STI_F"]
            }
        }
    } else {
        return {
            hide:["Syndromic Approach_STI_M", "Syndromic Approach_STI_F"]
        }
    }
},
"Nutrition_Prophylaxis" (formName, formFieldValues, patient) {
    if (patient.age < 5) {
        return {
            show: ["Infants Odema_Prophylaxis"]
        }
    } else {
        return {
            hide: ["Infants Odema_Prophylaxis"]
        }
    }

},
"Type_Prophylaxis" (formName, formFieldValues) {
    var dia = formFieldValues["Type_Prophylaxis"];
    var returnShowValue = [];
    var returnHideValue = [];
    if(formName !== "Clinical_History_Obs_Form" && formName !== "Tarv_and_Prophilaxis") {
        if (dia === "INH") {
            returnShowValue.push("INH_Details");
            returnHideValue.push("Secondary effects_INH");

        } else {
            returnHideValue.push("INH_Details");

        }
        if (dia === "CTZ") {

            returnShowValue.push("CTZ_Details");
            returnHideValue.push("Secondary effects_CTZ");

        } else {
            returnHideValue.push("CTZ_Details");

        }
        if (dia === "Fluconazol") {

            returnShowValue.push("Fluconazol_Details");
            returnHideValue.push("Secondary effects_Fluconazol");

        } else {
            returnHideValue.push("Fluconazol_Details");

        }


        return {

            show: returnShowValue,
            hide: returnHideValue
        }
    }

    
    
},
"SP_Side_Effects_INH" (formName, formFieldValues, patient) {
    var answer = formFieldValues["SP_Side_Effects_INH"];
    if (answer) {
        return {
            show: ["Secondary effects_INH"]    
        }
    } else {
        return {
            hide: ["Secondary effects_INH"]
        }
    }
},
"SP_Side_Effects_CTZ" (formName, formFieldValues, patient) {
    var answer = formFieldValues["SP_Side_Effects_CTZ"];
    if (answer) {
        return {
            show: ["Secondary effects_CTZ"]    
        }
    } else {
        return {
            hide: ["Secondary effects_CTZ"]
        }
    }
},
"SP_Side_Effects_Fluconazol" (formName, formFieldValues, patient) {
    var answer = formFieldValues["SP_Side_Effects_Fluconazol"];
    if (answer) {
        return {
            show: ["Secondary effects_Fluconazol"]    
        }
    } else {
        return {
            hide: ["Secondary effects_Fluconazol"]
        }
    }
},
"Family_Planning_Methods" (formName, formFieldValues, patient) {
    
    if (patient.gender === "M") {
        return {
            show: ["Family_Planning_Contraceptive_Methods_PRES_Condom_button", "Family_Planning_Contraceptive_Methods_VAS_Vasectomy_button",
                "Family_Planning_Contraceptive_Methods_OUT_Other_button"],
            hide: ["Family_Planning_Contraceptive_Methods_INJ_Injection_button", "Family_Planning_Contraceptive_Methods_IMP_Implant_button",
                "Family_Planning_Contraceptive_Methods_DIU_Intra_button",
                "Family_Planning_Contraceptive_Methods_LT_Tubal_Ligation_button","Family_Planning_Contraceptive_Methods_PIL_Oral_Contraceptive_button", "Family_Planning_Contraceptive_Methods_MAL_Lactational_Amenorrhea_Method_button"]
        }
    }
    else {
        return {
            show: ["Family_Planning_Contraceptive_Methods_PIL_Oral_Contraceptive_button",
                "Family_Planning_Contraceptive_Methods_INJ_Injection_button", "Family_Planning_Contraceptive_Methods_IMP_Implant_button",
                "Family_Planning_Contraceptive_Methods_DIU_Intra_button",
                "Family_Planning_Contraceptive_Methods_LT_Tubal_Ligation_button", "Family_Planning_Contraceptive_Methods_MAL_Lactational_Amenorrhea_Method_button"],
            hide: ["Family_Planning_Contraceptive_Methods_VAS_Vasectomy_button"]
        }
    }
},

    "Anthropometric" (formName, formFieldValues, patient) {
        if ((patient.gender === "M") && (patient.age > 5)) {
           return {
               hide: ["Brachial_perimeter_new"]
           }
        } else {
            return {
                show: ["Brachial_perimeter_new"]
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
                show: ["Apss_Adherence_follow_up_Has_informed_someone_RELATIONSHIP"]
            }
        } else {
            return {
                hide: ["Apss_Adherence_follow_up_Has_informed_someone_RELATIONSHIP"]
            }
        }
    },
    "Apss_Adherence_follow_up_If_Child_Adolescent_Elderly_Disabled" (formName, formFieldValues) {
        var yes = formFieldValues["Apss_Adherence_follow_up_If_Child_Adolescent_Elderly_Disabled"];
        if (yes === "Apss_Adherence_follow_up_If_Child_Adolescent_Elderly_Disabled_Yes") {
            return {
                show: ["Apss_Adherence_follow_up_Administers_ARV_Alone"]
            }
        } else {
            return {
                hide: ["Apss_Adherence_follow_up_Administers_ARV_Alone", "Apss_Adherence_follow_up_Who_administers_Full_Name", "CONFIDENT_RELATIONSHIP"]
            }
        }
    },
    "Apss_Adherence_follow_up_Administers_ARV_Alone" (formName, formFieldValues) {
        var answer = formFieldValues["Apss_Adherence_follow_up_Administers_ARV_Alone"];
        if (answer === "Apss_Adherence_follow_up_Administers_ARV_Alone_No") {
            return {
                show: ["Apss_Adherence_follow_up_Who_administers_Full_Name", "CONFIDENT_RELATIONSHIP"]
            }
        } else {
            return {
                hide: ["Apss_Adherence_follow_up_Who_administers_Full_Name", "CONFIDENT_RELATIONSHIP"]
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
    "HTC, WHO Staging" (formName, formFieldValues) {
        var staging = formFieldValues["HTC, WHO Staging"];
        if (staging === "WHO Stage I") {
            return {
                show: ["HOF_CLINICAL_SITUATION_STAGING_I_CONDITION"],
                hide: ["HOF_CLINICAL_SITUATION_STAGING_II_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_III_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_IV_CONDITION"]
            }
        } else if (staging === "WHO Stage II") {
            return {
                show: ["HOF_CLINICAL_SITUATION_STAGING_II_CONDITION"],
                hide: ["HOF_CLINICAL_SITUATION_STAGING_I_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_III_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_IV_CONDITION"]
            }
        } if (staging === "WHO Stage III") {
            return {
                show: ["HOF_CLINICAL_SITUATION_STAGING_III_CONDITION"],
                hide: ["HOF_CLINICAL_SITUATION_STAGING_I_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_II_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_IV_CONDITION"]
            }
        } if (staging === "WHO Stage IV") {
            return {
                show: ["HOF_CLINICAL_SITUATION_STAGING_IV_CONDITION"],
                hide: ["HOF_CLINICAL_SITUATION_STAGING_I_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_II_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_III_CONDITION"]
            }
        } else {
            return {
                hide: ["HOF_CLINICAL_SITUATION_STAGING_I_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_II_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_III_CONDITION", "HOF_CLINICAL_SITUATION_STAGING_IV_CONDITION"]
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
    "Reference_Other_Specify_Group" (formName, formFieldValues) {
        var value = formFieldValues["Reference_Other_Specify_Group"];
        
        if (value) {
            return {
                show: ["Reference_Other_Specify_Group_Other"]
            }
        } else {
            return {
                hide: ["Reference_Other_Specify_Group_Other"]
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
                hide: ["Reference_GA","Reference_AF","Reference_CA","Reference_PU","Reference_FR","Reference_DT","Reference_DC","Reference_MDC_Other","Reference_MDC_Other_comments"]
            }
        }
    },
    "HOF_CLINICAL_SITUATION_Model_Type" (formName, formFieldValues) {
        var value = formFieldValues["HOF_CLINICAL_SITUATION_Model_Type"];
        
        if (value) {
            return {
                show: ["Reference_GA","Reference_AF","Reference_CA","Reference_PU","Reference_FR","Reference_DT","Reference_DC","Reference_MDC_Other"]
            }
        } else {
            return {
                hide: ["Reference_GA","Reference_AF","Reference_CA","Reference_PU","Reference_FR","Reference_DT","Reference_DC","Reference_MDC_Other","Reference_MDC_Other_comments"]
            }
        }
    },
    "Reference_MDC_Other" (formName, formFieldValues) {
        var pregValue = formFieldValues["Reference_MDC_Other"];
        if (pregValue) {
             return {
                show: ["Reference_MDC_Other_comments"]
             }
         } else {
             return {
                hide: ["Reference_MDC_Other_comments"]
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

    "CONFIDENT_HIV_CARE" (formName,formFieldValues) {
        var value = formFieldValues["CONFIDENT_HIV_CARE"];

        if (value == true){
            return {
                show: ["CONFIDENT_NID"]
        }
        } else {
            return {
                hide: ["CONFIDENT_NID"]
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
                    hide: ["CONFIDENT_CCR"],
                    show: ["CONFIDENT_AGE_TYPE"]
                }
            }
        } else if( ageVal === 0) {
            return {
                hide: ["CONFIDENT_CCR"],
                disable: ["CONFIDENT_AGE_TYPE"],
                error: "Introduza Idade maior que zero"
            }
        } else {
            return {
                hide: ["CONFIDENT_CCR"],
                disable: ["CONFIDENT_AGE_TYPE"]
            }
        }
    },

    "HOF_LAB_SITUATION_Carga_Viral" (formName, formFieldValues) {
        var yes = formFieldValues["HOF_LAB_SITUATION_Carga_Viral"];
        if (yes === "HOF_LAB_SITUATION_Carga_Viral_Qualitativo_option")   {
            return {
                show: ["HOF_LAB_SITUATION_Carga_Viral_Qualitativo"]
            }
        }  else if (yes === "HOF_LAB_SITUATION_Carga_Viral_Absolute_option") {

            return {
                show: ["HOF_LAB_SITUATION_Carga_Viral_Absolute"]
            }
        }
        else {
            return {
                hide: ["HOF_LAB_SITUATION_Carga_Viral_Qualitativo","HOF_LAB_SITUATION_Carga_Viral_Absolute"]
            }
        }
    },

};
