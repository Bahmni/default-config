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
                        return value.match(/^\+?\(?([0-9]{3})\)?[-. ]?([0-9]{4})[-. ]?([0-9]{4})$/);
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
                },
                "residenceWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.length <= 50;
                    },
                    errorMessage: "REGISTRATION_RESIDENCE_WORK_TEXT_ERROR_KEY"
                },
                "houseNoWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.length <= 50;
                    },
                    errorMessage: "REGISTRATION_HOUSE_NUMBER_WORK_TEXT_ERROR_KEY"
                },
                "streetWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.length <= 50;
                    },
                    errorMessage: "REGISTRATION_STREET_NUMBER_WORK_TEXT_ERROR_KEY"
                },
                "blockWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.length <= 50;
                    },
                    errorMessage: "REGISTRATION_BLOCK_NUMBER_WORK_TEXT_ERROR_KEY"
                },
                "cityWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.length <= 50;
                    },
                    errorMessage: "REGISTRATION_CITY_WORK_TEXT_ERROR_KEY"
                },
                "municipalityWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.length <= 50;
                    },
                    errorMessage: "REGISTRATION_MUNICIPALITY_WORK_TEXT_ERROR_KEY"
                },
                "departmentWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.length <= 50;
                    },
                    errorMessage: "REGISTRATION_DEPARTMENT_WORK_TEXT_ERROR_KEY"
                },
                "countryWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.length <= 50;
                    },
                    errorMessage: "REGISTRATION_COUNTRY_WORK_TEXT_ERROR_KEY"
                },
                "addressWork": {
                    method: function (name, value, personAttributeDetails) {
                        return value.length <= 50;
                    },
                    errorMessage: "REGISTRATION_ADDRESS_WORK_TEXT_ERROR_KEY"
                },
                "latitude": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^-?\d*\.?\d+$/);
                    },
                    errorMessage: "REGISTRATION_ADDRESS_WORK_LATITUDE_TEXT_ERROR_KEY"
                },
                "longitude": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^-?\d*\.?\d+$/);
                    },
                    errorMessage: "REGISTRATION_ADDRESS_WORK_LONGITUDE_TEXT_ERROR_KEY"
                },
                "emergencyContactFirstName": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_EMERGENCY_CONTACT_FIRST_NAME_TEXT_KEY"
                },
                "emergencyContactSecondName": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_EMERGENCY_CONTACT_SECOND_NAME_TEXT_KEY"
                },
                "emergencyContactFirstLastname": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_EMERGENCY_CONTACT_FIRST_LAST_NAME_TEXT_KEY"
                },
                "emergencyContactSecondLastname": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_EMERGENCY_CONTACT_SECOND_LAST_NAME_TEXT_KEY"
                },
                "emergencyContactPhone1": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage:"REGISTRATION_PHONE1_EMERGENCY_CONTACT_TEXT_KEY"
                },
                "emergencyContactPhone2": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage:"REGISTRATION_PHONE2_EMERGENCY_CONTACT_TEXT_KEY"
                },
                "emergencyContactPhone3": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage:"REGISTRATION_PHONE3_EMERGENCY_CONTACT_TEXT_KEY"
                },"emergencyContactEmail": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-Z0-9_.+-]{3,244}@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,5}$/);
                    },
                    errorMessage: "REGISTRATION_EMAIL_EMERGENCY_CONTACT_TEXT_ERROR_KEY"
                },
                "secundaryEmergencyContactFirstName": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_SECUNDARY_EMERGENCY_CONTACT_FIRST_NAME_TEXT_KEY"
                },
                "secundaryEmergencyContactSecondName": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_SECUNDARY_EMERGENCY_CONTACT_SECOND_NAME_TEXT_KEY"
                },
                "secundaryEmergencyContactFirstLastname": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_SECUNDARY_EMERGENCY_CONTACT_FIRST_LAST_NAME_TEXT_KEY"
                },
                "secundaryEmergencyContactSecondLastname": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_SECUNDARY_EMERGENCY_CONTACT_SECOND_LAST_NAME_TEXT_KEY"
                },
                "secundaryEmergencyContactPhone1": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage:"REGISTRATION_SECUNDARY_PHONE1_EMERGENCY_CONTACT_TEXT_KEY"
                },
                "secundaryEmergencyContactPhone2": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage:"REGISTRATION_SECUNDARY_PHONE2_EMERGENCY_CONTACT_TEXT_KEY"
                },
                "secundaryEmergencyContactPhone3": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage:"REGISTRATION_SECUNDARY_PHONE3_EMERGENCY_CONTACT_TEXT_KEY"
                },"secundaryEmergencyContactEmail": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-Z0-9_.+-]{3,244}@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,5}$/);
                    },
                    errorMessage: "REGISTRATION_SECUNDARY_EMAIL_EMERGENCY_CONTACT_TEXT_ERROR_KEY"
                },
                "thirdEmergencyContactPhone1": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage:"REGISTRATION_THIRD_PHONE1_EMERGENCY_CONTACT_TEXT_KEY"
                },
                "thirdEmergencyContactPhone2": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage:"REGISTRATION_THIRD_PHONE2_EMERGENCY_CONTACT_TEXT_KEY"
                },
                "thirdEmergencyContactPhone3": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[0-9]{4}-[0-9]{4}$/);
                    },
                    errorMessage:"REGISTRATION_THIRD_PHONE3_EMERGENCY_CONTACT_TEXT_KEY"
                },"thirdEmergencyContactEmail": {
                    method: function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-Z0-9_.+-]{3,244}@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,5}$/);
                    },
                    errorMessage: "REGISTRATION_THIRD_EMAIL_EMERGENCY_CONTACT_TEXT_ERROR_KEY"
                },
                "thirdEmergencyContactFirstName": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_THIRD_EMERGENCY_CONTACT_FIRST_NAME_TEXT_KEY"
                },
                "thirdEmergencyContactSecondName": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_THIRD_EMERGENCY_CONTACT_SECOND_NAME_TEXT_KEY"
                },
                "thirdEmergencyContactFirstLastname": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_THIRD_EMERGENCY_CONTACT_FIRST_LAST_NAME_TEXT_KEY"
                },
                "thirdEmergencyContactSecondLastname": {
                    method:  function (name, value, personAttributeDetails) {
                        return value.match(/^[a-zA-ZÁÉÍÓÚ\u00E0-\u00FC\s]{2,60}$/);
                    },
                    errorMessage:"REGISTRATION_NAME_THIRD_EMERGENCY_CONTACT_SECOND_LAST_NAME_TEXT_KEY"
                }
            };
        }
        
        return true;
    },
    'force': function(patient) {
        return showOrHideGradoSection(patient);
    },
    'retiredPatient': function(patient) {
        return hideSections(patient);
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
            patient['force'] = {};
            patient['gradoFuerzaEjercito'] = {};
            patient['unidadFuerzaEjercito'] = {};
            patient['gradoFuerzaNaval'] = {};
            patient['unidadFuerzaNaval'] = {};
            patient['gradoFuerzaAerea'] = {};
            patient['unidadFuerzaAerea'] = {};
            patient['gradoPoliciaNacional'] = {};
            patient['unidadPoliciaNacional'] = {};
            patient['gradoDireccionNacionalInvestigacion'] = {};
            patient['unidadDNI'] = {};
            patient['gradoSecretariaDefensaNacional'] = {};
            patient['unidadSecretariaDefensaNacional'] = {};
            patient['gradoDependenciasFFAA'] = {};
            patient['unidadDependenciasFFAA'] = {};
            patient['retiredPatient'] = false;
            patient['auxiliaryOfficer'] = false;
            hideAll(returnValues);
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
            returnValues = hideShowGrado(patient, returnValues, "gradoFuerzaEjercito", "unidadFuerzaEjercito");
        }
        else if (patientAttribute.conceptUuid === "ba54570b-ee77-43b9-9a15-9ce175f84022")
        {
            returnValues = hideShowGrado(patient, returnValues, "gradoFuerzaNaval", "unidadFuerzaNaval");
        }
        else if (patientAttribute.conceptUuid === "d99b2f70-ad6a-4c76-87fe-a824e90c27e6")
        {
            returnValues = hideShowGrado(patient, returnValues, "gradoFuerzaAerea", "unidadFuerzaAerea");
        }
        else if (patientAttribute.conceptUuid === "f8ad6a17-9b17-4c66-8089-a0f15dfe2c2f")
        {
            returnValues = hideShowGrado(patient, returnValues, "gradoPoliciaNacional", "unidadPoliciaNacional");
        }
        else if (patientAttribute.conceptUuid === "a7d26ea3-f686-4e3a-9b9a-7998b8998e03")
        {        
            returnValues = hideShowGrado(patient, returnValues, "gradoDireccionNacionalInvestigacion", "unidadDNI");
        }
        else if (patientAttribute.conceptUuid === "d771e63e-7ff1-47cd-b2df-98739d6e6118")
        {
            returnValues = hideShowGrado(patient, returnValues, "gradoSecretariaDefensaNacional", "unidadSecretariaDefensaNacional");
        }
        else if (patientAttribute.conceptUuid === "66de2a62-0e27-4375-91b1-057dad32a1ce")
        {
            returnValues = hideShowGrado(patient, returnValues, "gradoDependenciasFFAA", "unidadDependenciasFFAA");
        }
    } else {
        returnValues = hideShowGrado(patient, returnValues, "");
    }

    return returnValues;
}; 

