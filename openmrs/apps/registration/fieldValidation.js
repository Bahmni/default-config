Bahmni.Registration.customValidator = {
    "address.address1": {
        method: function (name, value, personAttributeDetails) {
            return _.first(_.toString(value)) != 0;
        },
        errorMessage: "REGISTRATION_WARD_NUMBER_ERROR_KEY"
    },
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
    }
};
