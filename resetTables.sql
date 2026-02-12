SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM checkin;
DELETE FROM termin_teilnahme;
DELETE FROM zahlung;
DELETE FROM mitgliedschaft;
DELETE FROM termin;
DELETE FROM mitarbeiter_rolle;
DELETE FROM mitarbeiter_qualifikation;
DELETE FROM kurs_qualifikation;
DELETE FROM tarif_kurs;
DELETE FROM mitglied;
DELETE FROM mitarbeiter;
DELETE FROM kurs;
DELETE FROM raum;
DELETE FROM rolle;
DELETE FROM qualifikation;
DELETE FROM mitgliedschaft_tarif;
DELETE FROM person;

SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE person AUTO_INCREMENT = 1;
ALTER TABLE kurs AUTO_INCREMENT = 1;
ALTER TABLE termin AUTO_INCREMENT = 1;
ALTER TABLE checkin AUTO_INCREMENT = 1;
ALTER TABLE mitgliedschaft AUTO_INCREMENT = 1;
ALTER TABLE zahlung AUTO_INCREMENT = 1;
ALTER TABLE rolle AUTO_INCREMENT = 1;
ALTER TABLE qualifikation AUTO_INCREMENT = 1;
ALTER TABLE raum AUTO_INCREMENT = 1;
ALTER TABLE mitgliedschaft_tarif AUTO_INCREMENT = 1;
