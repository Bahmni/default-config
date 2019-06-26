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
    "FATHER_NAME" : {
        method: function (name, value, personAttributeDetails) {
            var regexCharacters = "^[a-záàãâéèêẽíìóòõôúùçA-ZÁÀÃÂÉÈÊẼÍÌÓÒÔÕÚÙÇ ]+$";
            return value.match(regexCharacters);
        },
        errorMessage: "REGISTRATION_INVALID_FATHER_NAME_FIELD"
    },
    "MOTHER_NAME" : {
        method: function (name, value, personAttributeDetails) {
            var regexCharacters = "^[a-záàãâéèêẽíìóòõôúùçA-ZÁÀÃÂÉÈÊẼÍÌÓÒÔÕÚÙÇ ]+$";
            return value.match(regexCharacters);
        },
        errorMessage: "REGISTRATION_INVALID_MOTHER_NAME_FIELD"
    },
    "middleName" : {
        method: function (name, value, personAttributeDetails) {
            var regexCharacters = "[a-záàãâéèêẽíìóòõôúùçA-ZÁÀÃÂÉÈÊẼÍÌÓÒÔÕÚÙÇ ]*";
            return value.match(regexCharacters);
        },
        errorMessage: "REGISTRATION_INVALID_MOTHER_NAME_FIELD"
    }
};
