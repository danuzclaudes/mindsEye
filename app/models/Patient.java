package models;

import com.avaje.ebean.Model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Patient extends Model {
    @Id
    @Column(name="patient_id")
    public int patientId;
    @Column(name="patient_age", columnDefinition = "integer")
    public int patientAge;
    @Column(name="patient_sex", columnDefinition = "char(1)")
    public char patientSex;
    @Column(name="patient_race", columnDefinition = "char(1)")
    public char patientRace;
    @Column(name="patient_primary_diagnosis", columnDefinition = "varchar(256) not null")
    public String patientPrimaryDiagnosis;
    @Column(name="patient_secondary_diagnosis", columnDefinition = "varchar(256)")
    public String patientSecondaryDiagnosis;
    @Column(name="days_since_last_visit", columnDefinition = "integer default 0")
    public int  daysSinceLastVisit;

    public Patient(int id, int age, char sex, char race,
                   String primaryDiagnosis,
                   String secondaryDiagnosis){
        this.patientId = id;
        this.patientAge = age;
        this.patientSex = sex;
        this.patientRace = race;
        this.patientPrimaryDiagnosis =   primaryDiagnosis;
        this.patientSecondaryDiagnosis = secondaryDiagnosis;
        this.daysSinceLastVisit = 0;
    }

    public static Finder<Integer, Patient> find = new Finder<Integer, Patient>(
        Integer.class, Patient.class
    );

    public static Patient create(int id, int age, char sex, char race,
                                 String primary, String secondary){
        Patient patient = new Patient(id, age, sex, race, primary, secondary);
        patient.save();
        return patient;
    }
}
