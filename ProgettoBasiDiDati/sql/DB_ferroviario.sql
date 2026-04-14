-- Creazione Database
UNLOCK TABLES;
DROP DATABASE IF EXISTS db_ferroviario;
CREATE DATABASE db_ferroviario;
USE db_ferroviario;

--
-- Table structure for table `fermate`
--

DROP TABLE IF EXISTS `fermate`;

CREATE TABLE `fermate` (
  `stazione` varchar(50) NOT NULL,
  `citta` varchar(50) NOT NULL,
  `provincia` varchar(50) NOT NULL,
  PRIMARY KEY (`stazione`,`citta`,`provincia`),
  KEY `idx_citta` (`citta`),
  KEY `idx_provincia` (`provincia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `fermate`
--

LOCK TABLES `fermate` WRITE;

INSERT INTO `fermate` VALUES ('FirenzeC','Firenze','Firenze'),('MilanoC','Milano','Milano'),('NapoliC','Napoli','Napoli'),('pomezia','pomezia','Roma'),('fossanova','Priverno','Latina'),('rocca','Roccagorga','Latina'),('termini','Roma','Roma');

UNLOCK TABLES;

--
-- Table structure for table `tratta`
--

DROP TABLE IF EXISTS `tratta`;

CREATE TABLE `tratta` (
  `id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tratta`
--

LOCK TABLES `tratta` WRITE;

INSERT INTO `tratta` VALUES (1),(2),(3),(4),(5),(6);

UNLOCK TABLES;

--
-- Table structure for table `gestoredelservizio`
--

DROP TABLE IF EXISTS `gestoredelservizio`;

CREATE TABLE `gestoredelservizio` (
  `username` varchar(20) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `gestoredelservizio`
--

LOCK TABLES `gestoredelservizio` WRITE;

INSERT INTO `gestoredelservizio` VALUES ('gestore1','feb78cc258bdc76867354f01c22dbe43'),('gestore3','098f6bcd4621d373cade4e832627b4f6');

UNLOCK TABLES;
DELIMITER ;;
CREATE TRIGGER `before_insert_or_update_trigger_gestore` BEFORE INSERT ON `gestoredelservizio` FOR EACH ROW BEGIN
    DECLARE user_count INT;

    -- Verifica che il nome utente non sia già presente in nessuna delle tabelle
    SELECT COUNT(*) INTO user_count
    FROM (
        SELECT username FROM gestoredelservizio WHERE username = NEW.username
        UNION ALL
        SELECT username FROM lavoratore WHERE username = NEW.username
        UNION ALL
        SELECT username FROM manutentore WHERE username = NEW.username
        UNION ALL
        SELECT username FROM acquirente WHERE username = NEW.username
    ) AS user_union;

    IF user_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il nome utente è già in uso in una delle tabelle';
    END IF;
END;;
DELIMITER ;

--
-- Table structure for table `manutentore`
--

DROP TABLE IF EXISTS `manutentore`;

CREATE TABLE `manutentore` (
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `manutentore`
--

LOCK TABLES `manutentore` WRITE;

INSERT INTO `manutentore` VALUES ('filippo','6e6bc4e49dd477ebc98ef4046c067b5f');

UNLOCK TABLES;
DELIMITER ;;
CREATE TRIGGER `before_insert_or_update_trigger_manutentore` BEFORE INSERT ON `manutentore` FOR EACH ROW BEGIN
    DECLARE user_count INT;

    -- Verifica che il nome utente non sia già presente in nessuna delle tabelle
    SELECT COUNT(*) INTO user_count
    FROM (
        SELECT username FROM gestoredelservizio WHERE username = NEW.username
        UNION ALL
        SELECT username FROM lavoratore WHERE username = NEW.username
        UNION ALL
        SELECT username FROM manutentore WHERE username = NEW.username
        UNION ALL
        SELECT username FROM acquirente WHERE username = NEW.username
    ) AS user_union;

    IF user_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il nome utente è già in uso in una delle tabelle';
    END IF;
END;;
DELIMITER ;

--
-- Table structure for table `lavoratore`
--

DROP TABLE IF EXISTS `lavoratore`;

CREATE TABLE `lavoratore` (
  `CF` varchar(16) NOT NULL,
  `nome` varchar(20) NOT NULL,
  `cognome` varchar(20) NOT NULL,
  `dataNascita` date NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `ruolo` varchar(45) NOT NULL,
  PRIMARY KEY (`CF`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lavoratore`
--

LOCK TABLES `lavoratore` WRITE;

INSERT INTO `lavoratore` VALUES ('BNCMTT85C15F205D','matteo','bianchi','1990-05-06','matteo','3e8d6d897297415ef1a1a172035cc3f3','capotreno'),('FDRLRZ92L07D612Y','lorenzo','federici','1993-11-11','lorenzo','3e1c14c019d48470b4e861b6eb8eae96','macchinista'),('RSSMRA80A01H501Z','filippo','casto','1995-11-13','falvio','2e4a9ef8e97a5d2e071dab4312b89e57','capotreno'),('RSSMRO75D20H501V','mario','rossi','1998-07-08','mario','e2f15d014d40b93578d255e6221fd60','macchinista');

UNLOCK TABLES;
DELIMITER ;;
CREATE TRIGGER `before_insert_or_update_trigger_lavoratore` BEFORE INSERT ON `lavoratore` FOR EACH ROW BEGIN
    DECLARE user_count INT;

    -- Verifica che il nome utente non sia già presente in nessuna delle tabelle
    SELECT COUNT(*) INTO user_count
    FROM (
        SELECT username FROM gestoredelservizio WHERE username = NEW.username
        UNION ALL
        SELECT username FROM lavoratore WHERE username = NEW.username
        UNION ALL
        SELECT username FROM manutentore WHERE username = NEW.username
        UNION ALL
        SELECT username FROM acquirente WHERE username = NEW.username
    ) AS user_union;

    IF user_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il nome utente è già in uso in una delle tabelle';
    END IF;
END;;
DELIMITER ;

--
-- Table structure for table `acquirente`
--

DROP TABLE IF EXISTS `acquirente`;

CREATE TABLE `acquirente` (
  `CF` varchar(16) NOT NULL,
  `cognome` varchar(20) NOT NULL,
  `nome` varchar(20) NOT NULL,
  `dataDiNascita` date NOT NULL,
  `numeroCartaCredito` bigint NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  PRIMARY KEY (`CF`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `acquirente`
--

LOCK TABLES `acquirente` WRITE;

INSERT INTO `acquirente` VALUES ('HNMRFX95D68B998B','rossi','vlad','2002-07-02',1234567123456789,'vlad','f3f58ee455ae41da2ad5de06bf55e8de'),('CPLLCU04L04G332R','verdi','emanuele','1999-11-11',1234567890123456,'ema','189bbbb00c5f1fb7fba9ad9285f193d1');

UNLOCK TABLES;
DELIMITER ;;
CREATE TRIGGER `before_insert_or_update_trigger_acquirente` BEFORE INSERT ON `acquirente` FOR EACH ROW BEGIN
    DECLARE user_count INT;

    -- Verifica che il nome utente non sia già presente in nessuna delle tabelle
    SELECT COUNT(*) INTO user_count
    FROM (
        SELECT username FROM gestoredelservizio WHERE username = NEW.username
        UNION ALL
        SELECT username FROM lavoratore WHERE username = NEW.username
        UNION ALL
        SELECT username FROM manutentore WHERE username = NEW.username
        UNION ALL
        SELECT username FROM acquirente WHERE username = NEW.username
    ) AS user_union;

    IF user_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il nome utente è già in uso in una delle tabelle';
    END IF;
END;;
DELIMITER ;


--
-- Table structure for table `include`
--

DROP TABLE IF EXISTS `include`;

CREATE TABLE `include` (
  `idTratta` int NOT NULL,
  `stazione` varchar(50) NOT NULL,
  `citta` varchar(50) NOT NULL,
  `provincia` varchar(50) NOT NULL,
  `numeroFermata` int NOT NULL,
  PRIMARY KEY (`stazione`,`citta`,`provincia`,`idTratta`),
  KEY `idTratta` (`idTratta`),
  CONSTRAINT `include_ibfk_1` FOREIGN KEY (`idTratta`) REFERENCES `tratta` (`id`),
  CONSTRAINT `include_ibfk_2` FOREIGN KEY (`stazione`, `citta`, `provincia`) REFERENCES `fermate` (`stazione`, `citta`, `provincia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Dumping data for table `include`
--

LOCK TABLES `include` WRITE;

INSERT INTO `include` VALUES (1,'FirenzeC','Firenze','Firenze',3),(2,'FirenzeC','Firenze','Firenze',3),(3,'FirenzeC','Firenze','Firenze',1),(5,'fossanova','Priverno','Latina',3),(6,'fossanova','Priverno','Latina',2),(1,'MilanoC','Milano','Milano',1),(3,'MilanoC','Milano','Milano',3),(4,'MilanoC','Milano','Milano',1),(4,'NapoliC','Napoli','Napoli',2),(6,'NapoliC','Napoli','Napoli',1),(6,'pomezia','pomezia','Roma',3),(2,'rocca','Roccagorga','Latina',2),(4,'rocca','Roccagorga','Latina',3),(5,'rocca','Roccagorga','Latina',2),(1,'termini','Roma','Roma',2),(2,'termini','Roma','Roma',1),(3,'termini','Roma','Roma',2),(5,'termini','Roma','Roma',1),(6,'termini','Roma','Roma',4);

UNLOCK TABLES;

--
-- Table structure for table `treno`
--

DROP TABLE IF EXISTS `treno`;

CREATE TABLE `treno` (
  `matricola` varchar(4) NOT NULL,
  `DataAcquisto` date NOT NULL,
  `CFMacchinista` varchar(16) NOT NULL,
  `CFCapotreno` varchar(16) NOT NULL,
  PRIMARY KEY (`matricola`),
  KEY `CFMacchinista_idx` (`CFMacchinista`),
  KEY `CFCapotreno_idx` (`CFCapotreno`),
  CONSTRAINT `CFCapotreno` FOREIGN KEY (`CFCapotreno`) REFERENCES `lavoratore` (`CF`),
  CONSTRAINT `CFMacchinista` FOREIGN KEY (`CFMacchinista`) REFERENCES `lavoratore` (`CF`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `treno`
--

LOCK TABLES `treno` WRITE;

INSERT INTO `treno` VALUES ('1234','2002-11-11','FDRLRZ92L07D612Y','BNCMTT85C15F205D'),('4567','2005-12-12','RSSMRO75D20H501V','RSSMRA80A01H501Z');

UNLOCK TABLES;

--
-- Table structure for table `vagone`
--

DROP TABLE IF EXISTS `vagone`;

CREATE TABLE `vagone` (
  `codice` varchar(10) NOT NULL,
  `marca` varchar(20) NOT NULL,
  `classe` int NOT NULL,
  `modello` varchar(20) NOT NULL,
  `maxPasseggeri` int NOT NULL,
  `matricolaTreno` varchar(4) NOT NULL,
  PRIMARY KEY (`codice`,`matricolaTreno`),
  KEY `matricolaTreno` (`matricolaTreno`),
  CONSTRAINT `vagone_ibfk_1` FOREIGN KEY (`matricolaTreno`) REFERENCES treno (`matricola`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `vagone`
--

LOCK TABLES `vagone` WRITE;

INSERT INTO `vagone` VALUES ('12','ferrari',1,'new',19,'1234'),('13','lamborghini',1,'new',17,'1234');

UNLOCK TABLES;

--
-- Table structure for table `posto`
--

DROP TABLE IF EXISTS `posto`;

CREATE TABLE `posto` (
  `id_vagone` varchar(10) NOT NULL,
  `posto_treno` int NOT NULL,
  `matricolaTreno` varchar(4) NOT NULL,
  PRIMARY KEY (`id_vagone`,`posto_treno`,`matricolaTreno`),
  KEY `idx_posto_treno` (`posto_treno`),
  KEY `posto_ibfk_1_idx` (`matricolaTreno`),
  CONSTRAINT `fk_id_vagone` FOREIGN KEY (`id_vagone`) REFERENCES `vagone` (`codice`),
  CONSTRAINT `fk_posto_vagone` FOREIGN KEY (`matricolaTreno`) REFERENCES `vagone` (`matricolaTreno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `posto`
--

LOCK TABLES `posto` WRITE;

INSERT INTO `posto` VALUES ('12',1,'1234'),('12',2,'1234'),('12',3,'1234'),('12',4,'1234'),('12',5,'1234');

UNLOCK TABLES;

--
-- Table structure for table `corsa`
--

DROP TABLE IF EXISTS `corsa`;

CREATE TABLE `corsa` (
  `idCorsa` int NOT NULL,
  `dataCorsa` date NOT NULL,
  `idTratta` int NOT NULL,
  `matricolaTreno` varchar(4) NOT NULL,
  `CFLavoratore1` varchar(16) NOT NULL,
  `CFLavoratore2` varchar(16) NOT NULL,
  PRIMARY KEY (`idCorsa`,`dataCorsa`),
  KEY `idTratta` (`idTratta`),
  KEY `idx_dataCorsa` (`dataCorsa`),
  KEY `corsa_ibfk_3` (`matricolaTreno`),
  KEY `fk_CFLavoratore1` (`CFLavoratore1`),
  KEY `fk_CFLavoratore2` (`CFLavoratore2`),
  CONSTRAINT `corsa_ibfk_2` FOREIGN KEY (`idTratta`) REFERENCES `tratta` (`id`),
  CONSTRAINT `corsa_ibfk_3` FOREIGN KEY (`matricolaTreno`) REFERENCES `treno` (`matricola`),
  CONSTRAINT `fk_CFLavoratore1` FOREIGN KEY (`CFLavoratore1`) REFERENCES `lavoratore` (`CF`),
  CONSTRAINT `fk_CFLavoratore2` FOREIGN KEY (`CFLavoratore2`) REFERENCES `lavoratore` (`CF`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `corsa`
--

LOCK TABLES `corsa` WRITE;
INSERT INTO `corsa` VALUES (1,'2024-05-19',1,'1234','FDRLRZ92L07D612Y','BNCMTT85C15F205D'),(2,'2024-09-09',2,'1234','FDRLRZ92L07D612Y','BNCMTT85C15F205D'),(3,'2024-03-17',3,'1234','FDRLRZ92L07D612Y','BNCMTT85C15F205D'),(4,'2024-03-19',6,'1234','FDRLRZ92L07D612Y','BNCMTT85C15F205D');
UNLOCK TABLES;

--
-- Table structure for table `orari`
--

DROP TABLE IF EXISTS `orari`;

CREATE TABLE `orari` (
  `numeroFermata` int NOT NULL,
  `orarioPartenza` time DEFAULT NULL,
  `orarioArrivo` time DEFAULT NULL,
  `idCorsa` int NOT NULL,
  `dataCorsa` date NOT NULL,
  PRIMARY KEY (`numeroFermata`,`idCorsa`,`dataCorsa`),
  KEY `idCorsa` (`dataCorsa`,`idCorsa`),
  CONSTRAINT `orari_ibfk_1` FOREIGN KEY (`dataCorsa`, `idCorsa`) REFERENCES `corsa` (`dataCorsa`, `idCorsa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orari`
--

LOCK TABLES `orari` WRITE;
INSERT INTO `orari` VALUES (1,'12:00:00','00:00:00',1,'2024-05-19'),(1,'17:00:00','00:00:00',3,'2024-03-17'),(1,'17:00:00','00:00:00',4,'2024-03-19'),(2,'14:00:00','13:50:00',1,'2024-05-19'),(2,'18:00:00','17:50:00',3,'2024-03-17'),(2,'18:00:00','17:50:00',4,'2024-03-19'),(3,'00:00:00','15:00:00',1,'2024-05-19'),(3,'00:00:00','19:00:00',3,'2024-03-17'),(3,'19:00:00','18:50:00',4,'2024-03-19'),(4,'00:00:00','19:00:00',4,'2024-03-19');
UNLOCK TABLES;

--
-- Table structure for table `locomotrici`
--

DROP TABLE IF EXISTS `locomotrici`;

CREATE TABLE `locomotrici` (
  `codice` varchar(10) NOT NULL,
  `marca` varchar(20) NOT NULL,
  `modello` varchar(20) NOT NULL,
  `matricolaTreno` varchar(4) NOT NULL,
  PRIMARY KEY (`codice`,`matricolaTreno`),
  KEY `matricolaTreno` (`matricolaTreno`),
  CONSTRAINT `locomotrici_ibfk_1` FOREIGN KEY (`matricolaTreno`) REFERENCES treno (`matricola`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `locomotrici`
--

LOCK TABLES `locomotrici` WRITE;
INSERT INTO `locomotrici` VALUES ('34','best','classic','1234');
UNLOCK TABLES;

--
-- Table structure for table `prenotazione`
--

DROP TABLE IF EXISTS `prenotazione`;
CREATE TABLE `prenotazione` (
  `codicePrenotazione` varchar(20) NOT NULL,
  `postoTreno` int NOT NULL,
  `CFAcquirente` varchar(16) NOT NULL,
  `matricolaTreno` varchar(4) NOT NULL,
  `id_vagone` varchar(10) NOT NULL,
  `id_corsa` int NOT NULL,
  `data_` date NOT NULL,
  PRIMARY KEY (`codicePrenotazione`),
  KEY `CFAcquirente` (`CFAcquirente`),
  KEY `matricolaTreno` (`matricolaTreno`),
  KEY `fk_id_PrenotazioneVagone` (`id_vagone`),
  KEY `fk_postoPrenotazione` (`postoTreno`),
  KEY `fk_id_data_prenotazione` (`data_`,`id_corsa`),
  KEY `idx_cfacquirente` (`CFAcquirente`),
  KEY `idx_CF` (`CFAcquirente`),
  CONSTRAINT `fk_id_data_prenotazione` FOREIGN KEY (`data_`, `id_corsa`) REFERENCES `corsa` (`dataCorsa`, `idCorsa`),
  CONSTRAINT `fk_id_PrenotazioneVagone` FOREIGN KEY (`id_vagone`) REFERENCES `posto` (`id_vagone`),
  CONSTRAINT `fk_postoPrenotazione` FOREIGN KEY (`postoTreno`) REFERENCES `posto` (`posto_treno`),
  CONSTRAINT `prenotazione_ibfk_1` FOREIGN KEY (`CFAcquirente`) REFERENCES `acquirente` (`CF`),
  CONSTRAINT `prenotazione_ibfk_2` FOREIGN KEY (`matricolaTreno`) REFERENCES `posto` (`matricolaTreno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `prenotazione`
--

LOCK TABLES `prenotazione` WRITE;
INSERT INTO `prenotazione` VALUES ('a508d3721f4938a3472d',1,'HNMRFX95D68B998B','1234','12',1,'2024-05-19');
UNLOCK TABLES;

--
-- Table structure for table `storico_manutenzione`
--

DROP TABLE IF EXISTS `storico_manutenzione`;
CREATE TABLE `storico_manutenzione` (
  `matricolaTreno` varchar(4) NOT NULL,
  `dataManutenzione` date NOT NULL,
  `manutenzione` varchar(100) NOT NULL,
  PRIMARY KEY (`matricolaTreno`,`dataManutenzione`),
  CONSTRAINT `storico_manutenzione_ibfk_1` FOREIGN KEY (`matricolaTreno`) REFERENCES `treno` (`matricola`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `storico_manutenzione`
--

LOCK TABLES `storico_manutenzione` WRITE;
UNLOCK TABLES;

--
-- Dumping events for database 'DB_ferroviario'
--

DELIMITER ;;
CREATE EVENT `eliminazione_dati_vecchi` ON SCHEDULE EVERY 1 YEAR STARTS '2024-06-23 11:29:41' ON COMPLETION PRESERVE ENABLE COMMENT 'Rimozione dati più vecchi di 10 anni - Test' DO BEGIN
    DELETE FROM orari
    WHERE dataCorsa <= DATE_SUB(NOW(), INTERVAL 10 YEAR);

    DELETE FROM prenotazione
    WHERE data_ <= DATE_SUB(NOW(), INTERVAL 10 YEAR);

    DELETE FROM corsa
    WHERE dataCorsa <= DATE_SUB(NOW(), INTERVAL 10 YEAR);
END ;;

--
-- Dumping routines for database 'DB_ferroviario'
--
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `controlla_classe`(classe int) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	if classe =1 OR classe=2 then
		return true;
	else
		return false;
	end if;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `controlla_lavoratori_treno`(var_macchinista varchar(16),var_capotreno varchar(16),matricolaTreno varchar(4)) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN

	DECLARE macchinista VARCHAR(16);
    DECLARE capotreno VARCHAR(16);

	SELECT CFMacchinista,CFCapotreno
    INTO macchinista,capotreno
    from treno
    WHERE matricola=matricolaTreno;
    

    
	if var_macchinista=macchinista AND var_capotreno=capotreno  then
		return true;
	else
		return false;
	end if;
END ;;
DELIMITER ;
DELIMITER ;;
DROP FUNCTION IF EXISTS controllo_carta_di_credito;;

DELIMITER ;;

CREATE FUNCTION controllo_carta_di_credito(carta_di_credito VARCHAR(16)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    -- Gestione del caso NULL
    IF carta_di_credito IS NULL THEN
        RETURN TRUE; -- oppure FALSE, se vuoi impedirlo
    END IF;

    -- Regex: deve contenere esattamente 16 cifre
    IF carta_di_credito REGEXP '^[0-9]{16}$' THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;;

DELIMITER ;

DELIMITER ;
DELIMITER ;;
CREATE FUNCTION controllo_cf(codice_fiscale VARCHAR(16)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    IF codice_fiscale IS NULL THEN
        RETURN TRUE; -- Considera NULL come accettabile (facoltativo)
    END IF;

    IF codice_fiscale REGEXP '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$' THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `controllo_lavoratore`(
    CFLavoratore1_ VARCHAR(16), 
    CFLavoratore2_ VARCHAR(16), 
    var_data DATE,
    orario_partenza TIME,
    orario_arrivo TIME
) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE sovrapposizione BOOLEAN;

    SELECT 
        EXISTS (
            SELECT 1
            FROM (
                SELECT 
                    orarioPartenza,
                    orarioArrivo
                FROM
                    (SELECT 
                        corsa.idCorsa,
                        corsa.dataCorsa,
                        corsa.matricolaTreno,
                        CASE WHEN orari.orarioArrivo = '00:00:00' THEN orari.orarioPartenza ELSE orari.orarioArrivo END AS orarioPartenza,
                        CASE WHEN orari.orarioPartenza = '00:00:00' THEN orari.orarioArrivo ELSE orari.orarioPartenza END AS orarioArrivo
                    FROM 
                        orari
                    JOIN 
                        corsa ON corsa.dataCorsa = orari.dataCorsa AND corsa.idCorsa = orari.idCorsa
                    WHERE 
                        (corsa.CFLavoratore1 = CFLavoratore1_ OR corsa.CFLavoratore2 = CFLavoratore2_)
                        AND corsa.dataCorsa = var_data
                    ) AS combined_results
            ) AS subquery
            WHERE 
                (orario_partenza BETWEEN orarioPartenza AND orarioArrivo
                OR orario_arrivo BETWEEN orarioPartenza AND orarioArrivo
                OR orarioPartenza BETWEEN orario_partenza AND orario_arrivo
                OR orarioArrivo BETWEEN orario_partenza AND orario_arrivo)
        ) INTO sovrapposizione;

    RETURN sovrapposizione;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `controllo_matricola`(matricola VARCHAR(4)) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    IF LENGTH(matricola) = 4 THEN
        RETURN 1; -- Restituisce vero (1) se la lunghezza è 4
    ELSE
        RETURN 0; -- Restituisce falso (0) se la lunghezza non è 4
    END IF;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `controllo_orari`(orario_partenza Time, oraraio_arrivo time) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	if orario_partenza > oraraio_arrivo THEN
		return true;
	else
		return false;
	end if;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `controllo_treno`(
    treno VARCHAR(16), 
    var_data DATE,
    orario_partenza TIME,
    orario_arrivo TIME
) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE sovrapposizione BOOLEAN;

    SELECT 
        EXISTS (
            SELECT 1
            FROM (
                SELECT 
                    orarioPartenza,
                    orarioArrivo
                FROM
                    (SELECT 
                        corsa.idCorsa,
                        corsa.dataCorsa,
                        corsa.matricolaTreno,
                        CASE WHEN orari.orarioArrivo = '00:00:00' THEN orari.orarioPartenza ELSE orari.orarioArrivo END AS orarioPartenza,
                        CASE WHEN orari.orarioPartenza = '00:00:00' THEN orari.orarioArrivo ELSE orari.orarioPartenza END AS orarioArrivo
                    FROM 
                        orari
                    JOIN 
                        corsa ON corsa.dataCorsa = orari.dataCorsa AND corsa.idCorsa = orari.idCorsa
                    WHERE 
                        corsa.matricolaTreno = treno AND corsa.dataCorsa = var_data
                    ) AS combined_results
            ) AS subquery
            WHERE 
                (orario_partenza BETWEEN orarioPartenza AND orarioArrivo
                OR orario_arrivo BETWEEN orarioPartenza AND orarioArrivo
                OR orarioPartenza BETWEEN orario_partenza AND orario_arrivo
                OR orarioArrivo BETWEEN orario_partenza AND orario_arrivo)
        ) INTO sovrapposizione;

    RETURN sovrapposizione;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `max_passeggeri`(max_passeggeri INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	if max_passeggeri <= 25 then
		return true;
	else
		return false;
	end if;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CF_Acquirenti`(
	IN var_username VARCHAR(20)
)
BEGIN

declare exit handler for sqlexception
    begin
		rollback;
        resignal;
	end;
    
    set transaction isolation level read committed;
	start transaction;
    
    select CF
    from acquirente
    WHERE username=var_username;
    
    commit;
	
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CF_Lavoratori`(
	IN var_username VARCHAR(20)
)
BEGIN

declare exit handler for sqlexception
    begin
		rollback;
        resignal;
	end;
    
    set transaction isolation level read committed;
	start transaction;
    
    select CF
    from lavoratore
    WHERE username=var_username;
    
    commit;
	
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `login`(in var_username
				VARCHAR(45), in var_password VARCHAR(45), out var_role INT)
BEGIN

-- var_role = 0 --> login
-- var_role = 1 --> acquirente
-- var_role = 2 --> gestore
-- var_role = 3 --> lavoratore
-- var_role = 4 --> manutentore

		set var_role = 0;
        if exists(
			select * from acquirente
			WHERE username = var_username AND
			password = md5(var_password))
		then set var_role = 1;
        end if;
        
        if exists(
			select * from gestoredelservizio
			WHERE username = var_username AND
			password =  md5(var_password))
		then set var_role = 2;
        end if;
        
        if exists(
			select * from lavoratore
			WHERE username = var_username AND
			password =  md5(var_password))
		then set var_role = 3;
        end if;
        
        if exists(
			select * from manutentore
			WHERE username = var_username AND
			password =  md5(var_password))
		then set var_role = 4;
        end if;
        
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_registra_corsa`(
    IN var_macchinista VARCHAR(16),
    IN var_capotreno VARCHAR(16),
    IN var_treno VARCHAR(4),
    IN var_data DATE,
    IN var_idTratta INT,
    IN var_orari TEXT
)
BEGIN
    DECLARE var_idCorsa INT;
    DECLARE str_orario TEXT DEFAULT '';
    DECLARE orarioPartenza TIME;
    DECLARE orarioArrivo TIME;
    DECLARE numeroFermata INT DEFAULT 1;
    DECLARE primo_orario TIME;
    DECLARE ultimo_orario TIME;
    DECLARE a INT DEFAULT 1;
    DECLARE total_orari INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    -- Rimuovere caratteri non numerici di sicurezza
    SET var_orari = REPLACE(REPLACE(REPLACE(REPLACE(var_orari, '[', ''), ']', ''), ' ', ''), '(', '');

    -- Calcolare il numero totale di orari usando il separatore ';'
    SET total_orari = LENGTH(var_orari) - LENGTH(REPLACE(var_orari, ';', '')) + 1;

    -- Estrai primo e ultimo orario usando ';'
    SET primo_orario = SUBSTRING_INDEX(var_orari, ';', 1);
    SET ultimo_orario = SUBSTRING_INDEX(var_orari, ';', -1);

    IF (controlla_lavoratori_treno(var_macchinista, var_capotreno, var_treno) IS FALSE) THEN
        SIGNAL SQLSTATE '45025' SET MESSAGE_TEXT = 'Questo treno ha assegnati diversi lavoratori';
    END IF;

    IF (controllo_treno(var_treno, var_data, primo_orario, ultimo_orario) IS TRUE) THEN
        SIGNAL SQLSTATE '45020' SET MESSAGE_TEXT = 'Il treno è già impegnato in un altra corsa.';
    END IF;

    IF (controllo_lavoratore(var_macchinista, var_capotreno, var_data, primo_orario, ultimo_orario) IS TRUE) THEN
        SIGNAL SQLSTATE '45021' SET MESSAGE_TEXT = 'Il lavoratore è già impegnato in un altra corsa.';
    END IF;

    -- Genera nuovo idCorsa
    SELECT IFNULL(MAX(idCorsa), 0) + 1 INTO var_idCorsa FROM corsa;

    -- Inserisci la corsa
    INSERT INTO corsa (idCorsa, dataCorsa, idTratta, matricolaTreno, CFLavoratore1, CFLavoratore2)
    VALUES (var_idCorsa, var_data, var_idTratta, var_treno, var_macchinista, var_capotreno);

    -- Parsing orari con separatore ';'
    WHILE_LOOP: WHILE LENGTH(var_orari) > 0 DO
        SET str_orario = TRIM(SUBSTRING_INDEX(var_orari, ';', 1));

        IF INSTR(str_orario, '-') > 0 THEN
            SET orarioPartenza = STR_TO_DATE(SUBSTRING_INDEX(str_orario, '-', 1), '%H:%i');
            SET orarioArrivo = STR_TO_DATE(SUBSTRING_INDEX(str_orario, '-', -1), '%H:%i');

            -- ✅ Controlla solo se entrambi sono diversi da 00:00:00
            IF orarioPartenza != '00:00:00' AND orarioArrivo != '00:00:00' THEN
                IF (`db_ferroviario`.controllo_orari(orarioPartenza, orarioArrivo) IS FALSE) THEN
                    SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'Orario di partenza è minore di quello di arrivo';
                END IF;
            END IF;

        ELSE
            IF a = 1 THEN
                SET orarioPartenza = STR_TO_DATE(str_orario, '%H:%i');
                SET orarioArrivo = STR_TO_DATE('00:00', '%H:%i');
            ELSEIF a = total_orari THEN
                SET orarioPartenza = STR_TO_DATE('00:00', '%H:%i');
                SET orarioArrivo = STR_TO_DATE(str_orario, '%H:%i');
            ELSE
                SET orarioPartenza = STR_TO_DATE(str_orario, '%H:%i');
                SET orarioArrivo = STR_TO_DATE('00:00', '%H:%i');
            END IF;
        END IF;

        INSERT INTO orari (numeroFermata, orarioPartenza, orarioArrivo, idCorsa, dataCorsa)
        VALUES (numeroFermata, orarioPartenza, orarioArrivo, var_idCorsa, var_data);

        SET var_orari = TRIM(SUBSTRING(var_orari, LENGTH(str_orario) + 2));
        SET numeroFermata = numeroFermata + 1;
        SET a = a + 1;
    END WHILE WHILE_LOOP;

    COMMIT;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS registrazione;;

DELIMITER ;;

CREATE PROCEDURE registrazione(
    IN p_codiceFiscale VARCHAR(16),
    IN p_nome VARCHAR(50),
    IN p_cognome VARCHAR(50),
    IN p_dataDiNascita DATE,
    IN p_numeroCartaDiCredito BIGINT,
    IN p_username VARCHAR(45),
    IN p_password VARCHAR(45),
    IN p_ruolo INT,
    IN p_ruoloLavoratore VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    START TRANSACTION;

    IF p_ruolo = 1 THEN
        -- Acquirente: controllo CF e carta
        IF controllo_cf(p_codiceFiscale) IS FALSE THEN
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Il codice fiscale inserito non è valido.';
        END IF;
        IF controllo_carta_di_credito(p_numeroCartaDiCredito) IS FALSE THEN
            SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'La carta di credito non è valida.';
        END IF;

        INSERT INTO acquirente (CF, cognome, nome, dataDiNascita, numeroCartaCredito, username, password)
        VALUES (p_codiceFiscale, p_cognome, p_nome, p_dataDiNascita, p_numeroCartaDiCredito, p_username, MD5(p_password));

    ELSEIF p_ruolo = 2 THEN
        -- Gestore del servizio
        INSERT INTO gestoredelservizio (username, password)
        VALUES (p_username, MD5(p_password));

    ELSEIF p_ruolo = 3 THEN
        -- Lavoratore (ha anche CF, data, ruoloLavoratore)
        IF controllo_cf(p_codiceFiscale) IS FALSE THEN
            SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'Il codice fiscale inserito non è valido.';
        END IF;

        INSERT INTO lavoratore (CF, nome, cognome, dataNascita, username, password, ruolo)
        VALUES (p_codiceFiscale, p_nome, p_cognome, p_dataDiNascita, p_username, MD5(p_password), p_ruoloLavoratore);

    ELSEIF p_ruolo = 4 THEN
        -- Manutentore
        INSERT INTO manutentore (username, password)
        VALUES (p_username, MD5(p_password));

    ELSE
        SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = 'Ruolo non valido.';
    END IF;

    COMMIT;
END;;

DELIMITER ;

DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `registra_Fermate`(
    IN stazione VARCHAR(50), 
    IN citta VARCHAR(50),
    IN provincia VARCHAR(50)
)
BEGIN
    
    
    DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
   

    SET TRANSACTION ISOLATION LEVEL READ uncommitted;
    START TRANSACTION;

    INSERT INTO fermate VALUES(stazione, citta, provincia);

    COMMIT;
END ;;
DELIMITER ;
USE db_ferroviario;
DROP PROCEDURE IF EXISTS registra_locomotrici;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `registra_locomotrici`(
    IN vard_id INT,
    IN var_marca VARCHAR(20), 
    IN var_modello VARCHAR(20), 
    IN var_matricolaTreno VARCHAR(4)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    START TRANSACTION;

    INSERT INTO locomotrici (codice, marca, modello, matricolaTreno)
    VALUES (vard_id, var_marca, var_modello, var_matricolaTreno);

    COMMIT;
END;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `registra_manutenzione`(
	in var_matricola varchar(45),
    in var_data varchar(45),
    in descrizione varchar(200)
)
BEGIN

declare exit handler for sqlexception
    begin
		rollback;
        resignal;
	end;

	set transaction isolation level read uncommitted;
	start transaction;
		
	insert into storico_manutenzione values (var_matricola, var_data,descrizione);
	
    commit;
        
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `registra_prenotazione2`(
    IN tratta INT,
    IN var_partenza TIME,
    IN var_data DATE,
    IN CF VARCHAR(16)
)
BEGIN
    DECLARE codicePrenotazione VARCHAR(20);
    DECLARE conta INT;
    DECLARE vagoneC VARCHAR(10);
    DECLARE maxP INT;
    DECLARE cur_corsa INT;
    DECLARE cur_treno VARCHAR(4);
    DECLARE vagone_candidato VARCHAR(10);
    DECLARE vagone_trovato BOOLEAN DEFAULT FALSE;
    DECLARE posto_trovato INT;
    DECLARE ultimo_posto INT;
    DECLARE vagoni_cursor CURSOR FOR
        SELECT codice, maxPasseggeri
        FROM vagone
        WHERE matricolaTreno = cur_treno;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      
        ROLLBACK;
        RESIGNAL;
    END;
    
    SET TRANSACTION ISOLATION LEVEL repeatable read;
    START TRANSACTION;

-- mi trovo l'id della corsa
    SELECT corsa.idCorsa 
    INTO cur_corsa 
    FROM orari, corsa
    WHERE corsa.dataCorsa = orari.dataCorsa 
      AND corsa.idCorsa = orari.idCorsa 
      AND orarioPartenza = var_partenza 
      AND corsa.dataCorsa = var_data 
      AND corsa.idTratta = tratta;
      
	

-- mi trovo la matricola del treno
    SELECT matricolaTreno 
    INTO cur_treno 
    FROM corsa
    WHERE idCorsa = cur_corsa;

    OPEN vagoni_cursor;
    
    vagoni_loop: LOOP
        FETCH vagoni_cursor INTO vagoneC, maxP;

        IF vagone_trovato THEN
            LEAVE vagoni_loop;
        END IF;

        SELECT COUNT(*)
        INTO conta
        FROM prenotazione
        WHERE id_corsa = cur_corsa AND id_vagone = vagoneC;

        IF conta < maxP THEN
            SET vagone_candidato = vagoneC;
            LEAVE vagoni_loop;
        END IF;
    END LOOP;

    CLOSE vagoni_cursor;
    
   
    IF vagone_candidato IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45030' SET MESSAGE_TEXT = 'La corsa ha raggiunto la capienza massima';
    END IF;

    SELECT MAX(postoTreno)
    INTO ultimo_posto
    FROM prenotazione
    WHERE id_vagone = vagone_candidato AND id_corsa = cur_corsa;

    IF ultimo_posto THEN
        SET posto_trovato = ultimo_posto + 1;
    ELSE
        SET ultimo_posto = 0;
        SET posto_trovato = 1;
    END IF;

  

    SET codicePrenotazione = SUBSTRING(MD5(CONCAT(UUID(), RAND())), 1, 20);

    INSERT INTO prenotazione (codicePrenotazione, postoTreno, CFAcquirente, matricolaTreno, id_vagone, id_corsa, data_) 
    VALUES (codicePrenotazione, posto_trovato, CF, cur_treno, vagone_candidato, cur_corsa, var_data);

    COMMIT;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `registra_Tratta`(
    IN fermate TEXT
)
BEGIN
    DECLARE citta_ VARCHAR(50);
    DECLARE provincia_ VARCHAR(50);
    DECLARE current_fermata VARCHAR(50);
    DECLARE start INT DEFAULT 1;
    DECLARE length INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE max_id INT DEFAULT 1;
    DECLARE counter INT DEFAULT 1;
    DECLARE err_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    SELECT MAX(id) INTO max_id FROM tratta;
    SET max_id = IFNULL(max_id, 0) + 1;

    INSERT INTO tratta(id) VALUES(max_id);

    cursor_loop: LOOP
        SET length = LOCATE(',', fermate, start) - start;

        IF length < 0 THEN
            SET current_fermata = TRIM(SUBSTRING(fermate, start));
            SET done = 1;
        ELSE
            SET current_fermata = TRIM(SUBSTRING(fermate, start, length));
        END IF;

        IF NOT EXISTS (
            SELECT 1 FROM fermate
            WHERE stazione = current_fermata
        ) THEN
            SET err_msg = CONCAT('Fermata non trovata: ', current_fermata);
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = err_msg;
        END IF;

        SELECT citta, provincia
        INTO citta_, provincia_
        FROM fermate
        WHERE stazione = current_fermata;

        INSERT INTO include (idTratta, stazione, citta, provincia, numeroFermata)
        VALUES (max_id, current_fermata, citta_, provincia_, counter);

        SET start = start + length + 1;
        SET counter = counter + 1;

        IF done THEN
            LEAVE cursor_loop;
        END IF;
    END LOOP;

    COMMIT;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `registra_treno`(
	in var_matricola varchar(4),
    in var_dataDiAcquisto varchar(45),
    in var_macchinista varchar(45),
    in var_capotreno varchar(45)
)
BEGIN
	declare exit handler for sqlexception
    begin
		rollback;
        resignal;
	end;

	set transaction isolation level READ uncommitted;
	start transaction;
		
	if(controllo_matricola(var_matricola) is false) then
		signal sqlstate '45011' set message_text = 'Inserire il codice del treno di 4 caratteri.';
	end if;
	insert into treno values (var_matricola, var_dataDiAcquisto,var_macchinista,var_capotreno);
	
    commit;
        
END ;;
DELIMITER ;
DELIMITER ;;
DROP PROCEDURE IF EXISTS registra_vagone;
DELIMITER ;;

CREATE DEFINER=`root`@`localhost` PROCEDURE `registra_vagone`(
    IN var_id VARCHAR(10),
    IN var_marca VARCHAR(45), 
    IN var_classe INT,
    IN var_modello VARCHAR(45), 
    IN var_numMaxPasseggeri INT,
    IN var_matricolaTreno VARCHAR(4)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    START TRANSACTION;

    -- Controllo numero massimo passeggeri
    IF (max_passeggeri(var_numMaxPasseggeri) IS FALSE) THEN
        SIGNAL SQLSTATE '45008' SET MESSAGE_TEXT = 'Il numero di passeggeri è maggiore di 25.';
    END IF;

    -- Controllo validità classe
    IF (controlla_classe(var_classe) IS FALSE) THEN
        SIGNAL SQLSTATE '45013' SET MESSAGE_TEXT = 'Il vagone può essere di 1ª o 2ª classe.';
    END IF;

    -- Inserimento nel DB
    INSERT INTO vagone (codice, marca, classe, modello, maxPasseggeri, matricolaTreno)
    VALUES (var_id, var_marca, var_classe, var_modello, var_numMaxPasseggeri, var_matricolaTreno);

    COMMIT;
END ;;
DELIMITER ;

DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `report_turni`(
	In CF VARCHAR(16)
)
BEGIN

	DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    START TRANSACTION;

SELECT 
    idCorsa,
    dataCorsa,
    matricolaTreno,
    MAX(orarioPartenza) AS orarioPartenza,
    MAX(orarioArrivo) AS orarioArrivo
FROM
    (SELECT 
        corsa.idCorsa,
        corsa.dataCorsa,
        corsa.matricolaTreno,
        CASE WHEN orari.orarioArrivo = '00:00:00' THEN orari.orarioPartenza ELSE NULL END AS orarioPartenza,
        CASE WHEN orari.orarioPartenza = '00:00:00' THEN orari.orarioArrivo ELSE NULL END AS orarioArrivo
    FROM 
        orari
    JOIN 
        corsa ON corsa.dataCorsa = orari.dataCorsa AND corsa.idCorsa = orari.idCorsa
    WHERE 
        (corsa.CFLavoratore1 = CF OR corsa.CFLavoratore2 = CF)
    ) AS combined_results
GROUP BY 
    idCorsa, dataCorsa, matricolaTreno
ORDER By(dataCorsa);

commit;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizza_fermate`()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

    SELECT stazione, citta, provincia
    FROM fermate;

END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizza_lavoratori`(
    IN var_matricola VARCHAR(4),
    IN a INT
)
BEGIN
    DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL repeatable read;
    START TRANSACTION;

    IF a = 0 THEN
        SELECT CF
        FROM lavoratore
        WHERE ruolo = 'capotreno';
    ELSEIF a = 1 THEN
        SELECT CF
        FROM lavoratore
        WHERE ruolo = 'macchinista';
    ELSEIF a = 2 THEN
        SELECT CFMacchinista
        FROM treno
        WHERE matricola = var_matricola;
    ELSEIF a = 3 THEN
        SELECT CFCapotreno
        FROM treno
        WHERE matricola = var_matricola;
    END IF;

    COMMIT;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizza_orari`(
    IN deta DATE,
    IN id_Tratta INT
    )
BEGIN

DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL repeatable read;
    START TRANSACTION;


	SELECT 
    idCorsa,
    dataCorsa,
    matricolaTreno,
    MAX(orarioPartenza) AS orarioPartenza,
    MAX(orarioArrivo) AS orarioArrivo
FROM
    (SELECT 
        corsa.idCorsa,
        corsa.dataCorsa,
        corsa.matricolaTreno,
        CASE WHEN orari.orarioArrivo = '00:00:00' THEN orari.orarioPartenza ELSE NULL END AS orarioPartenza,
        CASE WHEN orari.orarioPartenza = '00:00:00' THEN orari.orarioArrivo ELSE NULL END AS orarioArrivo
    FROM 
        orari
    JOIN 
        corsa ON corsa.dataCorsa = orari.dataCorsa AND corsa.idCorsa = orari.idCorsa
    WHERE 
        ( orari.dataCorsa=deta AND corsa.idTratta=id_Tratta)
    ) AS combined_results
GROUP BY 
    idCorsa, dataCorsa, matricolaTreno
ORDER BY 
    dataCorsa;
    
    commit;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizza_prenotazione`(
	IN Cf VARCHAR(16)
)
BEGIN

declare exit handler for sqlexception
    begin
		rollback;
        resignal;
	end;
    
    set transaction isolation level read committed;
	start transaction;
    
   SELECT prenotazione.matricolaTreno, prenotazione.id_vagone, prenotazione.data_, prenotazione.postoTreno, MIN(orari.orarioPartenza) AS minOrarioPartenza
FROM prenotazione
JOIN corsa ON prenotazione.id_corsa = corsa.idCorsa AND prenotazione.data_ = corsa.dataCorsa
JOIN orari ON corsa.idCorsa = orari.idCorsa AND corsa.dataCorsa = orari.dataCorsa
WHERE prenotazione.CFAcquirente = Cf AND orari.orarioPartenza != 0
GROUP BY corsa.idCorsa, corsa.dataCorsa, prenotazione.matricolaTreno, prenotazione.id_vagone, prenotazione.data_, prenotazione.postoTreno;

    
    commit;
	
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizza_tratte`()
BEGIN
    
    
	DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL repeatable read;
    START TRANSACTION;
		
    
    SELECT numeroFermata, idTratta, stazione
    FROM include
    ORDER BY idTratta,numeroFermata;
    
    
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizza_treni`()
BEGIN

	 DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL repeatable read;
    START TRANSACTION;
		
    select matricola
    from treno
     
    
    commit;
    
END ;;
DELIMITER ;

-- === CREAZIONE UTENTI ===

CREATE USER IF NOT EXISTS 'login'@'localhost' IDENTIFIED BY 'login123!';
CREATE USER IF NOT EXISTS 'acquirente'@'localhost' IDENTIFIED BY 'acquirente123!';
CREATE USER IF NOT EXISTS 'gestoredelservizio'@'localhost' IDENTIFIED BY '!gestori@1224';
CREATE USER IF NOT EXISTS 'lavoratori'@'localhost' IDENTIFIED BY '!lavoratori@1224';
CREATE USER IF NOT EXISTS 'manutentore'@'localhost' IDENTIFIED BY 'manutentore123@';

-- PRIVILEGI LOGIN
GRANT EXECUTE ON PROCEDURE db_ferroviario.login TO 'login'@'localhost';
GRANT EXECUTE ON PROCEDURE db_ferroviario.registrazione TO 'login'@'localhost';

-- PRIVILEGI ACQUIRENTE
GRANT EXECUTE ON PROCEDURE db_ferroviario.registra_prenotazione2 TO 'acquirente'@'localhost';
GRANT EXECUTE ON PROCEDURE db_ferroviario.visualizza_prenotazione TO 'acquirente'@'localhost';

-- PRIVILEGI GESTORI
GRANT EXECUTE ON PROCEDURE db_ferroviario.new_registra_corsa TO 'gestoredelservizio'@'localhost';
GRANT EXECUTE ON PROCEDURE db_ferroviario.registra_treno TO 'gestoredelservizio'@'localhost';
GRANT EXECUTE ON PROCEDURE db_ferroviario.registra_locomotrici TO 'gestoredelservizio'@'localhost';
GRANT EXECUTE ON PROCEDURE db_ferroviario.registra_Tratta TO 'gestoredelservizio'@'localhost';
GRANT EXECUTE ON PROCEDURE db_ferroviario.registra_Fermate TO 'gestoredelservizio'@'localhost';
GRANT EXECUTE ON PROCEDURE db_ferroviario.registra_vagone TO 'gestoredelservizio'@'localhost';

-- PRIVILEGI LAVORATORE
GRANT EXECUTE ON PROCEDURE db_ferroviario.report_turni TO 'lavoratori'@'localhost';

-- PRIVILEGI MANUTENTORE
GRANT EXECUTE ON PROCEDURE db_ferroviario.registra_manutenzione TO 'manutentore'@'localhost';

FLUSH PRIVILEGES;

ALTER USER 'lavoratori'@'localhost' IDENTIFIED BY '!lavoratori@1224';
ALTER USER 'manutentore'@'localhost' IDENTIFIED BY 'manutentore123@';
FLUSH PRIVILEGES;

