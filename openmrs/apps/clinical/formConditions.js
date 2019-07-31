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
                hide:["ART Regimen - Substitution within 1st Line" , "ART Regimen(Switch to 2nd Line)" ,"Initial ART Regimen (Adult)"]
            }
        }else {
            return{
                hide: ["Child Regimen Information" , "Initial ART Regimen(Children)"]
            }
        } 
    },
    "Interruption Type" : function (formName , formFieldValues){
        var interruptiontype = formFieldValues["Interruption Type"];
        if(interruptiontype === "Stop"){
            return{
                show: ["ART Treatment Reasons For Stop"]
            }
        }else {
            return{
                hide: ["ART Treatment Reasons For Stop"]
            }
        }    
    },
    "Switched Regimen" : function (formName , formFieldValues){
        var switchedregimen = formFieldValues["Switched Regimen"];
        if(switchedregimen == true){
            return{
                show: ["Regimen Switched To"]
            }
        }else {
            return{
                hide: ["Regimen Switched To"]
            }
        }    
    },
    "Regimen Switched To" : function (formName , formFieldValues){
        var switchedregimento = formFieldValues["Regimen Switched To"];
        if(switchedregimento === "Regimen Switched To (Adult First Line)"){
            return{
                show: ["ART Regimen - Substitution within 1st Line"],
                hide: ["ART Regimen(Switch to 2nd Line)","Other Reason"]

            }
        }else if(switchedregimento === "Regimen Switched To (Adult Second Line)"){
            return{
                show: ["ART Regimen(Switch to 2nd Line)" ],
                hide:  ["ART Regimen - Substitution within 1st Line","Other Reason(Second Regimen Change)"]
            }
        }  else {
            return{
                hide: ["ART Regimen - Substitution within 1st Line", "ART Regimen(Switch to 2nd Line)"]

            }

        }  
    }, 
    "ART Treatment Reasons For Stop" : function (formName , formFieldValues){
        var arttreatmentreason = formFieldValues["ART Treatment Reasons For Stop"];
        if(arttreatmentreason === "Other Reason For ART Stop"){
            return{
                show: ["Specify Reason For Art Stop"]
            }
        }else {
            return{
                hide: ["Specify Reason For Art Stop"]
            }
        }    
    },
    "Reason For Regimen Change(First Line)" : function (formName , formFieldValues){
        var changereasonfirstreg = formFieldValues["Reason For Regimen Change(First Line)"];
        if(changereasonfirstreg === "Other Reason For Regimen Change(First Line)"){
            return{
                show: ["Other Reason"]
            }
        }else {
            return{
                hide: ["Other Reason"]
            }
        }    
    },
    "Reason For Regimen Change(Second Line)" : function (formName , formFieldValues){
        var changereasonsecondreg = formFieldValues["Reason For Regimen Change(Second Line)"];
        if(changereasonsecondreg === "Other Reason For Regimen Change(Second Line)"){
            return{
                show: ["Other Reason(Second Regimen Change)"]
            }
        }else {
            return{
                hide: ["Other Reason(Second Regimen Change)"]
            }
        }    
    }
};