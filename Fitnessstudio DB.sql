CREATE TABLE `person` (
  `person_id` int PRIMARY KEY AUTO_INCREMENT,
  `vorname` varchar(100) NOT NULL,
  `nachname` varchar(100) NOT NULL,
  `geburtsdatum` date,
  `email` varchar(254)  NOT NULL,
  `telefon` varchar(20),
  `strasse` varchar(120),
  `hausnr` varchar(10),
  `plz` char(5),
  `ort` varchar(100),
  `land` char(52),

  CONSTRAINT check_person_plz
    CHECK (plz IS NULL OR plz REGEXP '^[0-9]{5}$')
);

CREATE TABLE `mitglied` (
  `mitglied_id` int PRIMARY KEY
);

CREATE TABLE `mitarbeiter` (
  `mitarbeiter_id` int PRIMARY KEY
);

CREATE TABLE `rolle` (
  `rollen_id` int PRIMARY KEY AUTO_INCREMENT,
  `rollenbezeichnung` varchar(60) UNIQUE NOT NULL
);

CREATE TABLE `qualifikation` (
  `qualifikations_id` int PRIMARY KEY AUTO_INCREMENT,
  `bezeichnung` varchar(80) UNIQUE NOT NULL
);

CREATE TABLE `raum` (
  `raum_id` int PRIMARY KEY AUTO_INCREMENT,
  `bezeichnung` varchar(60) UNIQUE NOT NULL,
  `kapazitaet` int UNSIGNED NOT NULL,

  CONSTRAINT check_raum_kapazitaet
    CHECK (`kapazitaet` >= 1)
);

CREATE TABLE `kurs` (
  `kurs_id` int PRIMARY KEY AUTO_INCREMENT,
  `kurstitel` varchar(120) NOT NULL
);

CREATE TABLE `termin` (
  `termin_id` int PRIMARY KEY AUTO_INCREMENT,
  `kurs_id` int NOT NULL,
  `mitarbeiter_id` int NOT NULL,
  `raum_id` int NOT NULL,
  `startzeit` datetime NOT NULL,
  `endzeit` datetime NOT NULL,

  CONSTRAINT check_termin_zeit
    CHECK (`endzeit` > `startzeit`)
);

CREATE TABLE `termin_teilnahme` (
  `termin_id` int NOT NULL,
  `mitglied_id` int NOT NULL,
  `status` ENUM ('gebucht', 'besucht', 'nicht besucht', 'storniert') NOT NULL DEFAULT 'gebucht',
  `buchungszeitpunkt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `checkin` (
  `checkin_id` int PRIMARY KEY AUTO_INCREMENT,
  `mitglied_id` int NOT NULL,
  `termin_id` int NOT NULL,
  `checkin_zeit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `checkout_zeit` datetime,

  CONSTRAINT check_checkout_zeit
    CHECK (
        `checkout_zeit` IS NULL 
        OR `checkout_zeit` > `checkin_zeit`
    )
);

CREATE TABLE `mitgliedschaft_tarif` (
  `tarif_id` int PRIMARY KEY AUTO_INCREMENT,
  `bezeichnung` varchar(60) UNIQUE NOT NULL
);

CREATE TABLE `mitgliedschaft` (
  `mitgliedschaft_id` int PRIMARY KEY AUTO_INCREMENT,
  `mitglied_id` int NOT NULL,
  `tarif_id` int NOT NULL,
  `startdatum` date NOT NULL DEFAULT (CURRENT_DATE),
  `enddatum` date,
  `status` ENUM ('aktiv', 'pausiert', 'nicht aktiv') NOT NULL DEFAULT 'aktiv',

  CONSTRAINT check_mitgliedschaft_datum
    CHECK (`enddatum` IS NULL OR `enddatum` >= `startdatum`)

);

