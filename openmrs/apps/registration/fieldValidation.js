validate_age_days = {
    'method': function (name, value) {
        if (value >= 0) {
            return true;
        }
        return false;
    },
    'errorMessage': "Age should be a possitive value"
};

validate_caste = {
    'method': function (name, value, config) {
        return true;
    },
    'errorMessage': "No Caste"
};

validate_education = {
    'method': function (name, value, config) {
        return true;
    },
    'errorMessage': "No Education details given"
};
