import org.joda.time.DateTime;
import org.joda.time.Days;
import java.util.Date;
import org.openmrs.module.bahmniemrapi.drugogram.contract.TreatmentRegimenExtension;
import org.openmrs.module.bahmniemrapi.drugogram.contract.RegimenRow;
import org.openmrs.module.bahmniemrapi.drugogram.contract.TreatmentRegimen;

public class MonthCalculationExtension implements TreatmentRegimenExtension {
	@Override
	public void update(TreatmentRegimen treatmentRegimen) {
		Date treatmentStartDate = treatmentRegimen.getRows().first().getDate();
		for (RegimenRow regimenRow : treatmentRegimen.getRows()) {
			DateTime currentTreatmentDate = new DateTime(regimenRow.getDate());
			Days days = Days.daysBetween(new DateTime(treatmentStartDate), currentTreatmentDate);
			String month = String.format("%.1f", days.getDays()/30.0F);
			regimenRow.setMonth(month);
		}
	}
}