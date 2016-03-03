import models.Medication;
import models.Visit;
import org.junit.*;
import static org.junit.Assert.*;

import play.Logger;
import play.test.WithApplication;

import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import static play.test.Helpers.*;

/**
 * JUnit test case for Model
 */
public class ModelsTest extends WithApplication{

    private DateFormat df = new SimpleDateFormat("M/dd/yyyy", Locale.US);
    private final Logger.ALogger logger = Logger.of("test");
    private MessageDigest md = null;

    @Before  // run before each test
    public void setUp() {
        // start a fake application, and cleans up after each test has run;
        // configure this application to use a new in-memory database
        start(fakeApplication(inMemoryDatabase()));
        logger.debug("Model tests start");
    }

    @Test
    public void createVisit() throws Exception{
        md = MessageDigest.getInstance("MD5");
        md.update(new Date().toString().getBytes());
        // logger.debug("md5 id is" + md.digest());
        // logger.debug("parse date object: " + df.parse("1/12/2011").toString());
        new Visit(md.digest().toString(), df.parse("1/12/2011"), 7, "This is visit 1", 15).save();
        Visit v = Visit.find.where().eq("visitDate", new Date("1/12/2011")).findUnique();
        assertNotNull("Test if the visit record can be found:", v);
        assertEquals(7, v.cgiScore);
    }

    @Test
    public void testFindMedsByVisit() throws Exception {
        Date d1 = df.parse("1/12/2011"), d2 = df.parse("3/9/2011");
        md = MessageDigest.getInstance("MD5");

        md.update(d1.toString().getBytes()); String id1 = md.digest().toString();
        md.update(d2.toString().getBytes()); String id2 = md.digest().toString();
        Visit v1 = new Visit(id1, d1, 7, "This is visit 1", 15);
        Visit v2 = new Visit(id2, d2, 7, "This is visit 2", 15);
        // BZ: must explicitly save by initiated objects or by constructor new (...).save()
        v1.save(); v2.save();

        // The states of created medication will be saved in create() function
        Medication.create("BUPR", df.parse("1/12/2011"), null, "BUP", id1);
        Medication.create("CITA", df.parse("1/12/2011"), null, "SSRI", v1.visitId);
        Medication m1 = Medication.find.where().eq("medName", "BUPR").findUnique();
        Medication m2 = Medication.find.where().eq("medName", "CITA").findUnique();

        assertNotNull(m1.prescribed_on_visit);
        assertNotNull(m2.prescribed_on_visit);
        assertEquals("Test if M1 is prescribed by visit 1", m1.prescribed_on_visit.visitId, v1.visitId);
        assertEquals("Test if M2 is prescribed by visit 1", m2.prescribed_on_visit.visitId, v1.visitId);

        List<Medication> meds1 = Medication.findMedsByVisit(v1.visitId);
        assertEquals("Test if the two medications have been prescribed:", 2, meds1.size());
        assertEquals("Test if the drug group is 'BUP':", "BUP", meds1.get(0).medGroup);
        assertEquals("Test if the drug name is 'CITA':", "CITA", meds1.get(1).medName);

        m2.medEndDate = df.parse("3/9/2011");
        m2.prescribed_on_visit = v2;
        // BZ: must save the sates of objects into database
        m2.save();

        List<Medication> meds2 = Medication.findMedsByVisit(v2.visitId);
        assertEquals("Test if the drug m2 has been prescribed:", 1, meds2.size());
        assertEquals("Test if the drug name if 'CITA':", "CITA", meds2.get(0).medName);
        assertEquals("Test if the end date of m2 has been set:", df.parse("3/9/2011"), meds2.get(0).medEndDate);

        logger.debug("Medications by visit1: " + meds1);
        logger.debug("Medications by visit1: " + meds2);
    }
}
