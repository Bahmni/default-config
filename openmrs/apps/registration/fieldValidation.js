Bahmni.Registration.customValidator = {
    "address.address1": {
        method: function (name, value, personAttributeDetails) {
            return _.first(_.toString(value)) != 0;
        },
        errorMessage: "REGISTRATION_WARD_NUMBER_ERROR_KEY"
    }
};