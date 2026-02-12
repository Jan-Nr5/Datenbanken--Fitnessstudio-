-- =========================
-- PERSONEN
-- =========================
INSERT INTO person (vorname, nachname, geburtsdatum, email, telefon, strasse, hausnr, plz, ort, land)
VALUES
('Max', 'Mustermann', '1999-01-01', 'max@example.de', '012345678910', 'Beispielstrasse', '01', '12345', 'Duesseldorf', 'DE'),
('Henrik', 'Schmidt', '1998-08-21', 'h.schmidt@example.de', '015176543210', 'Ringstrasse', '22', '12344', 'Krefeld', 'DE'),
('Tom', 'Trainer', '1985-03-05', 'tom.trainer@example.de', '015199988877', 'Wegstrasse', '3', '50672', 'Koeln', 'DE'),
('Anna', 'Coach', '1990-11-15', 'anna.coach@example.de', '015144455566', 'Fitnessallee', '8', '50674', 'Koeln', 'DE'),
('Fritz', 'Hanssen', '1989-01-01', 'fri@example.de', '012345678911', 'Hanssenallee', '07', '54321', 'Berlin', 'DE'),
('Aleman', 'Alemania', '2008-08-21', 'ger@example.de', '015126543210', 'Ostwall', '22', '47829', 'Krefeld', 'DE'),
('Mark', 'TerStegen', '1912-03-05', 'pilot@example.de', '015122288877', 'Sportweg', '3', '50672', 'Koeln', 'DE'),
('Anke', 'Coach', '1990-11-15', 'anke.coach@example.de', '015144455567', 'Fitnessallee', '8', '50674', 'Koeln', 'DE');

-- =========================
-- MITGLIEDER & MITARBEITER
-- =========================
INSERT INTO mitglied VALUES (1), (2), (5), (6), (7);

INSERT INTO mitarbeiter VALUES (3), (4), (8);

-- =========================
-- ROLLEN
-- =========================
INSERT INTO rolle (rollenbezeichnung)
VALUES ('Trainer'), ('Kursleiter');

INSERT INTO mitarbeiter_rolle VALUES
(3,1),
(4,2),
(8,1);

-- =========================
-- QUALIFIKATIONEN
-- =========================
INSERT INTO qualifikation (bezeichnung)
VALUES ('Yoga Lizenz'), ('Spinning Lizenz'), ('Personal Trainer');

INSERT INTO mitarbeiter_qualifikation VALUES
(3,2),
(3,3),
(4,1),
(4,3),
(8,3),
(8,2);

-- =========================
-- RÄUME
-- =========================
INSERT INTO raum (bezeichnung, kapazitaet)
VALUES
('Yoga Raum', 15),
('Spinning Raum', 12),
('Kraftbereich', 30),
('Cardiobereich', 10);

-- =========================
-- KURSE
-- =========================
INSERT INTO kurs (kurstitel)
VALUES
('Morning Yoga'),
('Spinning Power'),
('Freies Training');

INSERT INTO kurs_qualifikation VALUES
(1,1),
(2,2),
(3,3);

-- =========================
-- TERMINE
-- =========================
INSERT INTO termin (kurs_id, mitarbeiter_id, raum_id, startzeit, endzeit)
VALUES
(1,4,1,'2026-03-01 09:00:00','2026-03-01 10:00:00'),
(2,3,2,'2026-03-01 18:00:00','2026-03-01 19:00:00'),
(2,8,2,'2026-03-01 12:00:00','2026-03-01 13:00:00'),
(3,8,3,'2026-03-01 05:00:00','2026-03-01 11:00:00'),
(3,4,3,'2026-03-01 11:00:00','2026-03-01 20:00:00'),
(3,3,3,'2026-03-01 20:00:00','2026-03-01 23:00:00');

-- =========================
-- TARIFE
-- =========================
INSERT INTO mitgliedschaft_tarif (bezeichnung)
VALUES
('Basic'),
('Premium');

INSERT INTO tarif_kurs VALUES
(1,1),
(2,2);

-- =========================
-- MITGLIEDSCHAFTEN
-- =========================
INSERT INTO mitgliedschaft (mitglied_id, tarif_id, startdatum, enddatum, status)
VALUES
(1,2,'2026-01-01',NULL,'aktiv'),
(2,1,'2026-02-01',NULL,'aktiv'),
(5,2,'2006-06-07',NULL,'aktiv');

INSERT INTO mitgliedschaft (mitglied_id, tarif_id)
VALUES
(6,1),
(7,2);

-- =========================
-- ZAHLUNGEN
-- =========================
INSERT INTO zahlung (mitglied_id, mitgliedschaft_id, betrag, zahlungsdatum)
VALUES
(5,3,49.99,'2026-02-01'),
(6,4,29.99,'2026-02-01'),
(7,5,49.99,'2026-02-01'),
(1,1,49.99,'2026-02-01'),
(2,2,29.99,'2026-03-01');

-- =========================
-- BUCHUNGEN
-- =========================
INSERT INTO termin_teilnahme (termin_id, mitglied_id, status, buchungszeitpunkt)
VALUES
(1,5,'besucht','2026-02-25 10:00:00'),
(1,6,'storniert','2026-02-26 09:00:00'),
(1,7,'gebucht','2026-02-27 12:00:00'),
(2,5,'gebucht','2026-02-25 11:00:00'),
(2,6,'besucht','2026-02-25 12:00:00'),
(2,7,'nicht besucht','2026-02-25 13:00:00'),
(3,1,'besucht','2026-02-20 10:00:00'),
(3,2,'gebucht','2026-02-20 12:00:00');

INSERT INTO termin_teilnahme (termin_id, mitglied_id, buchungszeitpunkt)
VALUES
(3,5,'2026-02-21 14:00:00'),
(4,1,'2026-02-20 09:00:00'),
(4,6,'2026-02-21 11:00:00'),
(5,2,'2026-02-21 12:00:00'),
(5,7,'2026-02-21 13:00:00');

-- =========================
-- CHECKINS
-- =========================
INSERT INTO checkin (mitglied_id, termin_id, checkin_zeit, checkout_zeit)
VALUES
(5,1,'2026-03-01 08:52:00','2026-03-01 10:03:00'),
(6,2,'2026-03-01 17:54:00','2026-03-01 19:02:00'),
(1,3,'2026-03-01 11:53:00','2026-03-01 13:01:00'),
(1,4,'2026-03-01 05:05:00','2026-03-01 10:45:00'),
(6,4,'2026-03-01 06:15:00','2026-03-01 09:50:00'),
(2,5,'2026-03-01 11:10:00','2026-03-01 15:10:00'),
(7,5,'2026-03-01 12:20:00','2026-03-01 16:45:00'),
(5,4,'2026-03-01 07:30:00','2026-03-01 09:30:00'),
(6,5,'2026-03-01 13:40:00','2026-03-01 18:10:00');
