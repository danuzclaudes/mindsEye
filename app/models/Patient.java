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
    @Column(name="days_since_last_visit", columnDefinition = "integer default 0")
    public int  daysSinceLastVisit;

    public Patient(int id, int age, char sex, char race){
        this.patientId = id;
        this.patientAge = age;
        this.patientSex = sex;
        this.patientRace = race;
        this.daysSinceLastVisit = 0;
    }

    public static Finder<Integer, Patient> find = new Finder<Integer, Patient>(
        Integer.class, Patient.class
    );

    public static Patient create(int id, int age, char sex, char race){
        Patient patient = new Patient(id, age, sex, race);
        patient.save();
        return patient;
    }
}
