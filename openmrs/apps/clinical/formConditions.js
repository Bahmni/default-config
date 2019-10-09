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
        } else if( death === "Lost Follow Up(< 28days)"){ 
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
    "Were ARVS Received?" : function (formName , formFieldValues){
        var arvsreceived = formFieldValues["Were ARVS Received?"];
        if(arvsreceived == true){
            return{
                show: ["ARVs Received in" , "Place Received ART", "Other (Place specify)","ANC, ART Start Date","ART ,Stop Date"]      
            }
        }else {
            return{
                hide: ["ARVs Received in", "Place Received ART" , "Other (Place specify)","ANC, ART Start Date","ART ,Stop Date"]
            
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
    "TB Screening information" : function (formName , formFieldValues, patient){
        if(patient.age < 15){
            return{
                show: ["Close Contact History with TB patients","Failure to Thrive, Children"],
                hide:["TB Screening , Night Sweats","TB Screening ,Weight loss"]
            }
        }else {
            return{
                hide: ["Close Contact History with TB patients","Failure to Thrive, Children"],
                show:["TB Screening , Night Sweats","TB Screening ,Weight loss"]
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
                hide: ["ART Regimen(Switch to 2nd Line)","Other Reason(First Line Regimen Change)"]

            }
        }else if(switchedregimento === "Regimen Switched To (Adult Second Line)"){
            return{
                show: ["ART Regimen(Switch to 2nd Line)"],
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
                show: ["Other Reason(First Line Regimen Change)"]
            }
        }else {
            return{
                hide: ["Other Reason(First Line Regimen Change)"]
            }
        }    
    },
    "Reason For Regimen Change(Second Line)" : function (formName , formFieldValues){
        var changereasonsecond = formFieldValues["Reason For Regimen Change(Second Line)"];
        if(changereasonsecond === "Other Reason For Regimen Change(First Line)"){
            return{
                show: ["Other Reason(Second Regimen Change)"]
            }
        }else {
            return{
                hide: ["Other Reason(Second Regimen Change)"]
            }
        }    
    },
    "Family Member - HIV Status" : function (formName , formFieldValues){
        var hivstatus = formFieldValues["Family Member - HIV Status"];
        if(hivstatus === "Known"){
            return{
                show: ["Result","Date Tested HIV","Result of HTS","Unique ART No/HEI No"]
            }
        }else {
            return{
                hide: ["Result","Date Tested HIV","Result of HTS","Unique ART No/HEI No"]
            }
        }    
    },
    "ART Follow up - Information" : function (formName , formFieldValues, patient){
        if(patient.gender === "F"){     
            return{
                show: ["Current on FP","FP Pregnant","FP Method","EDD","PMTCT - HIV & ART Follow up"]
            }
        }else {
            return{
                hide: ["Current on FP","FP Pregnant","FP Method","EDD","PMTCT - HIV & ART Follow up"]
            }
        }    
    }, 
    "VL Results" : function (formName , formFieldValues){
    var vlresults = formFieldValues["VL Results"];
        if(vlresults >= 1000){ 
            alert("Patient Required Enhanced Adherence Counselling");    
            return{
           show:["was counselling done?"]            
            }
        }else {
            return{
                hide:["was counselling done?"]
            }
        }    
    }, 
    "FP Pregnant" : function (formName , formFieldValues){
        var fppregnant = formFieldValues["FP Pregnant"];
            if(fppregnant == true){     
                alert("Enroll This Patient To PMTCT Clinic");
            }    
        }, 
   
    "Date of HIV Retesting Before ART": function (formName, formFieldValues) {
        var dateretestedhiv = formFieldValues["Date of HIV Retesting Before ART"];
        var datefirsttestedhiv = formFieldValues["Date First Tested HIV +"];
        var date1 = new Date(datefirsttestedhiv);
        var date2 = new Date(dateretestedhiv);
        if (date1 > date2) {
            alert("HIV RETESTING DATE SHOULD BE GREATER THAN HIV FIRST TESTING DATE");
            
        }
    },
    "ART Regimen - Substitution within 1st Line" : function (formName , formFieldValues, patient){
        if(patient.age < 15){     
            return{
                show: ["Child Regimens (First Line)"],
                hide:["Substitution Regimen For Adults(First Line)"]
            }
        }else {
            return{
                hide: ["Child Regimens (First Line)"],
                show: ["Substitution Regimen For Adults(First Line)"]
            }
        }    
    },  
    "ART Regimen(Switch to 2nd Line)" : function (formName , formFieldValues, patient){
        if(patient.age < 15){     
            return{
                show: ["Children Second Line Regimens"],
                hide:["Substitution Regimen (2nd Line Adults)"]
            }
        }else {
            return{
                hide: ["Children Second Line Regimens"],
                show:["Substitution Regimen (2nd Line Adults)"]
            }
        }    
    }, 
    "AntiRetroviral Treatment" : function (formName , formFieldValues, patient){
        if(patient.age < 15){     
            return{
                show: ["Initial ART Regimen For Children"],
                hide:["Initial ART Regimen (Adult)"]
                
            }
        }else {
            return{
                hide: ["Initial ART Regimen For Children"],
                show:["Initial ART Regimen (Adult)"]
                
            }
        }    
    }, 
    "Is there an immunization not Given?" : function (formName , formFieldValues){
        var immunizationgiven = formFieldValues["Is there an immunization not Given?"];
            if(immunizationgiven == true){ 
                return{
               show:["Immunization Not Given"]            
                }
            }else {
                return{
                    hide:["Immunization Not Given"]
                }
            }    
        },
    "Clinical Assessment for Signs and Symptoms of HIV": function (formName, formFieldValues) {
        var clinicalassessment = formFieldValues["Clinical Assessment for Signs and Symptoms of HIV"];
        if (clinicalassessment === "Other Assessment Specify") {
            return {
                show: ["Specify other Assessement"]
            }
        } else {
            return {
                hide: ["Specify other Assessement"]
            }
        }
    },

    "Was any Development Milestone Missed?": function (formName, formFieldValues) {
        var milestonemissed = formFieldValues["Was any Development Milestone Missed?"];
        if (milestonemissed == true) {
            return {
                show: ["Development Milestones Missed"]
            }
        } else {
            return {
                hide: ["Development Milestones Missed"]
            }
        }
    },
    "Mother's ART Regimen": function (formName, formFieldValues) {
        var motherartregimen = formFieldValues["Mother's ART Regimen"];
        if (motherartregimen === "Other ART Regimen") {
            return {
                show: ["Specify other Mother's ART Regimen"]
            }
        } else {
            return {
                hide: ["Specify other Mother's ART Regimen"]
            }
        }
    },
    "HEI Treatment - Referred To ART Clinic": function (formName, formFieldValues) {
        var referredtoclinic = formFieldValues["HEI Treatment - Referred To ART Clinic"];
        if (referredtoclinic == true) {
            return {
                show: ["HEI Treatment - Referred To ART Clinic Date"]
            }
        } else {
            return {
                hide: ["HEI Treatment - Referred To ART Clinic Date"]
            }
        }
    },
    "HEI Treatment - Referred To ART Clinic": function (formName, formFieldValues) {
        var referredtoclinic = formFieldValues["HEI Treatment - Referred To ART Clinic"];
        if (referredtoclinic == true) {
            return {
                show: ["HEI Treatment - Referred To ART Clinic Date"]
            }
        } else {
            return {
                hide: ["HEI Treatment - Referred To ART Clinic Date"]
            }
        }
    },
    "HEI Treatment - Enrolled AT ART Clinic": function (formName, formFieldValues) {
        var enrolleddate = formFieldValues["HEI Treatment - Enrolled AT ART Clinic"];
        if (enrolleddate == true) {
            return {
                show: ["HEI Treatment - Enrolled AT ART Date"]
            }
        } else {
            return {
                hide: ["HEI Treatment - Enrolled AT ART Date"]
            }
        }
    },
    "Place Received ART": function (formName, formFieldValues) {
        var placeartreceived = formFieldValues["Place Received ART"];
        if (placeartreceived === "Other Answer") {
            return {
                show: ["Other (Place specify)"]
            }
        } else {
            return {
                hide: ["Other (Place specify)"]
            }
        }
    },
    "Is Patient on CTX or Dapose?": function (formName, formFieldValues) {
        var patientondapose = formFieldValues["Is Patient on CTX or Dapose?"];
        if (patientondapose == true) {
            return {
                show: ["CTX or Dapose Start Date"]
            }
        } else {
            return {
                hide: ["CTX or Dapose Start Date"]
            }
        }
    },
    "FP Pregnant": function (formName, formFieldValues) {
        var patientpreg = formFieldValues["FP Pregnant"];
        if (patientpreg == true) {
            return {
                show: ["EDD","PMTCT - HIV & ART Follow up"],
                hide:["Current on FP"]
            }
        } else {
            return {
                hide: ["EDD","PMTCT - HIV & ART Follow up"],
                show:["Current on FP"]
            }
        }
    },
    "ART Follow up - Information": function (formName , formFieldValues, patient){ 
        if(patient.age < 15){
            return{
                show: ["TB Regimen For Children"]
              
            }
        }else {
            return{
                hide: ["TB Regimen For Children"]
            }
        } 
    },
    "First Attempt Method": function (formName, formFieldValues) {
        var firstmethod = formFieldValues["First Attempt Method"];
        if (firstmethod === "Other Specify") {
            return {
                show:["Other Follow up Method Specify(First Attempt)"]
            }
        } else {
            return {
                hide:["Other Follow up Method Specify(First Attempt)"]
            }
        }
    },
    "First Attempt Outcome": function (formName, formFieldValues) {
        var firstoutcome = formFieldValues["First Attempt Outcome"];
        if (firstoutcome === "Other Outcome") {
            return {
                show:["Follow up Outcome Others Specify(First Attempt)"]
            }
        } else {
            return {
                hide:["Follow up Outcome Others Specify(First Attempt)"]
            }
        }
    },
    "Second Attempt Method": function (formName, formFieldValues) {
        var secondmethod = formFieldValues["Second Attempt Method"];
        if (secondmethod === "Other Specify") {
            return {
                show:["Other Follow up Method Specify(Second Attempt)"]
            }
        } else {
            return {
                hide:["Other Follow up Method Specify(Second Attempt)"]
            }
        }
    },
    "Outcome,Second Attempt": function (formName, formFieldValues) {
        var secondoutcome = formFieldValues["Outcome,Second Attempt"];
        if (secondoutcome === "Other Specify") {
            return {
                show:["Follow up Outcome Others Specify(Second Attempt)"]
            }
        } else {
            return {
                hide:["Follow up Outcome Others Specify(Second Attempt)"]
            }
        }
    },
    "Third Attempt Method": function (formName, formFieldValues) {
        var thirdmethod = formFieldValues["Third Attempt Method"];
        if (thirdmethod === "Other") {
            return {
                show:["Other Follow up Method Specify(Third Attempt)"]
            }
        } else {
            return {
                hide:["Other Follow up Method Specify(Third Attempt)"]
            }
        }
    },
    "Third Attempt Outcome": function (formName, formFieldValues) {
        var thirdoutcome = formFieldValues["Third Attempt Outcome"];
        if (thirdoutcome === "Other Outcome") {
            return {
                show:["Follow up Outcome Others Specify(Third Attempt)"]
            }
        } else {
            return {
                hide:["Follow up Outcome Others Specify(Third Attempt)"]
            }
        }
    },
    "Fourth Attempt Method": function (formName, formFieldValues) {
        var forthmethod = formFieldValues["Fourth Attempt Method"];
        if (forthmethod === "Other") {
            return {
                show:["Other Follow up Method Specify(Fourth Attempt)"]
            }
        } else {
            return {
                hide:["Other Follow up Method Specify(Fourth Attempt)"]
            }
        }
    },
    "Fourth Attempt Outcome": function (formName, formFieldValues) {
        var forthoutcome = formFieldValues["Fourth Attempt Outcome"];
        if (forthoutcome === "Other Outcome") {
            return {
                show:["Follow up Outcome Others Specify(Fourth Attempt)"]
            }
        } else {
            return {
                hide:["Follow up Outcome Others Specify(Fourth Attempt)"]
            }
        }
    },
    "ARVs Adherence": function (formName, formFieldValues) {
        var arvsadherence = formFieldValues["ARVs Adherence"];
        if (arvsadherence === "Adherence Fair") {
            return {
                show: ["Reason why Adherence is Fair"],
                hide: ["Reason why Adherence is Poor"]
            }
        } else if (arvsadherence === "Adherence Poor") {
            return {
                show: ["Reason why Adherence is Poor"],
                hide: ["Reason why Adherence is Fair"]

            }
        } else {
            return{
                hide: ["Reason why Adherence is Fair","Reason why Adherence is Poor"]
            }
        }
    },
    "Is Family Member in ART Care?": function (formName, formFieldValues) {
        var memberinclinic = formFieldValues["Is Family Member in ART Care?"];
        if (memberinclinic == true) {
            return {
                show:["Family Member ART Number"]
            }
        } else {
            return {
                hide:["Family Member ART Number"]
            }
        }
    },
    "was counselling done?": function (formName, formFieldValues) {
        var counsellingdone = formFieldValues["was counselling done?"];
        if (counsellingdone == true) {
            return {
                show:["First EAC Session Date","Classification Of Adherence(First session)"]
            }
        } else {
            return {
                hide:["First EAC Session Date","Classification Of Adherence(First session)"]
            }
        }
    },
    "MDT Held?": function (formName, formFieldValues) {
        var mdtheld = formFieldValues["MDT Held?"];
        if (mdtheld == true) {
            return {
                show:["Date MDT Held"]
            }
        } else {
            return {
                hide:["Date MDT Held"]
            }
        }
    },
 };

