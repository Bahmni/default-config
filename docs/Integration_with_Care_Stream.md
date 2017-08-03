Integration with Care-Stream
---
<details>
<summary>On this page</summary>

- [Some Useful terms](#some-useful-terms)
- [Carestream](#carestream)
- [ImageSuite](#imagesuite)
- [Modality](#modality)
- [DICOM](#dicom)
- [Study](#study)
- [Work List](#work-list)
- [PACS](#pacs)
- [Order Creation Flow](#order-creation-flow)
- [DICOM View Flow](#dicom-view-flow)
</details>


```markdown
This does not include the detailed steps for Integration of Bahmni with Care-Stream. Below are some brief steps.
```

### Some Useful terms:
#### Carestream: 
It is a third party product that is used for X-Ray image processing and management.
#### ImageSuite:
It is an image acquisition and management for CR and DR Systems.
#### Modality:
Modality, a Method of diagnosis. In medical imaging, any of the various types of equipment or probes used to acquire images of the body, such as radiography, ultrasound and magnetic resonance imaging.
#### DICOM:
Digital Imaging and Communications in Medicine (DICOM) is a standard for handling, storing, printing, and transmitting information in medical imaging.
#### Study:
 A study comprises a set of series, each of which includes a set of Service-Object Pair Instances (SOP Instances - images or other data) acquired or produced in a common context. A series is of only one modality (e.g. X-ray, CT, MR, ultrasound), but a study may have multiple series of different modalities.
#### Work List:
Modality worklist is responsible for managing/scheduling new tasks and also provides means to get the list of scheduled tasks (via DICOM).
#### PACS:
A picture archiving and communication system (PACS) is a medical imaging technology which provides economical storage and convenient access to images from multiple modalities (source machine types)
### Order Creation Flow
  1. Setup Orders Tab with Radiology Section (Grouping: Body Parts->X-Rays) : (Follow Bahmni WIKI for more details on Orders 
and Concepts). There is an import file that can be used to import the concepts of X-Rays.

[Organs_Group_concept_sets.csv](https://github.com/Possiblehealth/possible-config/blob/master/attachments/Organs_Group_concept_sets.csv)

[X-ray_concepts.csv](https://github.com/Possiblehealth/possible-config/blob/master/attachments/X-ray_concepts.csv)
  
2. Configure Procedure Codes on ImageSuite under ImageSuite->System Settings->Procedures referring to 
[PACS_Procedure_Codes_Reference_Terms.csv](https://github.com/Possiblehealth/possible-config/blob/master/attachments/PACS_Procedure_Codes_Reference_Terms.csv)

<img alt="CareStreamImageSuite.png" src="https://github.com/Possiblehealth/possible-config/blob/master/attachments/CareStreamImageSuite.png" width=300 hight=200/>

  3. HL7 Message Mapping needs to be done on ImageSuite Service Configuration->HL7 Settings- Import xml file Or manually 
configure on ImageSuite HL7 Interface. (HL7Message_Xpath_Bahmni.xml).[HL7Message_XPath_Bahmni.xml](https://github.com/Possiblehealth/possible-config/blob/master/attachments/HL7Message_XPath_Bahmni.xml)

**Note :** If you are writing rules for the first time you need to follow the below screenshots. [HL7Message_XPath_Bahmni.xml](https://github.com/Possiblehealth/possible-config/blob/master/attachments/HL7Message_XPath_Bahmni.xml)
 file given above already has the rules written so you don't need to manually write the rules. Importing this .xml file should work.
SC 1

<img alt="HL7ImageSuiteInterfaceHL7Config.png" src="https://github.com/Possiblehealth/possible-config/blob/master/attachments/HL7ImageSuiteInterfaceHL7Config.png" width=300 hight=200/>  <img alt="HL7ImageSuiteInterfaceDataMapping.png" src="https://github.com/Possiblehealth/possible-config/blob/master/attachments/HL7ImageSuiteInterfaceDataMapping.png" width=300 hight=200/>

<img alt="XPathRule.png" src="https://github.com/Possiblehealth/possible-config/blob/master/attachments/XPathRule.png" width=300 hight=200/>


<img alt="image10.png" src="https://github.com/Possiblehealth/possible-config/blob/master/attachments/image10.png" width=300 hight=200/>  <img alt="XPathRule2.png" src="https://github.com/Possiblehealth/possible-config/blob/master/attachments/XPathRule2.png" width=300 hight=200/>

  4. Configure Bahmni PACS Integration Server(IP, Port) Details on ImageSuite.
<img alt="image9.png" src="https://github.com/Possiblehealth/possible-config/blob/master/attachments/image9.png" width=300 hight=200/>

                    
### DICOM View Flow
 1. Install DCM4CHEE with embedded Oviyam2.
 2. Check Java Version used by JBOSS to be Oracle JRE 7.
 3. Configure DCM4CHEE as Other PACS on ImageSuite->Service Configuration->Other PACS.

<img alt="DICOMViewFlow1.png" src="https://github.com/Possiblehealth/possible-config/blob/master/attachments/DICOMViewFlow1.png" width=500 hight=500/>

 4. Configure ImageSuite DICOM Details on DCM4CHEE->Application Entities.

<img alt="DICOMViewFlow2.png" src="https://github.com/Possiblehealth/possible-config/blob/master/attachments/DICOMViewFlow2.png" width=900 hight=500/>



