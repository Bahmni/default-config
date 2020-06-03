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
                show: ["Other Entry Point"],
                hide: ["VCT Clinic registration Date","TB Clincic Registration Date","STI Clinic Registration Date","ANC Clinic Registration Date","In Patient Registration Date","Pediatric Clinic Registration Date","OPD Registration Date","Index Testing Date","CBTC Registration Date"]
            }
        }else if(entrypoint === "VCT Clinic") {
            return {
               show: ["VCT Clinic registration Date"],
               hide: ["Other Entry Point","TB Clincic Registration Date","STI Clinic Registration Date","ANC Clinic Registration Date","In Patient Registration Date","Pediatric Clinic Registration Date","OPD Registration Date","Index Testing Date","CBTC Registration Date"] 
            }
        }else if(entrypoint === "TB Clinic") {
            return {
               show: ["TB Clincic Registration Date"],
               hide: ["Other Entry Point","VCT Clinic registration Date","STI Clinic Registration Date","ANC Clinic Registration Date","In Patient Registration Date","Pediatric Clinic Registration Date","OPD Registration Date","Index Testing Date","CBTC Registration Date"] 
            }
        }else if(entrypoint === "STI Clinic") {
            return {
               show: ["STI Clinic Registration Date"],
               hide: ["Other Entry Point","VCT Clinic registration Date","TB Clincic Registration Date","ANC Clinic Registration Date","In Patient Registration Date","Pediatric Clinic Registration Date","OPD Registration Date","Index Testing Date","CBTC Registration Date"] 
            }
        }else if(entrypoint === "ANC Clinic") {
            return {
               show: ["ANC Clinic Registration Date"],
               hide: ["Other Entry Point","VCT Clinic registration Date","TB Clincic Registration Date","STI Clinic Registration Date","In Patient Registration Date","Pediatric Clinic Registration Date","OPD Registration Date","Index Testing Date","CBTC Registration Date"] 
            }
        }else if(entrypoint === "In Patient") {
            return {
               show: ["In Patient Registration Date"],
               hide: ["Other Entry Point","VCT Clinic registration Date","TB Clincic Registration Date","STI Clinic Registration Date","ANC Clinic Registration Date","Pediatric Clinic Registration Date","OPD Registration Date","Index Testing Date","CBTC Registration Date"] 
            }
        }else if(entrypoint === "Pediatric Clinic") {
            return {
               show: ["Pediatric Clinic Registration Date"],
               hide: ["Other Entry Point","VCT Clinic registration Date","TB Clincic Registration Date","STI Clinic Registration Date","ANC Clinic Registration Date","In Patient Registration Date","OPD Registration Date","Index Testing Date","CBTC Registration Date"] 
            }
        }else if(entrypoint === "Entry Point - OPD") {
            return {
               show: ["OPD Registration Date"],
               hide: ["Other Entry Point","VCT Clinic registration Date","TB Clincic Registration Date","STI Clinic Registration Date","ANC Clinic Registration Date","In Patient Registration Date","Pediatric Clinic Registration Date","Index Testing Date","CBTC Registration Date"] 
            }
        }else if(entrypoint === "CBTC") {
            return {
               show: ["CBTC Registration Date"],
               hide: ["Other Entry Point","VCT Clinic registration Date","TB Clincic Registration Date","STI Clinic Registration Date","ANC Clinic Registration Date","In Patient Registration Date","Pediatric Clinic Registration Date","OPD Registration Date","Index Testing Date"] 
            }
        }else if(entrypoint === "Index Testing") {
            return {
               show: ["Index Testing Date"],
               hide: ["Other Entry Point","VCT Clinic registration Date","TB Clincic Registration Date","STI Clinic Registration Date","ANC Clinic Registration Date","In Patient Registration Date","Pediatric Clinic Registration Date","OPD Registration Date","CBTC Registration Date"] 
            }
        }else {
            return{
                hide: ["Other Entry Point","VCT Clinic registration Date","TB Clincic Registration Date","STI Clinic Registration Date","ANC Clinic Registration Date","In Patient Registration Date","Pediatric Clinic Registration Date","OPD Registration Date","Index Testing Date","CBTC Registration Date"]
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
                show: ["ART Treatment Reasons For Stop","ART Treatment Stop/Lost Date","Date If Restarted"],
                hide:["Regimen Change Date","Initial ART Regimen (Adult)","Regimen Changed to(Adults)","Initial Regimen Change Reason","Other Reason(First Line Regimen Change)"]
            }
        } else if (interruptiontype === "Changed Regimen"){
            return{
                show: ["Initial ART Regimen (Adult)","Regimen Changed to(Adults)","Initial Regimen Change Reason","Other Reason(First Line Regimen Change)","Regimen Change Date"],
                hide:["ART Treatment Stop/Lost Date","ART Treatment Reasons For Stop","Date If Restarted","Date when ART Drugs Lost"]
            }
        } 
        else if (interruptiontype === "Lost"){
            return{
                 show: ["Date If Restarted"],
                 hide: ["Regimen Change Date","ART Treatment Reasons For Stop","Initial ART Regimen (Adult)","Regimen Changed to(Adults)","Initial Regimen Change Reason","ART Treatment Stop/Lost Date","Regimen Change Date","Other Reason(First Line Regimen Change)"]
            }
        }  
        else {
            return{
                hide: ["ART Treatment Reasons For Stop","Initial ART Regimen (Adult)","Regimen Changed to(Adults)","Initial Regimen Change Reason","ART Treatment Stop/Lost Date","Regimen Change Date","Date If Restarted","Other Reason(First Line Regimen Change)","Date when ART Drugs Lost"]
                
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
    "FP Pregnant": function (formName, formFieldValues) {
        var patientpreg = formFieldValues["FP Pregnant"];
        if (patientpreg == true) {
            return {
                show: ["EDD","PMTCT - HIV & ART Follow up"],
                hide:["Current on FP"],
                
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
    "CTX Adherence": function (formName, formFieldValues) {
        var ctxsadherence = formFieldValues["CTX Adherence"];
        if (ctxsadherence === "Adherence Fair") {
            return {
                show: ["Reason why Adherence is Fair"],
                hide: ["Reason why Adherence is Poor"]
            }
        } else if (ctxsadherence === "Adherence Poor") {
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
    "MDT Held?": function (formName, formFieldValues) {
        var mdtheld = formFieldValues["MDT Held?"];
        if (mdtheld == true) {
            return {
                show:["Date MDT Held","MDT Outcome"]
            }
        } else {
            return {
                hide:["Date MDT Held","MDT Outcome"]
            }
        }
    },
    "On TB Treatment" : function (formName , formFieldValues){
        var ontbtreatment = formFieldValues["On TB Treatment"];
        if(ontbtreatment == true){
            return{
                show: ["TB Unit Number","Date Started TB Treatment","TB Clinic Enrolled"]
            }
        }else {
            return{
                hide: ["TB Unit Number","Date Started TB Treatment","TB Clinic Enrolled"]
            }
        }    
    },
    "Classification Of Adherence(First EAC session)" : function (formName , formFieldValues){
        var firstclassification = formFieldValues["Classification Of Adherence(First EAC session)"];
        if((firstclassification === "Adherence Fair") || (firstclassification === "Adherence Poor")) {
            return{
                show: ["First EAC Service","First EAC Tools","First EAC Adherence Barriers"]
            }
        }else {
            return{
                hide: ["First EAC Service","First EAC Tools","First EAC Adherence Barriers"]
            }
        }    
    },
    "First EAC Tools" : function (formName , formFieldValues){
        var firsteactools = formFieldValues["First EAC Tools"];
        if(firsteactools === "Other Tools for First EAC") {
            return{
                show: ["Specify Other Tools for First EAC"]
            }
        }else {
            return{
                hide: ["Specify Other Tools for First EAC"]
            }
        }    
    },
    "Classification Of Adherence(Second EAC session)" : function (formName , formFieldValues){
        var secondclassification = formFieldValues["Classification Of Adherence(Second EAC session)"];
        if((secondclassification === "Adherence Fair") || (secondclassification === "Adherence Poor")) {
            return{
                show: ["Second EAC Service","Second EAC Tools","Second EAC Adherence Barriers"]
            }
        }else {
            return{
                hide: ["Second EAC Service","Second EAC Tools","Second EAC Adherence Barriers"]
            }
        }    
    },
    "Second EAC Tools" : function (formName , formFieldValues){
        var secondeactools = formFieldValues["Second EAC Tools"];
        if(secondeactools === "Other Tools for Second EAC") {
            return{
                show: ["Specify Other Tools for Second EAC"]
            }
        }else {
            return{
                hide: ["Specify Other Tools for Second EAC"]
            }
        }    
    },
    "Classification Of Adherence(Third EAC session)" : function (formName , formFieldValues){
        var thirdclassification = formFieldValues["Classification Of Adherence(Third EAC session)"];
        if((thirdclassification === "Adherence Fair") || (thirdclassification === "Adherence Poor")) {
            return{
                show: ["Third EAC Service","Third EAC Tools","Third EAC Adherence Barriers"]
            }
        }else {
            return{
                hide: ["Third EAC Service","Third EAC Tools","Third EAC Adherence Barriers"]
            }
        }    
    },
    "Third EAC Tools" : function (formName , formFieldValues){
        var thirdeactools = formFieldValues["Third EAC Tools"];
        if(thirdeactools === "Other Tools For Third EAC") {
            return{
                show: ["Specify Other Tools for Third EAC"]
            }
        }else {
            return{
                hide: ["Specify Other Tools for Third EAC"]
            }
        }    
    },
    "First EAC Adherence Barriers" : function (formName , formFieldValues){
        var firsteacbarriers = formFieldValues["First EAC Adherence Barriers"];
        if(firsteacbarriers === "Other First EAC Barrier Reason") {
            return{
                show: ["First EAC Barrier Reason Specify"]
            }
        }else {
            return{
                hide: ["First EAC Barrier Reason Specify"]
            }
        }    
    },
    "Second EAC Adherence Barriers" : function (formName , formFieldValues){
        var secondeacbarriers = formFieldValues["Second EAC Adherence Barriers"];
        if(secondeacbarriers === "Other Second EAC Barrier Reason") {
            return{
                show: ["Second EAC Barrier Reason Specify"]
            }
        }else {
            return{
                hide: ["Second EAC Barrier Reason Specify"]
            }
        }    
    },
    "Third EAC Adherence Barriers" : function (formName , formFieldValues){
        var thirdeacbarriers = formFieldValues["Third EAC Adherence Barriers"];
        if(thirdeacbarriers === "Other Third EAC Barrier Reason") {
            return{
                show: ["Third EAC Barrier Reason Specify"]
            }
        }else {
            return{
                hide: ["Third EAC Barrier Reason Specify"]
            }
        }    
    },
    "Sexual Partner?" : function (formName , formFieldValues){
        var sexualpartner = formFieldValues["Sexual Partner?"];
        if(sexualpartner ==  true) {
            return{
                show: ["Sexual Partner Relationship","Sexual partner names","Phone Number","Sexual contact,Contacted"],
                 hide:["Family Member - Relationship","Family Member names","Family Member - Sex","Family Member - HIV Status" ,"Family Member Contacts Tested","Family Member Contacts Status","Family Member - Age"]
            }
        }else if (sexualpartner ==  false){
            return{
                hide: ["Sexual Partner Relationship","Sexual partner names","Sexual contact,Contacted"],
                show:["Family Member - Relationship","Family Member names","Family Member - Sex","Family Member - HIV Status" ,"Family Member Contacts Tested","Family Member Contacts Status","Family Member - Age"]
               
            }
        }else {
            return {
                hide:["Family Member - Relationship","Family Member names","Family Member - Sex","Family Member - HIV Status" ,"Family Member Contacts Tested","Family Member Contacts Status" ,"Sexual Partner Relationship","Sexual partner names","Family Member - Age","Phone Number","Sexual contact,Contacted"]
            }
        }    
    },
    "Result" : function (formName , formFieldValues){
        var results = formFieldValues["Result"];
        if(results ===  "Positive") {
            return{
                show: ["Is Family Member in ART Care?"]
            }
        }else {
            return{
                hide: ["Is Family Member in ART Care?"]
               
            }
        }    
    },
    "Sexual Partner Relationship" : function (formName , formFieldValues){
        var sexualpartnerrelationship = formFieldValues["Sexual Partner Relationship"];
        if(sexualpartnerrelationship ===  "Specify other sexual Partners") {
            return{
                show: ["Other sexual Partner Relationship Specify"]
            }
        }else {
            return{
                hide: ["Other sexual Partner Relationship Specify"]
            }
        }    
    },
    "Initial Regimen Change Reason" : function (formName , formFieldValues){
        var initialregimen = formFieldValues["Initial Regimen Change Reason"];
        if(initialregimen ===  "Other Reason For Regimen Change(First Line)") {
            return{
                show: ["Other Reason(First Line Regimen Change)"]
            }
        }else {
            return{
                hide: ["Other Reason(First Line Regimen Change)"]
            }
        }    
    },
    "PMTCT - HIV & ART Follow up" : function (formName , formFieldValues){
        var pmtct = formFieldValues["PMTCT - HIV & ART Follow up"];
        if(pmtct == false) {
            alert("Please Enroll this Patient To PMTCT");

            return{
            
                show: ["Enroll Patient To PMTCT"]            
                
            }
        }else {
            return{
                hide: ["Enroll Patient To PMTCT"]
            }
        }    
    },
    "Blood Transfusion" : function (formName , formFieldValues){
        var bloodtransfusion = formFieldValues["Blood Transfusion"];
        if(bloodtransfusion == true) {
            return{
            
                show: ["Reason For Blood Transfusion"]            
                
            }
        }else {
            return{
                hide: ["Reason For Blood Transfusion"]
            }
        }    
    },
    "ANC,FP Method" : function (formName , formFieldValues){
        var fpmethod = formFieldValues["ANC,FP Method"];
        if(fpmethod === "None/Never") {
            return{
            
                show: ["Reason For not Using FP"],
                hide:["Date Started FP"]            
                
            }
        }else {
            return{
                hide: ["Reason For not Using FP"],
                show: ["Date Started FP"]
            }
        }    
    },
    "Mode of Getting to Delivery Place" : function (formName , formFieldValues){
        var modeoftransport = formFieldValues["Mode of Getting to Delivery Place"];
        if(modeoftransport === "Other Modes Of Transport") {
            return{
            
                show: ["Specify Other Modes Of transport"]            
                
            }
        }else {
            return{
                hide: ["Specify Other Modes Of transport"]
            }
        }    
    },

    "IPT Schedule(6months)" : function (formName , formFieldValues){
        var scheduledipt = formFieldValues["IPT Schedule(6months)"];
        if(scheduledipt == true) {
            return{
            
                show: ["IPT Status - TB Screening","HIVTC, HIV care IPT start date","IPT Stop Date"]            
                
            }
        }else {
            return{

                hide: ["IPT Status - TB Screening","HIVTC, HIV care IPT start date","IPT Stop Date"]   
            }
        }    
    },
    "Maternity card, Status After Testing HIV" : function (formName , formFieldValues){
        var statusaftertesting = formFieldValues["Maternity card, Status After Testing HIV"];
        if(statusaftertesting === "Positive") {
            return {             
                show:["Maternity Card, Known +ve On ART","Maternity card, New On ART","Maternity card, Date Started ART","Maternity card, ART Regimen During Pregnacy","Maternity card, ART Regimen During Delivery","Maternity card,ART Newly Started in Labor"]
            }
        } else if( statusaftertesting === "Negative"){ 
            return {
                hide:["Maternity Card, Known +ve On ART","Maternity card, New On ART","Maternity card, Date Started ART","Maternity card, ART Regimen During Pregnacy","Maternity card, ART Regimen During Delivery","Maternity card,ART Newly Started in Labor"]
        }

        }else if (statusaftertesting === "Hiv Test, inconclusive"){
            return {
                hide:["Maternity Card, Known +ve On ART","Maternity card, New On ART","Maternity card, Date Started ART","Maternity card, ART Regimen During Pregnacy","Maternity card, ART Regimen During Delivery","Maternity card,ART Newly Started in Labor"]
            }
        }
        else {
            return {
                hide:["Maternity Card, Known +ve On ART","Maternity card, New On ART","Maternity card, Date Started ART","Maternity card, ART Regimen During Pregnacy","Maternity card, ART Regimen During Delivery","Maternity card,ART Newly Started in Labor"]
            }
        
        }
    },
    "Infant HIV Status" : function (formName , formFieldValues){
        var infanthivstatus = formFieldValues["Infant HIV Status"];
        if(infanthivstatus === "Negative") {
            return {             
                show:["Infant Received ARV Prophylaxis at Birth","Infant's Risk Status","High Risk Infant Classification","Infant's Final Status","ARV Baby Discharged with"],
                hide:["Infants ART Number(For Confimed Positive Infants)","Infant's Final Status(Positive infants)"]
            }
        } else if(infanthivstatus === "Positive"){ 
            return {
                hide:["Infant Received ARV Prophylaxis at Birth","Infant's Risk Status","High Risk Infant Classification","ARV Baby Discharged with","Infant's Final Status"],
                show:["Infants ART Number(For Confimed Positive Infants)","Infant's Final Status(Positive infants)"]
        }
        } else {
            return {
                hide:["Infant Received ARV Prophylaxis at Birth","Infant's Risk Status","High Risk Infant Classification","ARV Baby Discharged with","Infant's Final Status","Infants ART Number(For Confimed Positive Infants)","Infant's Final Status(Positive infants)"]
                
            }  
        }
    },
    "Infant's Risk Status" : function (formName , formFieldValues){
        var infantriskstatus = formFieldValues["Infant's Risk Status"];
        if(infantriskstatus === "High Risk Infant") {
            return {             
               show:["High Risk Infant Classification"]
            }
        } else {
            return {
                hide:["High Risk Infant Classification"]
                
            }  
        }
    },
    "Maternity card, Mother tested in Maternity" : function (formName , formFieldValues){
        var mothertestedinmaternity = formFieldValues["Maternity card, Mother tested in Maternity"];
        if(mothertestedinmaternity == true) {
            return {             
               show:["Maternity card, Date tested in Maternity","Maternity card, Status After Testing HIV"]
            }
        } else {
            return {
                hide:["Maternity card, Date tested in Maternity","Maternity card, Status After Testing HIV"]
                
            }  
        }
    },
    "End of Follow up,Patient Outcome" : function (formName , formFieldValues){
        var patientOutcome = formFieldValues["End of Follow up,Patient Outcome"];
        if(patientOutcome === "Self transfer(Silent Transfer)") {
            return {             
               show:["Self Transfer Date"]
            }
        } else {
            return {
                hide:["Self Transfer Date"]
                
            }  
        }
    },
    "EDD" : function (formName , formFieldValues){
        var edd = formFieldValues["EDD"];
        var edddate = new Date(edd);
        var today = new Date();  
        if (edddate < today) {
            alert("EDD should be a date in the Future");
            
        }
    },
    "Post Natal ,Place Delivery" : function (formName , formFieldValues){
        var plannedplaceofdilivery = formFieldValues["Post Natal ,Place Delivery"];
        if(plannedplaceofdilivery === "Place Delivered, Other facility") {
            return{
                show: ["Place Delivered, specify"]
            }
        }else {
            return{
                hide: ["Place Delivered, specify"]
            }
        }    
    },
    "Abortion" : function (formName , formFieldValues){
        var abortion = formFieldValues["Abortion"];
        if(abortion == true) {
            return{
                hide: ["Gestation(Weeks)","Place of Delivery","Mode Of Delivery","Sex Of Baby","Outcome Of Foetus","Antepartum haemorrhage (APH)","PPH"]
            }
        }else {
            return{
                show: ["Gestation(Weeks)","Place of Delivery","Mode Of Delivery","Sex Of Baby","Outcome Of Foetus","Antepartum haemorrhage (APH)","PPH"]
            }
        }    
    },
    "ANC, HIV Test Result" : function (formName , formFieldValues){
        var hivtest = formFieldValues["ANC, HIV Test Result"];
        if((hivtest === "Positive") || (hivtest === "Negative")) {
            return{
                show:["ANC, HIV Test Date"]
            }
        }else {
            return{
                hide:["ANC, HIV Test Date"]
                
            }
        }    
    },
    "RPR/VDRL" : function (formName , formFieldValues){
        var rprvdrl = formFieldValues["RPR/VDRL"];
        if((rprvdrl === "Positive") || (rprvdrl === "Negative")) {
            return{
                show:["RPR/VDRL Test Date"]
            }
        }else {
            return{
                hide:["RPR/VDRL Test Date"]
                
            }
        }    
    },
    "HB Test" : function (formName , formFieldValues){
        var hbtest = formFieldValues["HB Test"];
        if(hbtest == true) {
            return{
                show:["HB"]
            }
        }else {
            return{
                hide:["HB"]
                
            }
        }    
    },
 };

