import org.apache.commons.lang.StringUtils
import org.bahmni.module.bahmnicore.service.impl.BahmniBridge
import org.joda.time.LocalDate
import org.joda.time.Months
import org.openmrs.Patient
import org.openmrs.api.context.Context
import org.openmrs.module.bahmniemrapi.encountertransaction.contract.BahmniEncounterTransaction
import org.openmrs.module.bahmniemrapi.encountertransaction.contract.BahmniObservation
import org.openmrs.module.bahmniemrapi.obscalculator.ObsValueCalculator
import org.openmrs.module.emrapi.encounter.domain.EncounterTransaction
import org.openmrs.util.OpenmrsUtil

public class BahmniObsValueCalculator implements ObsValueCalculator {
    static Double BMI_VERY_SEVERELY_UNDERWEIGHT = 16.0;
    static Double BMI_SEVERELY_UNDERWEIGHT = 17.0;
    static Double BMI_UNDERWEIGHT = 18.5;
    static Double BMI_NORMAL = 25.0;
    static Double BMI_OVERWEIGHT = 30.0;
    static Double BMI_OBESE = 35.0;
    static Double BMI_SEVERELY_OBESE = 40.0;
    static BahmniBridge bahmniBridge = BahmniBridge.create();
    static def file1 = new File("/tmp/groovy_debug.txt")

    public static enum BmiStatus {
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
        file1.append "IN run"
        List<String> bmiConceptNames = Arrays.asList("SV, Poids", "SV, Taille", "SV, Indice de masse corporelle (IMC)");
        Map<String, BahmniObservation> bahmniObsConceptMap = new HashMap<>();
        findObsForConceptsOfForm(bmiConceptNames, bahmniEncounterTransaction.getObservations(),"Signes vitaux", bahmniObsConceptMap);
        calculateBMI(bahmniEncounterTransaction, bahmniObsConceptMap);
    }

    private
    static void calculateBMI(BahmniEncounterTransaction bahmniEncounterTransaction, Map<String, BahmniObservation> bahmniObsConceptMap) {
        BahmniObservation heightObservation
        BahmniObservation weightObservation

        for (entry in bahmniObsConceptMap) {
            if (('SV, Taille').equalsIgnoreCase(entry.key))
                heightObservation = entry.value;

            if (('SV, Poids').equalsIgnoreCase(entry.key))
                weightObservation = entry.value;
        }

        if (heightObservation == null && weightObservation == null) {
            BahmniObservation bmiObservation = bahmniObsConceptMap.get("SV, Indice de masse corporelle (IMC)")
            BahmniObservation bmiAbnormalObservation = bahmniObsConceptMap.get("BMI Abnormal")
            voidObs(bmiObservation);
            voidObs(bmiAbnormalObservation);
        }

        calculateBMIWithHeightAndWeight(bahmniEncounterTransaction, heightObservation, weightObservation, bahmniObsConceptMap);
    }

