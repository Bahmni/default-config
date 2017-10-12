Bahmni.Registration.customValidator = {
    "age.days": {
        method: function (name, value) {
            return value >= 0;
        },
        errorMessage: "REGISTRATION_AGE_ERROR_KEY"
    },
    "Telephone Number": {
        method: function (name, value, personAttributeDetails) {
            return value && value.length> 6;
        },
        errorMessage: "REGISTRATION_TELEPHONE_NUMBER_ERROR_KEY"
    },
    "caste": {
        method: function (name, value, personAttributeDetails) {
            return value.match(/^\w+$/);
        },
        errorMessage: "REGISTRATION_CASTE_TEXT_ERROR_KEY"
    },
    "primaryIdentifier.identifier":{   
        method: function(name,value){
            return value.match(/RE[0-9]{15}|ID[0-9]{13}|PA[0-9]+/)
         },
         errorMessage : "El campo documento de Identificacion no cumple el formato adecuado"
      }
};
