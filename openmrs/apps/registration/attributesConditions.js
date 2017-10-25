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
    },
    'force': function(patient) {
        return showOrHideGradoSection(patient);
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

var showOrHideGradoSection = function (patient) {
    var returnValues = {
        show: [],
        hide: []
    };

    var patientAttribute = patient["force"];
    if(patientAttribute){
        if (patientAttribute.conceptUuid === "6a5ed660-284a-4369-b986-76dae3e95b4b")
        {
            returnValues = hideShowGrado(patient, returnValues, "gradoFuerzaEjercito");
        }
        else if (patientAttribute.conceptUuid === "ba54570b-ee77-43b9-9a15-9ce175f84022")
        {
            returnValues = hideShowGrado(patient, returnValues, "gradoFuerzaNaval");
        }
        else if (patientAttribute.conceptUuid === "d99b2f70-ad6a-4c76-87fe-a824e90c27e6")
        {
            returnValues = hideShowGrado(patient, returnValues, "gradoFuerzaAerea");
        }
        else if (patientAttribute.conceptUuid === "f8ad6a17-9b17-4c66-8089-a0f15dfe2c2f")
        {
            returnValues = hideShowGrado(patient, returnValues, "gradoPoliciaNacional");
        }
        else if (patientAttribute.conceptUuid === "a7d26ea3-f686-4e3a-9b9a-7998b8998e03")
        {        
            returnValues = hideShowGrado(patient, returnValues, "gradoDireccionNacionalInvestigacion");
        }
    }else {
        returnValues = hideShowGrado(patient, returnValues, "");
        
    }

    return returnValues;
}; 

var hideShowGrado = function(patient, returnValues, branchUsed) {
    var allGradoSections = ['gradoFuerzaEjercito', 'gradoFuerzaAerea', 'gradoPoliciaNacional', 'gradoDireccionNacionalInvestigacion', 'gradoFuerzaNaval'];

    var selectedGrado = allGradoSections.indexOf(branchUsed);
    if (selectedGrado >= 0) {
        allGradoSections.splice(selectedGrado, 1);
    }
    returnValues.hide = allGradoSections;
    if (branchUsed !== "") {
        returnValues.show.push(branchUsed);
    }

    return returnValues;
}