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
    "End Of Follow Up Reason" : function(formName, formFieldValues) {
        var death = formFieldValues["End Of Follow Up Reason"];       
        if(death === "Death during treatment") {
            return {
                hide: ["Lost To Follow Up Information" , "Transferred Out Information"],
                show:["Death Information"]
                // hide:["Transferred Out Information"]
            }
        } else if( death === "Lost Follow Up( < 3 Months)"){ 
            return {
                hide: ["Death Information", "Transferred Out Information"],
                show: ["Lost To Follow Up Information"]
        }
        }else if (death === "Transferred Out"){
            return {
                hide: ["Lost To Follow Up Information" , "Death Information"],
                show: ["Transferred Out Information"]
            }
        }
        else {
            return {
                hide: ["Death Information", "Transferred Out Information" , "Lost To Follow Up Information"]
            }
        }
        
    }, 
    "Occupation" : function (formName , formFieldValues){
        var occupationanswer = formFieldValues["Occupation"];
       
        if(occupationanswer === "Occupation - Other (Specify)"){
          return{
              show: ["Other - Occupation"]
          }
        }else {
            return{
                hide: ["Other - Occupation"]
            }
        }

    }  
};