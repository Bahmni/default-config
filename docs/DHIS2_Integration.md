
# Bahmni - DHIS2 Integration

## Install and configure DHIS2 integration app
Assuming you have Bahmni installer latest version installed and running successfully. (Tested with 0.89 version, should work with previous version as well)

1. Run the following command to install DHIS2 integration app.
    >  yum install https://s3.ap-south-1.amazonaws.com/possible-artifacts/dhis-integration-1.0-1.noarch.rpm

2. Update the properties file for DHIS2 integration app, located at '/etc/dhis-integration/dhis-integration.yml', with right configuration.

|Key | Description |Example
|:---|:--------|:---|
|openmrs.root.url |Url to access Openmrs service|http://localhost:8050/openmrs/ws/rest/v1|
|bahmni.login.url|When user isn't logged in, then user is redirected to this url.| https://ehr.possible.org/bahmni/home/#/login?showLoginMessage|
|reports.url|Bahmni reports url. Used for downloading reports.|https://ehr.possible.org/bahmnireports/report|
|reports.json|This file contains configurations of DHIS2 reports.|/var/www/bahmni_config/openmrs/apps/reports/reports.json|
|dhis.config.directory|This folder contains DHIS2 integration configurations program wise.|	/var/www/bahmni_config/dhis2/ |
|dhis.url|The DHIS2 government server instance url.|Ex. 1: http://100.100.100.100:8080/<br/>Ex. 2: http://200.100.20.30:8888/hmistest/<br/>Note that the url could be at domain or ip address level (ex1) or could be at a specific path(ex2)|
|dhis.user|The username to access DHIS2 instance.|username|
|dhis.password|The password for the DHIS2 user.	|password|
|openmrs.db.url|Mysql connection url to access "openmrs" database. Set valid user and password in the url.| jdbc:mysql://localhost/openmrs?user=openmrs-user&password=password|
|submission.audit.folder|All DHIS2 submissions are stored in this directory. Ensure the directory exists and "bahmni" user has access to it, or configure a different directory.|	/dhis-integration-data|
|server.port|Server config. Port for server to listen to.| 8040|
|server.context-path|Server config. Mapping incoming requests.|/dhis-integration/|
|log4j.config.file|Server config. Properties file for logger of dhis-integration server.|log4j.properties|


3. Download and place the ssl.conf file.
    > cd /etc/httpd/conf.d/

    > wget https://raw.githubusercontent.com/Possiblehealth/possible-config/89662e8e823fac3dbcaf111aa72713a63139bb03/playbooks/roles/possible-dhis-integration/templates/dhis_integration_ssl.conf

4. Configure Bahmni landing page to show DHIS2 integration app.
  Insert the following in "/var/www/bahmni_config/openmrs/apps/home/extension.json" file

   ```javascript
     "possible_dhis_2_integration": {
     "id": "possible.dhis2Integration",
     "extensionPointId": "org.bahmni.home.dashboard",
     "type": "link",
     "label": "DHIS2 integration",
     "url": "/dhis-integration/index.html",
     "icon": "fa-book",
     "order": 11,
     "requiredPrivilege": "app:reports"
   }
    ```

5. Ensure Bahmni reports service is installed and running successfully.
   > service bahmni-reports status ##should be running

6. Restart ssl and dhis-integration services.
   > service httpd restart 
   
   > service dhis-integration restart

Now the DHIS2 integration app is available on landing screen, given that the user has reporting privileges.
![DHIS-ICON](https://github.com/Possiblehealth/possible-config/blob/master/attachments/dhis_on_dashbord.png)

Once you open the app you land on DHIS integration app page, where you select the month and year for given program, type a comment and submit report.

![DHIS_REPORT_LIST](https://github.com/Possiblehealth/possible-config/blob/master/attachments/dhil_report_list.png)
                     

## Configure New Program 
1. Configure the [concatenated reports ](https://bahmni.atlassian.net/wiki/display/BAH/Reports#Reports-6.ConcatenatingMultipleReports) for the program
2. Put the following configuration in the concatenated report to make it DHIS2 program.
   > "DHISProgram": true,

Example: [Safe motherhood program](https://github.com/Possiblehealth/possible-config/blob/8228d24730d854fa282ee04f16ec3d598e86909c/openmrs/apps/reports/reports.json#L1780-L1782)

3. Create a DHIS configuration file for the program with the name of program under '/var/www/bahmni_config/dhis2/' folder.
To use different folder change 'dhis.config.directory' configuration at '/etc/dhis-integration/dhis-integration.yml'.
4. DHIS configuratioile should have the following structure.
DHIS Config
    ``` javascript

        {
          "orgUnit": "<orgUnitId | find it from DHIS instance>",
          "reports": {
            "<name of 1st sub report | find it from reports.json>": {
              "dataValues": [
                {
                  "categoryOptionCombo": "<category option combination id | find it from DHIS instance>",
                  "dataElement": "<data element id | find it from DHIS instance>",
                  "row": <row number of the cell | find it from output of the SQL report>,
                  "column": <column number of the cell | find it from output of the SQL report>
                },
                {
                  "categoryOptionCombo": "<category option combination id | find it from DHIS instance>",
                  "dataElement": "<data element id | find it from DHIS instance>",
                  "row": <row number of the cell | find it from output of the SQL report>,
                  "column": <column number of the cell | find it from output of the SQL report>
                },
                ............more data element mappings............
              ]
            },
            "<name of 2nd sub report | find it from reports.json>": {
        	  "dataValues": [......]
            },
            "<name of 3rd sub report | find it from reports.json>": {
        	  "dataValues": [......]
            },
            ............more sub report mappings............
          }
        }
    ```
5. An example configuration for Safe Motherhood program will look like the following
![DHIS-CONFIG](https://github.com/Possiblehealth/possible-config/blob/master/attachments/dhis_config.png)

6. Example: [Safe motherhood program](https://github.com/Possiblehealth/possible-config/blob/8228d24730d854fa282ee04f16ec3d598e86909c/openmrs/apps/reports/reports.json#L1780-L1782)

|Key|Description|
|:--|:--|
|orgUnit|This is the organisation unit ID from DHIS |
|reports|This is list of reports which are the inner reports of concatenated report of the program. Each report name is a unique key in this object.
'Antenatal Checkup' is one of the inner reports configured in concatenated report, for example.|
|dataValues |This is list of data element mappings. Each mapping maps a cell in SQL output to a dataElement in DHIS.|
|categoryOptionCombo|This is the 'category option combination id' of the dataElement in DHIS.|
|dataElement|This is the 'data element id' of the dataElement in DHIS.|
|row and column	|This 'row and column' numbers refers to a particular cell in the output of configured SQL.|

 **Notes:** To find out the orgUnit Id, dataElement Id, category option combo Id do the following:
1. Access the DHIS2 government server in your browser.
2. Open data entry apps and select appropriate organisation and location.
3. Once the data entry forms are visible, click on the input boxes where you enter the data.
4. Right click on the input box and select "Inspect" from the options.
5. Copy the Id of the html element from window (See image), it would look like the following string: "kSnqP4GPOsQ-kdsirVNKdhm-val".
6. This string is in the format of "dataElementId - categoryOptionComboId - ...."
7. These dataElementId and categoryOptionComboId need to be used in DHIS2 configuration file. Refer the below image.


![](https://github.com/Possiblehealth/possible-config/blob/master/attachments/DHIS%20.gif)


![DHIS-ARCITECTURE](https://github.com/Possiblehealth/possible-config/blob/master/attachments/dhis_architecture.png)




