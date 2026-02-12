insert mitglied
insert mitarbeiter
delete mitglied
delete mitarbeiter
update mitglied
update mitarbeiter


DELIMITER $$

CREATE PROCEDURE person_anlegen (
    IN p_vorname VARCHAR(100),
    IN p_nachname VARCHAR(100),
    IN p_geburtsdatum DATE,
    IN p_email VARCHAR(254),
    IN p_telefon VARCHAR(20),
    IN p_strasse VARCHAR(120),
    IN p_hausnr VARCHAR(10),
    IN p_plz CHAR(5),
    IN p_ort VARCHAR(100),
    IN p_land CHAR(2),
    IN p_typ ENUM('mitglied','mitarbeiter'),
    IN p_tarif_id INT,
    IN p_rollen_id INT
)
BEGIN

    DECLARE v_person_id INT;

    START TRANSACTION;

    INSERT INTO person (
        vorname, nachname, geburtsdatum, email, telefon,
        strasse, hausnr, plz, ort, land
    )
    VALUES (
        p_vorname, p_nachname, p_geburtsdatum, p_email, p_telefon,
        p_strasse, p_hausnr, p_plz, p_ort, p_land
    );

    SET v_person_id = LAST_INSERT_ID();

    IF p_typ = 'mitglied' THEN

        INSERT INTO mitglied (mitglied_id)
        VALUES (v_person_id);

        INSERT INTO mitgliedschaft (
            mitglied_id,
            tarif_id
        )
        VALUES (
            v_person_id,
            p_tarif_id
        );

    ELSEIF p_typ = 'mitarbeiter' THEN

        INSERT INTO mitarbeiter (mitarbeiter_id)
        VALUES (v_person_id);
        IF p_rollen_id IS NOT NULL THEN
            INSERT INTO mitarbeiter_rolle (
                mitarbeiter_id,
                rollen_id
            )
            VALUES (
                v_person_id,
                p_rollen_id
            );
        END IF;

    END IF;

    COMMIT;

END$$

DELIMITER ;




---------------------------------------
--
--  Aufruf für die erson
--
--------------------------------------

CALL person_anlegen(
    'Max',
    'Mustermann',
    '1995-05-10',
    'max@mail.de',
    '0170123456',
    'Hauptstrasse',
    '10',
    '12345',
    'Berlin',
    'DE',
    'mitglied',
    1,      
    NULL    -- Nur bei Mitarbeitern
);

------------------------------
--
-- Buche Termin
--
------------------------------

DELIMITER $$

CREATE PROCEDURE termin_buchen (
    IN p_mitglied_id INT,
    IN p_termin_id INT
)
BEGIN

    DECLARE v_kurs_id INT;
    DECLARE v_tarif_id INT;
    DECLARE v_kapazitaet INT;
    DECLARE v_teilnehmer INT;

    START TRANSACTION;

    -- Kurs zum Termin holen
    SELECT kurs_id
    INTO v_kurs_id
    FROM termin
    WHERE termin_id = p_termin_id
    FOR UPDATE; -- Damit nicht mehrere Buchungen gleixhzeitig passieren

    SELECT tarif_id
    INTO v_tarif_id
    FROM mitgliedschaft
    WHERE mitglied_id = p_mitglied_id
      AND status = 'aktiv'
      AND (`enddatum` IS NULL OR `enddatum` >= CURRENT_DATE)
    LIMIT 1;

    IF NOT EXISTS (
        SELECT 1
        FROM tarif_kurs
        WHERE tarif_id = v_tarif_id
          AND kurs_id = v_kurs_id
    ) THEN
        SIGNAL SQLSTATE '45000' -- User Defined Err
        SET MESSAGE_TEXT = 'Tarif erlaubt diesen Kurs nicht';
    END IF;

    SELECT r.kapazitaet
    INTO v_kapazitaet
    FROM termin t
    JOIN raum r ON t.raum_id = r.raum_id
    WHERE t.termin_id = p_termin_id
    FOR UPDATE;

    SELECT COUNT(*)
    INTO v_teilnehmer
    FROM termin_teilnahme
    WHERE termin_id = p_termin_id
      AND status IN ('gebucht','besucht');

    IF v_teilnehmer >= v_kapazitaet THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Termin ist ausgebucht';
    END IF;

    INSERT INTO termin_teilnahme (
        termin_id,
        mitglied_id
    )
    VALUES (
        p_termin_id,
        p_mitglied_id
    );

    COMMIT;

END$$

DELIMITER ;

----------------------------
--
-- Stoniere gebuchten Termin
--
----------------------------

DELIMITER $$

CREATE PROCEDURE termin_stornieren (
    IN p_mitglied_id INT,
    IN p_termin_id INT
)
BEGIN

    START TRANSACTION;

    UPDATE termin_teilnahme
    SET status = 'storniert'
    WHERE mitglied_id = p_mitglied_id
      AND termin_id = p_termin_id;

    COMMIT;

END$$

DELIMITER ;

--------------------------
--
-- Automatischer Checkin
--
--------------------------
DELIMITER $$

CREATE PROCEDURE checkin_durchfuehren (
    IN p_mitglied_id INT,
    IN p_termin_id INT
)
BEGIN

    START TRANSACTION;

    INSERT INTO checkin (
        mitglied_id,
        termin_id
    )
    VALUES (
        p_mitglied_id,
        p_termin_id
    );

    UPDATE termin_teilnahme
    SET status = 'besucht'
    WHERE mitglied_id = p_mitglied_id
      AND termin_id = p_termin_id;

    COMMIT;

END$$

DELIMITER ;

---------------------
--
-- Automatischer Checkout
--
----------------------
DELIMITER $$

CREATE PROCEDURE checkout_durchfuehren (
    IN p_mitglied_id INT,
    IN p_termin_id INT
)
BEGIN

    START TRANSACTION;

    UPDATE checkin
    SET checkout_zeit = CURRENT_TIMESTAMP
    WHERE mitglied_id = p_mitglied_id
      AND termin_id = p_termin_id
      AND checkout_zeit IS NULL;

    COMMIT;

END$$

DELIMITER ;


