## Default Bahmni configuration and data. 
======================================================================

#### Deploy
- under server (apache) www directory
- alias root (default-config) to bahmni_config


#### Dev commands
* `./scripts/vagrant-link.sh` to link default_config to vagrants /var/www/bahmni_config
* `./scripts/vagrant-database.sh` to run liquibase migrations in vagrant 


#### CI Deployment
The `default-config.zip` is created on the CI Server as part of the **Bahmni_MRS_Master** pipeline (*FunctionalTests* job). You can download the latest ZIP from this URL:

Latest Builds: [Download Link](https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Master/Latest/BuildStage/Latest/FunctionalTests/deployables/) 


```
Replace the {Build_Number} variable in the link:

https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Master/{Build_Number}/BuildStage/Latest/FunctionalTests/deployables/
```

## Docker Image Build
The docker image bahmni/default-config is generated using Github Actions. 

In order to build the image in local you can run the following command
```shell
docker build -t bahmni/default-config -f package/docker/Dockerfile .
```

To dockerise your implementation specific config repository, follow the steps below:
1. Copy the package/docker directory to your repository
2. Add/ remove COPY statements in Dockerfile based on the needs.
3. Run the following command after updating image repository and image name.
    > docker build -t {repository}/{image-name} -f package/docker/Dockerfile .
4. Also you can add Github Actions from `.github/workflows` directory.

## Configurations 
 
 1) Clinical app.json: example -  (Details in comments)

```javascript

 "config" : {
    "otherInvestigationsMap": {
        "Radiology": "Radiology Order",
        "Endoscopy": "Endoscopy Order"
    },
    "conceptSetUI": {   // all configs for conceptSet added here
        "XCodedConcept": {  // name of the concept
            "autocomplete": true,  // if set to true, it will show autocomplete instead of dropdown for coded concept answers.
            "showAbnormalIndicator": true   //If set to true, will show a checkbox for capturing abnormal observation.
        },
        "Text Complaints": {    //name of the concept
            "freeTextAutocomplete": {   //if present, will show a textbox, with autocomplete for concept name.
                "conceptSetName": "VITALS_CONCEPT",  // autocomplete will search for concepts which are membersOf this conceptSet (Optional)
                "codedConceptName": "Complaints"     // autocomplete will search for concepts which are answersTo this codedConcept (Optional)
            }
        }
    }
}

```
2) Registration app.json: example -  (Details in comments)

```javascript

"config" : {
  "autoCompleteFields":["familyName", "caste"],
  "defaultIdentifierPrefix": "GAN",
  "searchByIdForwardUrl": "/patient/{{patientUuid}}?visitType=OPD - RETURNING",
  "conceptSetUI": {
      "temparature": {
          "showAbnormalIndicator": true
      }
  },
  "registrationConceptSet":"",
  "showMiddleName": false,
  "hideFields": ["Height", "Weight", "BMI", "BMI_Status"],  //the fields on screen which should NOT be shown
  "registrationCardPrintLayout": "/bahmni_config/openmrs/apps/registration/registrationCardLayout/print.html",
  "localNameSearch": true,                       // registration search displays parameter for search by local name
  "localNameLabel": "मरीज़ का नाम",                // label to be diplyed for local name search input
  "localNamePlaceholder": "मरीज़ का नाम",          // placeholder to be diplyed for local name search input
  "localNameAttributes": ["givenNameLocal", "familyNameLocal"]  //patient attributes to be search against for local name search
}

```