var hideShowGrado = function(patient, returnValues, branchUsed, unitUsed) {
    var allGradoSections = ['gradoFuerzaEjercito', 'gradoFuerzaAerea', 'gradoPoliciaNacional', 'gradoDireccionNacionalInvestigacion', 'gradoFuerzaNaval', 'gradoSecretariaDefensaNacional', 'gradoDependenciasFFAA'];

    var allUnitSection = ['unidadFuerzaEjercito', 'unidadFuerzaAerea', 'unidadPoliciaNacional', 'unidadDNI', 'unidadFuerzaNaval', 'unidadSecretariaDefensaNacional', 'unidadDependenciasFFAA'];

    var selectedGrado = allGradoSections.indexOf(branchUsed);
    var selectedUnit = allUnitSection.indexOf(unitUsed);
    if (selectedGrado >= 0) {
        allGradoSections.splice(selectedGrado, 1);
    }
    if (selectedUnit >= 0) {
        allUnitSection.splice(selectedUnit, 1);
    }

    var branchUnit = [];
    if (branchUsed !== "" && unitUsed !== "") {
        branchUnit.push(branchUsed);
        branchUnit.push(unitUsed);
        returnValues.show = branchUnit;     
    }

    var allSectionsBranch = allGradoSections.concat(allUnitSection);
    returnValues.hide = allSectionsBranch;

    return returnValues;
};

