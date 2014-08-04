import org.hibernate.Query
import org.hibernate.SessionFactory
import org.openmrs.Obs
import org.openmrs.Patient;
import org.openmrs.util.OpenmrsUtil;
import org.openmrs.api.context.Context
import org.openmrs.module.bahmniemrapi.obscalculator.ObsValueCalculator;
import org.openmrs.module.bahmniemrapi.encountertransaction.contract.BahmniEncounterTransaction
import org.openmrs.module.emrapi.encounter.domain.EncounterTransaction;

import org.joda.time.LocalDate;
import org.joda.time.Months;

public class BahmniObsValueCalculator implements ObsValueCalculator {

    static int BMI_VERY_SEVERELY_UNDERWEIGHT = 16;
    static int BMI_SEVERELY_UNDERWEIGHT = 17;
    static int BMI_UNDERWEIGHT = 18.5;
    static int BMI_NORMAL = 25;
    static int BMI_OVERWEIGHT = 30;
    static int BMI_OBESE = 35;
    static int BMI_SEVERELY_OBESE = 40;

    public enum BmiStatus {
        VERY_SEVERELY_UNDERWEIGHT("Very Severely Underweight"),
        SEVERELY_UNDERWEIGHT("Severely Underweight"),
        UNDERWEIGHT("Underweight"),
        NORMAL("Normal"),
        OVERWEIGHT("Overweight"),
        OBESE("Obese"),
        SEVERELY_OBESE("Severely Obese"),
        VERY_SEVERELY_OBESE("Very Severely Obese");

        private String status;

        BmiStatus(String status) {
            this.status = status
        }

        @Override
        public String toString() {
            return status;
        }
    }


    public void run(BahmniEncounterTransaction bahmniEncounterTransaction) {
        setBMI(bahmniEncounterTransaction);
    }

    static def setBMI(BahmniEncounterTransaction bahmniEncounterTransaction) {
        List<EncounterTransaction.Observation> observations = bahmniEncounterTransaction.getObservations()

        EncounterTransaction.Observation nutritionLevelsObservation = find("Nutritional Levels", observations)
        EncounterTransaction.Observation heightObservation = find("HEIGHT", observations)
        EncounterTransaction.Observation weightObservation = find("WEIGHT", observations)
        EncounterTransaction.Observation bmiObservation = find("BMI", observations)
        EncounterTransaction.Observation bmiStatusObservation = find("BMI STATUS", observations)
        Patient patient = Context.getPatientService().getPatientByUuid(bahmniEncounterTransaction.getPatientUuid());
        def patientAgeInMonths = Months.monthsBetween(new LocalDate(patient.getBirthdate()), new LocalDate()).getMonths();

        if (heightObservation || weightObservation) {

            if ((heightObservation && heightObservation.voided) && (weightObservation && weightObservation.voided)) {
                voidBmiObs(bmiObservation, bmiStatusObservation)
                return
            }

            def previousHeightValue = fetchLatestValue("HEIGHT", bahmniEncounterTransaction.getPatientUuid(), heightObservation)
            def previousWeightValue = fetchLatestValue("WEIGHT", bahmniEncounterTransaction.getPatientUuid(), weightObservation)

            Double height = heightObservation != null && !heightObservation.voided ? heightObservation.getValue() as Double : previousHeightValue
            Double weight = weightObservation != null && !weightObservation.voided ? weightObservation.getValue() as Double : previousWeightValue

            if (height == null || weight == null) {
                voidBmiObs(bmiObservation, bmiStatusObservation)
                return
            }

            def bmi = bmi(height, weight)
            bmiObservation = bmiObservation ?: createObs("BMI", nutritionLevelsObservation) as EncounterTransaction.Observation;
            bmiObservation.setValue(bmi);
            bmiObservation.setComment([height: height, weight: weight, bmi: bmi].toString())

            def bmiStatus = bmiStatus(bmi, patientAgeInMonths, patient.getGender());
            bmiStatusObservation = bmiStatusObservation ?: createObs("BMI STATUS", nutritionLevelsObservation) as EncounterTransaction.Observation;
            bmiStatusObservation.setValue(bmiStatus);
            bmiStatusObservation.setComment([height: height, weight: weight, bmi: bmi, bmiStatus: bmiStatus].toString())
        }
    }

    private
    static void voidBmiObs(EncounterTransaction.Observation bmiObservation, EncounterTransaction.Observation bmiStatusObservation) {
        if (bmiObservation) {
            bmiObservation.voided = true
        }
        if (bmiStatusObservation) {
            bmiStatusObservation.voided = true
        }
    }

    static EncounterTransaction.Observation createObs(String conceptName, EncounterTransaction.Observation parent) {
        def concept = Context.getConceptService().getConceptByName(conceptName)
        EncounterTransaction.Observation newObservation = new EncounterTransaction.Observation()
        newObservation.setConcept(new EncounterTransaction.Concept(concept.getUuid(), conceptName))

        parent.addGroupMember(newObservation);
        return newObservation
    }

    static def bmi(Double height, Double weight) {
        Double heightInMeters = height / 100;
        Double value = weight / (heightInMeters * heightInMeters);
        return new BigDecimal(value).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
    };