CREATE TABLE `zahlung` (
  `zahlungs_id` int PRIMARY KEY AUTO_INCREMENT,
  `mitglied_id` int NOT NULL,
  `mitgliedschaft_id` int,
  `betrag` numeric(10,2) NOT NULL,
  `zahlungsdatum` date NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE `mitarbeiter_rolle` (
  `mitarbeiter_id` int NOT NULL,
  `rollen_id` int NOT NULL
);

CREATE TABLE `mitarbeiter_qualifikation` (
  `mitarbeiter_id` int NOT NULL,
  `qualifikations_id` int NOT NULL
);

CREATE TABLE `kurs_qualifikation` (
  `kurs_id` int NOT NULL,
  `qualifikations_id` int NOT NULL
);

CREATE TABLE `tarif_kurs` (
  `tarif_id` int NOT NULL,
  `kurs_id` int NOT NULL
);

CREATE INDEX `termin_index_0` ON `termin` (`kurs_id`);

CREATE INDEX `termin_index_1` ON `termin` (`startzeit`);

CREATE UNIQUE INDEX `termin_index_2` ON `termin` (`raum_id`, `startzeit`);

CREATE UNIQUE INDEX `termin_index_3` ON `termin` (`mitarbeiter_id`, `startzeit`);

CREATE UNIQUE INDEX `termin_teilnahme_index_4` ON `termin_teilnahme` (`termin_id`, `mitglied_id`);

CREATE INDEX `termin_teilnahme_index_5` ON `termin_teilnahme` (`mitglied_id`);

CREATE INDEX `termin_teilnahme_index_6` ON `termin_teilnahme` (`termin_id`);

CREATE INDEX `termin_teilnahme_index_7` ON `termin_teilnahme` (`status`);

CREATE INDEX `checkin_index_8` ON `checkin` (`checkin_zeit`);

CREATE UNIQUE INDEX `checkin_index_9` ON `checkin` (`mitglied_id`, `termin_id`);

CREATE INDEX `mitgliedschaft_index_10` ON `mitgliedschaft` (`mitglied_id`);

CREATE INDEX `mitgliedschaft_index_11` ON `mitgliedschaft` (`tarif_id`);

CREATE INDEX `mitgliedschaft_index_12` ON `mitgliedschaft` (`status`);

CREATE INDEX `mitgliedschaft_index_13` ON `mitgliedschaft` (`startdatum`);

CREATE INDEX `zahlung_index_14` ON `zahlung` (`mitglied_id`);

CREATE INDEX `zahlung_index_15` ON `zahlung` (`mitgliedschaft_id`);

CREATE INDEX `zahlung_index_16` ON `zahlung` (`zahlungsdatum`);

CREATE UNIQUE INDEX `mitarbeiter_rolle_index_17` ON `mitarbeiter_rolle` (`mitarbeiter_id`, `rollen_id`);

CREATE INDEX `mitarbeiter_rolle_index_18` ON `mitarbeiter_rolle` (`rollen_id`);

CREATE UNIQUE INDEX `mitarbeiter_qualifikation_index_19` ON `mitarbeiter_qualifikation` (`mitarbeiter_id`, `qualifikations_id`);

CREATE INDEX `mitarbeiter_qualifikation_index_20` ON `mitarbeiter_qualifikation` (`qualifikations_id`);

CREATE UNIQUE INDEX `kurs_qualifikation_index_21` ON `kurs_qualifikation` (`kurs_id`, `qualifikations_id`);

CREATE INDEX `kurs_qualifikation_index_22` ON `kurs_qualifikation` (`qualifikations_id`);

CREATE UNIQUE INDEX `tarif_kurs_index_23` ON `tarif_kurs` (`tarif_id`, `kurs_id`);

CREATE INDEX `tarif_kurs_index_24` ON `tarif_kurs` (`kurs_id`);

ALTER TABLE `mitglied` ADD FOREIGN KEY (`mitglied_id`) REFERENCES `person` (`person_id`);

ALTER TABLE `mitarbeiter` ADD FOREIGN KEY (`mitarbeiter_id`) REFERENCES `person` (`person_id`);

ALTER TABLE `termin` ADD FOREIGN KEY (`kurs_id`) REFERENCES `kurs` (`kurs_id`);

ALTER TABLE `termin` ADD FOREIGN KEY (`mitarbeiter_id`) REFERENCES `mitarbeiter` (`mitarbeiter_id`);

ALTER TABLE `termin` ADD FOREIGN KEY (`raum_id`) REFERENCES `raum` (`raum_id`);

ALTER TABLE `termin_teilnahme` ADD FOREIGN KEY (`termin_id`) REFERENCES `termin` (`termin_id`);

ALTER TABLE `termin_teilnahme` ADD FOREIGN KEY (`mitglied_id`) REFERENCES `mitglied` (`mitglied_id`);

ALTER TABLE `checkin` ADD FOREIGN KEY (`mitglied_id`) REFERENCES `mitglied` (`mitglied_id`);

ALTER TABLE `checkin` ADD FOREIGN KEY (`termin_id`) REFERENCES `termin` (`termin_id`);

ALTER TABLE `mitgliedschaft` ADD FOREIGN KEY (`mitglied_id`) REFERENCES `mitglied` (`mitglied_id`);

ALTER TABLE `mitgliedschaft` ADD FOREIGN KEY (`tarif_id`) REFERENCES `mitgliedschaft_tarif` (`tarif_id`);

ALTER TABLE `zahlung` ADD FOREIGN KEY (`mitglied_id`) REFERENCES `mitglied` (`mitglied_id`);

ALTER TABLE `zahlung` ADD FOREIGN KEY (`mitgliedschaft_id`) REFERENCES `mitgliedschaft` (`mitgliedschaft_id`);

ALTER TABLE `mitarbeiter_rolle` ADD FOREIGN KEY (`mitarbeiter_id`) REFERENCES `mitarbeiter` (`mitarbeiter_id`);

ALTER TABLE `mitarbeiter_rolle` ADD FOREIGN KEY (`rollen_id`) REFERENCES `rolle` (`rollen_id`);

ALTER TABLE `mitarbeiter_qualifikation` ADD FOREIGN KEY (`mitarbeiter_id`) REFERENCES `mitarbeiter` (`mitarbeiter_id`);

ALTER TABLE `mitarbeiter_qualifikation` ADD FOREIGN KEY (`qualifikations_id`) REFERENCES `qualifikation` (`qualifikations_id`);

ALTER TABLE `kurs_qualifikation` ADD FOREIGN KEY (`kurs_id`) REFERENCES `kurs` (`kurs_id`);

ALTER TABLE `kurs_qualifikation` ADD FOREIGN KEY (`qualifikations_id`) REFERENCES `qualifikation` (`qualifikations_id`);

ALTER TABLE `tarif_kurs` ADD FOREIGN KEY (`tarif_id`) REFERENCES `mitgliedschaft_tarif` (`tarif_id`);

ALTER TABLE `tarif_kurs` ADD FOREIGN KEY (`kurs_id`) REFERENCES `kurs` (`kurs_id`);

ALTER TABLE `checkin` ADD FOREIGN KEY (`termin_id`) REFERENCES `termin` (`termin_id`);