var hideAll = function(returnValues){
    var allGradoSections = ['gradoFuerzaEjercito', 'gradoFuerzaAerea', 'gradoPoliciaNacional', 'gradoDireccionNacionalInvestigacion', 'gradoFuerzaNaval', 'gradoSecretariaDefensaNacional', 'gradoDependenciasFFAA'];
    
    var allUnitSection = ['unidadFuerzaEjercito', 'unidadFuerzaAerea', 'unidadPoliciaNacional', 'unidadDNI', 'unidadFuerzaNaval', 'unidadSecretariaDefensaNacional', 'unidadDependenciasFFAA'];

    var allSectionsBranch = allGradoSections.concat(allUnitSection);
    returnValues.hide = allSectionsBranch;

    return returnValues;
};

var hideSections = function (patient) {
    var returnValues = {
        show: [],
        hide: []
    };

    var retiredPatient = patient["retiredPatient"];
    var force = patient["force"];

    if(retiredPatient){
        var checkbox = document.getElementById("retiredPatient");
        checkbox.addEventListener( 'change', function() {
            if(this.checked) {
                document.getElementById("auxiliaryOfficer").disabled = true;
                document.getElementById("force").disabled = true;
                if (force.conceptUuid === "6a5ed660-284a-4369-b986-76dae3e95b4b") {
                    document.getElementById("gradoFuerzaEjercito").disabled = true;
                    document.getElementById("unidadFuerzaEjercito").disabled = true;
                } else if (force.conceptUuid === "ba54570b-ee77-43b9-9a15-9ce175f84022") {
                    document.getElementById("gradoFuerzaNaval").disabled = true;
                    document.getElementById("unidadFuerzaNaval").disabled = true;
                } else if (force.conceptUuid === "d99b2f70-ad6a-4c76-87fe-a824e90c27e6") {
                    document.getElementById("gradoFuerzaAerea").disabled = true;
                    document.getElementById("unidadFuerzaAerea").disabled = true;
                } else if (force.conceptUuid === "f8ad6a17-9b17-4c66-8089-a0f15dfe2c2f")
                {
                    document.getElementById("gradoPoliciaNacional").disabled = true;
                    document.getElementById("unidadPoliciaNacional").disabled = true;
                } else if (force.conceptUuid === "a7d26ea3-f686-4e3a-9b9a-7998b8998e03")
                {        
                    document.getElementById("gradoDireccionNacionalInvestigacion").disabled = true;
                    document.getElementById("unidadDNI").disabled = true;
                } else if (force.conceptUuid === "d771e63e-7ff1-47cd-b2df-98739d6e6118")
                {
                    document.getElementById("gradoSecretariaDefensaNacional").disabled = true;
                    document.getElementById("unidadSecretariaDefensaNacional").disabled = true;
                } else if (force.conceptUuid === "66de2a62-0e27-4375-91b1-057dad32a1ce")
                {
                    document.getElementById("gradoDependenciasFFAA").disabled = true;
                    document.getElementById("unidadDependenciasFFAA").disabled = true;
                }
            } else {
                document.getElementById("auxiliaryOfficer").disabled = false;
                document.getElementById("force").disabled = false;
                if (force.conceptUuid === "6a5ed660-284a-4369-b986-76dae3e95b4b") {
                    document.getElementById("gradoFuerzaEjercito").disabled = false;
                    document.getElementById("unidadFuerzaEjercito").disabled = false;
                } else if (force.conceptUuid === "ba54570b-ee77-43b9-9a15-9ce175f84022") {
                    document.getElementById("gradoFuerzaNaval").disabled = false;
                    document.getElementById("unidadFuerzaNaval").disabled = false;
                } else if (force.conceptUuid === "d99b2f70-ad6a-4c76-87fe-a824e90c27e6") {
                    document.getElementById("gradoFuerzaAerea").disabled = false;
                    document.getElementById("unidadFuerzaAerea").disabled = false;
                } else if (force.conceptUuid === "f8ad6a17-9b17-4c66-8089-a0f15dfe2c2f")
                {
                    document.getElementById("gradoPoliciaNacional").disabled = false;
                    document.getElementById("unidadPoliciaNacional").disabled = false;
                } else if (force.conceptUuid === "a7d26ea3-f686-4e3a-9b9a-7998b8998e03")
                {        
                    document.getElementById("gradoDireccionNacionalInvestigacion").disabled = false;
                    document.getElementById("unidadDNI").disabled = false;
                } else if (force.conceptUuid === "d771e63e-7ff1-47cd-b2df-98739d6e6118")
                {
                    document.getElementById("gradoSecretariaDefensaNacional").disabled = false;
                    document.getElementById("unidadSecretariaDefensaNacional").disabled = false;
                } else if (force.conceptUuid === "66de2a62-0e27-4375-91b1-057dad32a1ce")
                {
                    document.getElementById("gradoDependenciasFFAA").disabled = false;
                    document.getElementById("unidadDependenciasFFAA").disabled = false;
                }
            }
        });
    }
    
    return returnValues;
};