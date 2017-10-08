Bahmni.Registration.AttributesConditions.rules = {
    'patientType': function(patient) {
        return showOrHideServiceInfoSection(patient);
    }
};

var showOrHideServiceInfoSection = function (patient) {
    var returnValues = {
        show: [],
        hide: []
    };
    
    var patientAttribute = patient["patientType"];
    if(patientAttribute){
        if (patientAttribute.conceptUuid === "ab73372f-0148-4f1d-b91b-d4a45dc94117") {
            returnValues.show.push("serviceInfo");
        } else {
            returnValues.hide.push("serviceInfo");
        }
    }else {
        returnValues.hide.push("serviceInfo");
    }
    return returnValues;
};