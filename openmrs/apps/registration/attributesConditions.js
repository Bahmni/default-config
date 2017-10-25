Bahmni.Registration.AttributesConditions.rules = {
    'patientType': function(patient) {
        return showOrHideServiceInfoSection(patient);
    },
    'identifierDocument': function(patient) {
        if (patient['identifierDocument']) {
            var regex, error_msg = "";
            switch (patient['identifierDocument'].conceptUuid) {
                case "c74c7f3b-954f-41e1-ba26-b595906020b5":
                    regex = /^[0-9]{13}$/;
                    error_msg = "REGISTRATION_ID_TEXT_ERROR_KEY";
                    break;
                
                case "dafa2194-f468-4b6e-9b3f-97fbb181de55":
                    regex = /^[0-9]{15}$/;
                    error_msg = "REGISTRATION_RESIDENCE_TEXT_ERROR_KEY";
                    break;
            
                default:
                    regex = /[a-zA-Z\-0-9]+/;
                    error_msg = "REGISTRATION_PASSPORT_TEXT_ERROR_KEY";
                    break;
            }
            
            Bahmni.Registration.customValidator = {
                "primaryIdentifier.registrationNumber": {
                    method: function (name, value) {
                        return value.match(regex);
                    },
                    errorMessage: error_msg
                },
                "cellphone": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^\+?([0-9]{3})\)?[-. ]?([0-9]{4})[-. ]?([0-9]{4})$/);
                    },
                    errorMessage: "REGISTRATION_CELLPHONE_TEXT_ERROR_KEY"
                },
                "telephoneHouse": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage: "REGISTRATION_TELEPHONE_HOUSE_TEXT_ERROR_KEY"
                },
                "telephoneWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage: "REGISTRATION_TELEPHONE_WORK_TEXT_ERROR_KEY"
                },
                "emailPersonal": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-Z0-9_.+-]{3,244}@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,5}$/);
                    },
                    errorMessage: "REGISTRATION_EMAIL_PERSONAL_TEXT_ERROR_KEY"
                },
                "emailWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-Z0-9_.+-]{3,244}@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,5}$/);
                    },
                    errorMessage: "REGISTRATION_EMAIL_WORK_TEXT_ERROR_KEY"
                }
            };
        }
        
        return true;
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