    static
    def calculateBMIWithHeightAndWeight(BahmniEncounterTransaction bahmniEncounterTransaction, BahmniObservation heightObservation, BahmniObservation weightObservation, Map<String, BahmniObservation> bahmniObsConceptMap) {
        def nowAsOfEncounter = bahmniEncounterTransaction.getEncounterDateTime() != null ? bahmniEncounterTransaction.getEncounterDateTime() : new Date();

        if (hasValue(heightObservation) || hasValue(weightObservation)) {
            BahmniObservation bmiObservation = bahmniObsConceptMap.get("SV, Indice de masse corporelle (IMC)")
            BahmniObservation bmiAbnormalObservation = bahmniObsConceptMap.get("BMI Abnormal")

            Patient patient = Context.getPatientService().getPatientByUuid(bahmniEncounterTransaction.getPatientUuid())
            def patientAgeInMonthsAsOfEncounter = Months.monthsBetween(new LocalDate(patient.getBirthdate()), new LocalDate(nowAsOfEncounter)).getMonths()

            Double height = hasValue(heightObservation) ? heightObservation.getValue() as Double: null
            Double weight = hasValue(weightObservation) ? weightObservation.getValue() as Double : null
            Date obsDatetime = getDate(weightObservation) != null ? getDate(weightObservation) : getDate(heightObservation)

            if (height == null || weight == null) {
                voidObs(bmiObservation)
                voidObs(bmiAbnormalObservation)
                return
            }

            if(hasValue(heightObservation) && hasValue(weightObservation)){
                String heightFormFieldPath = heightObservation.getFormFieldPath() /*If Height or weight is not filled*/
                String heightFormNameSpace = heightObservation.getFormNamespace() /*If Height or weight is not filled*/
                def bmi = bmi(height, weight)
                bmiObservation = bmiObservation ?: createObs("SV, Indice de masse corporelle (IMC)", bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
                Double roundOffBMI = Math.round(bmi * 100.0) / 100.0;
                bmiObservation.setValue(roundOffBMI);
                bmiObservation.setFormFieldPath(heightFormFieldPath.substring(0, heightFormFieldPath.indexOf("/"))+"/4-0")
                bmiObservation.setFormNamespace(heightFormNameSpace)

                def bmiStatus = bmiStatus(bmi, patientAgeInMonthsAsOfEncounter, patient.getGender());

                def bmiAbnormal = bmiAbnormal(bmiStatus);

                // // if (bmiAbnormal)
                // //     bmiObservation.setInterpretation("ABNORMAL")
                // else
                //     bmiObservation.setInterpretation(null)
            }

        }
    }

    private static Date getDate(BahmniObservation observation) {
        return hasValue(observation) && !observation.voided ? observation.getObservationDateTime() : null;
    }

    private static boolean hasValue(BahmniObservation observation) {
        return observation != null && observation.getValue() != null && !StringUtils.isEmpty(observation.getValue().toString());
    }

    private static void voidObs(BahmniObservation bmiObservation) {
        if (hasValue(bmiObservation)) {
            bmiObservation.voided = true
        }
    }

    static BahmniObservation createObs(String conceptName, BahmniEncounterTransaction encounterTransaction, Date obsDatetime) {
        def concept = bahmniBridge.getConceptByFullySpecifiedName(conceptName)
        BahmniObservation newObservation = new BahmniObservation()
        newObservation.setConcept(new EncounterTransaction.Concept(concept.getUuid(), conceptName))
        newObservation.setObservationDateTime(obsDatetime);
        encounterTransaction.addObservation(newObservation)
        return newObservation
    }

    static def bmi(Double height, Double weight) {
        Double heightInMeters = height / 100;
        file1.append 'height '+ height +'\n'
        file1.append 'weight '+ weight +'\n'
        file1.append 'heightInMeters '+ heightInMeters +'\n'
        Double value = weight / (heightInMeters * heightInMeters);
        file1.append 'value '+ value +'\n'
        return new BigDecimal(value).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
    };

    static def bmiStatus(Double bmi, Integer ageInMonth, String gender) {
        BMIChart bmiChart = readCSV(OpenmrsUtil.getApplicationDataDirectory() + "obscalculator/BMI_chart.csv");
        def bmiChartLine = bmiChart.get(gender, ageInMonth);
        if (bmiChartLine != null) {
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
    }

    static def bmiAbnormal(BmiStatus status) {
        return status != BmiStatus.NORMAL;
    };

    static void findObsForConceptsOfForm(List<String> conceptNames, Collection<BahmniObservation> observations, String templatename, Map<String, BahmniObservation> bahmniObsConceptMap) {
        for (BahmniObservation observation : observations) {

            if (conceptNames.contains(observation.getConcept().getName()) &&
                    !observation.getVoided() &&
                    observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf(".")).equals(templatename))
            {
                bahmniObsConceptMap.put(observation.getConcept().getName(), observation);
            }
        }
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

        public BmiStatus getStatus(Double bmi) {
            if (bmi < third) {
                return BmiStatus.SEVERELY_UNDERWEIGHT
            } else if (bmi < fifteenth) {
                return BmiStatus.UNDERWEIGHT
            } else if (bmi < eightyFifth) {
                return BmiStatus.NORMAL
            } else if (bmi < ninetySeventh) {
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