    static def bmiStatus(Double bmi, Integer ageInMonth, String gender) {
        BMIChart bmiChart = readCSV(OpenmrsUtil.getApplicationDataDirectory() + "obscalculator/BMI_chart.csv");
        def bmiChartLine = bmiChart.get(gender, ageInMonth);
        if(bmiChartLine != null ) {
            return bmiChartLine.getStatus(bmi);
        }

        if (bmi < BMI_VERY_SEVERELY_UNDERWEIGHT) {
            return BmiStatus.VERY_SEVERELY_UNDERWEIGHT;
        }
        if (bmi < BMI_SEVERELY_UNDERWEIGHT) {
            return BmiStatus.SEVERELY_UNDERWEIGHT;
        }
        if (bmi < BMI_UNDERWEIGHT) {
            return BmiStatus.UNDERWEIGHT;
        }
        if (bmi < BMI_NORMAL) {
            return BmiStatus.NORMAL;
        }
        if (bmi < BMI_OVERWEIGHT) {
            return BmiStatus.OVERWEIGHT;
        }
        if (bmi < BMI_OBESE) {
            return BmiStatus.OBESE;
        }
        if (bmi < BMI_SEVERELY_OBESE) {
            return BmiStatus.SEVERELY_OBESE;
        }
        if (bmi >= BMI_SEVERELY_OBESE) {
            return BmiStatus.VERY_SEVERELY_OBESE;
        }
        return null
    };

    static Double fetchLatestValue(String conceptName, String patientUuid, EncounterTransaction.Observation excludeObs) {
        SessionFactory sessionFactory = Context.getRegisteredComponents(SessionFactory.class).get(0)
        def excludedObsIsSaved = excludeObs != null && excludeObs.uuid != null
        String excludeObsClause = excludedObsIsSaved ? " and obs.uuid != :excludeObsUuid" : ""
        Query queryToGetObservations = sessionFactory.getCurrentSession()
                .createQuery("select obs " +
                " from Obs as obs, ConceptName as cn " +
                " where obs.person.uuid = :patientUuid " +
                " and cn.concept = obs.concept.conceptId " +
                " and cn.name = :conceptName " +
                " and obs.voided = false" +
                excludeObsClause +
                " order by obs.obsDatetime desc limit 1");
        queryToGetObservations.setString("patientUuid", patientUuid);
        queryToGetObservations.setParameterList("conceptName", conceptName);
        if (excludedObsIsSaved) {
            queryToGetObservations.setString("excludeObsUuid", excludeObs.uuid)
        }
        List<Obs> observations = queryToGetObservations.list();
        if (observations.size() > 0) {
            return observations.get(0).getValueNumeric();
        }
        return null
    }

    static EncounterTransaction.Observation find(def conceptName, List<EncounterTransaction.Observation> observations) {
        for (EncounterTransaction.Observation observation : observations) {
            if (conceptName.equals(observation.getConcept().getName())) {
                return observation;
            }
            EncounterTransaction.Observation matchingObservation = find(conceptName, observation.getGroupMembers())
            if (matchingObservation) return matchingObservation;
        }
        return null
    }

    static BMIChart readCSV(String fileName) {
        def chart = new BMIChart();
        try {
            new File(fileName).withReader { reader ->
                def header = reader.readLine();
                reader.splitEachLine(",") { tokens ->
                    chart.add(new BMIChartLine(tokens[0], tokens[1], tokens[2], tokens[3], tokens[4], tokens[5]));
                }
            }
        } catch (FileNotFoundException e) {
        }
        return chart;
    }

    static class BMIChartLine {
        public String gender;
        public Integer ageInMonth;
        public Double third;
        public Double fifteenth;
        public Double eightyFifth;
        public Double ninetySeventh;

        BMIChartLine(String gender, String ageInMonth, String third, String fifteenth, String eightyFifth, String ninetySeventh) {
            this.gender = gender
            this.ageInMonth = ageInMonth.toInteger();
            this.third = third.toDouble();
            this.fifteenth = fifteenth.toDouble();
            this.eightyFifth = eightyFifth.toDouble();
            this.ninetySeventh = ninetySeventh.toDouble();
        }

        public String getStatus(Double bmi) {
            if(bmi < third) {
                return BmiStatus.SEVERELY_UNDERWEIGHT
            } else if(bmi < fifteenth) {
                return BmiStatus.UNDERWEIGHT
            } else if(bmi < eightyFifth) {
                return BmiStatus.NORMAL
            } else if(bmi < ninetySeventh) {
                return BmiStatus.OVERWEIGHT
            } else {
                return BmiStatus.OBESE
            }
        }
    }

    static class BMIChart {
        List<BMIChartLine> lines;
        Map<BMIChartLineKey, BMIChartLine> map = new HashMap<BMIChartLineKey, BMIChartLine>();

        public add(BMIChartLine line) {
            def key = new BMIChartLineKey(line.gender, line.ageInMonth);
            map.put(key, line);
        }

        public BMIChartLine get(String gender, Integer ageInMonth) {
            def key = new BMIChartLineKey(gender, ageInMonth);
            return map.get(key);
        }
    }

    static class BMIChartLineKey {
        public String gender;
        public Integer ageInMonth;

        BMIChartLineKey(String gender, Integer ageInMonth) {
            this.gender = gender
            this.ageInMonth = ageInMonth
        }

        boolean equals(o) {
            if (this.is(o)) return true
            if (getClass() != o.class) return false

            BMIChartLineKey bmiKey = (BMIChartLineKey) o

            if (ageInMonth != bmiKey.ageInMonth) return false
            if (gender != bmiKey.gender) return false

            return true
        }

        int hashCode() {
            int result
            result = (gender != null ? gender.hashCode() : 0)
            result = 31 * result + (ageInMonth != null ? ageInMonth.hashCode() : 0)
            return result
        }
    }
}