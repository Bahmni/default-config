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

    },
    "HIV - Entry Point" : function (formName , formFieldValues){
        var entrypoint = formFieldValues["HIV - Entry Point"];

        if(entrypoint === "Other Entry Point (Specify)"){
            return{
                show: ["Other Entry Point"]
            }
        }else {
            return{
                hide: ["Other Entry Point"]
            }
        }     
    },
    "Transferred in on ART?" : function (formName , formFieldValues){
        var transferred = formFieldValues["Transferred in on ART?"];

        if(transferred == true){
            return{
                show: ["Name of Clinic" , "Date Transferred in"]
            }
        }else {
            return{
                hide: ["Name of Clinic" , "Date Transferred in"]
            }
        }     
    },
    "Literate" : function (formName , formFieldValues){
        var literate = formFieldValues["Literate"];
        if(literate == true){
            return{
                show: ["Education Level"]
            }
        }else {
            return{
                hide: ["Education Level"]
            }
        }     
    },
    "Drug Allergies" : function (formName , formFieldValues){
        var allergy = formFieldValues["Drug Allergies"];
        if(allergy == true){
            return{
                show: ["HIV Care -Drug Allergies Notes"]
            }
        }else {
            return{
                hide: ["HIV Care -Drug Allergies Notes"]
            }
        }    
    },
    "Were ARVS Received , In Clinical Milestones" : function (formName , formFieldValues){
        var arvsreceived = formFieldValues["Were ARVS Received , In Clinical Milestones"];
        if(arvsreceived == true){
            return{
                show: ["ARVs Received in" , "Place Received ART", "Other (Place specify)"]
            }
        }else {
            return{
                hide: ["ARVs Received in", "Place Received ART" , "Other (Place specify)"]
            }
        }    
    },   
    "Planned Delivery Place" : function (formName , formFieldValues){
        var otheranswer = formFieldValues["Planned Delivery Place"];
        if(otheranswer === "Other Answer"){
            return{
                show: ["Other (Place specify)"]
            }
        }else {
            return{
                hide: ["Other (Place specify)"]
            }
        }    
    },
    "TB Screening, Person Age" : function (formName , formFieldValues){
        var personage = formFieldValues["TB Screening, Person Age"];
        if(personage < 15){
            return{
                show: ["Close Contact History with TB patients"]
            }
        }else {
            return{
                hide: ["Close Contact History with TB patients"]
            }
        }    
    },
    "Follow up - Scheduled" : function (formName , formFieldValues){
        var scheduled = formFieldValues["Follow up - Scheduled"];
        if(scheduled == true){
            return{
                show: ["ART Follow up - Scheduled Date"]
            }
        }else {
            return{
                hide: ["ART Follow up - Scheduled Date"]
            }
        }    
    },   
    "Current on FP" : function (formName , formFieldValues){
        var currentfp = formFieldValues["Current on FP"];
        if(currentfp == true){
            return{
                show: ["FP Method"]
            }
        }else {
            return{
                hide: ["FP Method"]
            }
        }    
    },
    "Hospitalised" : function (formName , formFieldValues){
        var hospitalised = formFieldValues["Hospitalised"];
        if(hospitalised == true){
            return{
                show: ["Number of Days Hospitalized"]
            }
        }else {
            return{
                hide: ["Number of Days Hospitalized"]
            }
        } 
    },

    "AntiRetroviral Treatment" : function (formName , formFieldValues, patient){ 
        if(patient.age < 15){
            return{
                show: ["Child Regimen Information"],
                hide:["ART Regimen - Substitution within 1st Line" , "ART Regimen(Switch to 2nd Line)"]
            }
        }else {
            return{
                hide: ["Child Regimen Information"]
            }
        } 
    },
    
    

};