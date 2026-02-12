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

