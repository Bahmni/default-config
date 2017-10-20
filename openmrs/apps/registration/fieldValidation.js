Bahmni.Registration.customValidator = {
    "age.days": {
        method: function (name, value) {
            return value >= 0;
        },
        errorMessage: "REGISTRATION_AGE_ERROR_KEY"
    },
    "cellphone": {
        method: function (name, value, personAttributeDetails) {
            return value.match(/\(?([0-9]{3})\)?([ .-]?)([0-9]{4})-([0-9]{4})/);
        },
        errorMessage: "REGISTRATION_CELLPHONE_TEXT_ERROR_KEY"
    },
    "telephoneHouse": {
        method: function (name, value, personAttributeDetails) {
            return value.match(/[0-9]{4}-[0-9]{4}/);
        },
        errorMessage: "REGISTRATION_TELEPHONE_TEXT_ERROR_KEY"
    },
    "telephoneWork": {
        method: function (name, value, personAttributeDetails) {
            return value.match(/[0-9]{4}-[0-9]{4}/);
        },
        errorMessage: "REGISTRATION_TELEPHONE_TEXT_ERROR_KEY"
    },
    "emailPersonal": {
        method: function (name, value, personAttributeDetails) {
            return value.match(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/);
        },
        errorMessage: "REGISTRATION_EMAIL_TEXT_ERROR_KEY"
    },
    "emailWork": {
        method: function (name, value, personAttributeDetails) {
            return value.match(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/);
        },
        errorMessage: "REGISTRATION_EMAIL_TEXT_ERROR_KEY"
    }
};
