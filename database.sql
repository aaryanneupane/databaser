
CREATE TABLE IF NOT EXISTS Jernbanestasjon (
	StasjonNavn	VARCHAR(30),
	moh	FLOAT,
	CONSTRAINT JernbaneS_PK PRIMARY KEY (StasjonNavn)
	);


CREATE TABLE IF NOT EXISTS Delstrekning (
	DelSNavn VARCHAR(30),
	RuteID 	INTEGER NOT NULL,
	BaneNavn VARCHAR(30), -- Lagt til BaneNavn
	LengdeIKm INTEGER NOT NULL,
	AntallSpor INTEGER NOT NULL,
	StartStasjon VARCHAR(30),
	EndeStasjon	VARCHAR(30),
	CONSTRAINT DelS_PK PRIMARY KEY (DelSNavn, BaneNavn)
	CONSTRAINT DelS_FK1 FOREIGN KEY (BaneNavn) REFERENCES Banestrekning(BaneNavn)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT DelS_FK2 FOREIGN KEY (RuteID) REFERENCES Togrute(RuteID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	);

CREATE TABLE IF NOT EXISTS Banestrekning (
	BaneNavn VARCHAR(30),
	Fremdriftsenergi INTEGER, -- 0 for false og 1 for True
	StartStasjon VARCHAR(30),
	EndeStasjon VARCHAR(30),
	CONSTRAINT Bane_PK PRIMARY KEY (BaneNavn)
	);
	

CREATE TABLE IF NOT EXISTS Operatør(
	OperatørNavn VARCHAR(30),
	CONSTRAINT Operatør_PK PRIMARY KEY (OperatørNavn)
);


CREATE TABLE IF NOT EXISTS Togrute(
	RuteID 	INTEGER NOT NULL,
	Hovedretning VARCHAR(30), -- Endret til 'True'/'False' fremfor 1/0
	BaneNavn VARCHAR(30),
	OperatørNavn VARCHAR(30),
	Ukedager VARCHAR(30), --Lagt til Ukedager, viser til når togruten går
	StartStasjon VARCHAR(30), -- Lagt til Startstasjon
	EndeStasjon VARCHAR(30),  -- Lagt til endestasjon
	CONSTRAINT Rute_PK PRIMARY KEY (RuteID)
	CONSTRAINT Rute_FK1 FOREIGN KEY (BaneNavn) REFERENCES Banestrekning(BaneNavn)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT Rute_FK2 FOREIGN KEY (OperatørNavn) REFERENCES Operatør(OperatørNavn)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS TogruteForekomst(
	TogruteForekomstID INTEGER NOT NULL,
	OperatørNavn VARCHAR(30),
	Avgangstid 	VARCHAR(30), -- lagt til avgansgstid
	Ankomsttid VARCHAR(30),  -- Lagt til ankomsttid
	CONSTRAINT Forekomst_PK PRIMARY KEY (TogruteForekomstID)
	CONSTRAINT Rute_FK1 FOREIGN KEY (OperatørNavn) REFERENCES Operatør(OperatørNavn)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Kunde(
	KundeNr	INTEGER NOT NULL,
	Navn VARCHAR(30),
	epost VARCHAR(30),
	tlf	VARCHAR(10),
	CONSTRAINT Kunde_PK PRIMARY KEY (KundeNr)
);


CREATE TABLE IF NOT EXISTS Kundeordre(
	OrdreNr	INTEGER NOT NULL,
	Dato VARCHAR(30), -- Endret fra integer til varchar blir på format yyyymmdd
	Tidspunkt VARCHAR(30), -- Endret fra integer til varchar blir på format HHMM
	KundeNr	INTEGER NOT NULL,
	CONSTRAINT KundeO_PK PRIMARY KEY (OrdreNr)
	CONSTRAINT KundeO_FK1 FOREIGN KEY (KundeNr) REFERENCES Kunde(KundeNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS OrdreForekomst(
	OrdreNr	INTEGER NOT NULL,
	TogruteForekomstID INTEGER NOT NULL,
	CONSTRAINT OrdreF_PK PRIMARY KEY (OrdreNr, TogruteForekomstID)
	CONSTRAINT OrdreF_FK1 FOREIGN KEY (OrdreNr) REFERENCES Plass(OrdreNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT OrdreF_FK2 FOREIGN KEY (TogruteForekomstID) REFERENCES TogruteForekomst(TogruteForekomstID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Billett(
	BillettID INTEGER NOT NULL,
	OrdreNr	INTEGER NOT NULL,
	CONSTRAINT Billett_PK PRIMARY KEY (BillettID)
	CONSTRAINT Billett_FK1 FOREIGN KEY (OrdreNr) REFERENCES Plass(OrdreNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Vogn(
	RegNr INTEGER NOT NULL,
	CONSTRAINT RegNr_PK PRIMARY KEY (RegNr)
);


CREATE TABLE IF NOT EXISTS HarVogner(
	OperatørNavn VARCHAR(30),
	RuteID 	INTEGER NOT NULL,
	RegNr INTEGER NOT NULL,
	CONSTRAINT HarV_PK PRIMARY KEY (OperatørNavn, RuteID, RegNr)
	CONSTRAINT HarV_FK1 FOREIGN KEY (OperatørNavn) REFERENCES Operatør(OperatørNavn)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT HarV_FK2 FOREIGN KEY (RegNr) REFERENCES Vogn(RegNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT DelS_FK2 FOREIGN KEY (RuteID) REFERENCES Togrute(RuteID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Sovevogn(
	RegNr INTEGER NOT NULL,
	AntallKupe	INTEGER,
	AntallSengerPerKupe INTEGER, -- Lagt til AntallSengerPerKupe ettersom vi ikke har sovekupé som egen entitetsklasse
	CONSTRAINT SitteV_PK PRIMARY KEY (RegNr)
	CONSTRAINT SitteV_FK1 FOREIGN KEY (RegNr) REFERENCES Vogn(RegNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Sittevogn(
	RegNr INTEGER NOT NULL,
	AntallRader INTEGER, --Lagt til antall rader
	SeterPerRad	INTEGER,
	CONSTRAINT SitteV_PK PRIMARY KEY (RegNr)
	CONSTRAINT SitteV_FK1 FOREIGN KEY (RegNr) REFERENCES Vogn(RegNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Plass(
	PlassNR	INTEGER NOT NULL,
	BillettID INTEGER NOT NULL,
	CONSTRAINT Plass_PK PRIMARY KEY (PlassNR, BillettID)
	CONSTRAINT Plass_FK1 FOREIGN KEY (BillettID) REFERENCES Billett(BillettID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Senger(
	SengNR INTEGER NOT NULL,
	PlassNr	INTEGER NOT NULL,
	CONSTRAINT Senger_PK PRIMARY KEY (SengNR, PlassNr)
	CONSTRAINT Senger_FK1 FOREIGN KEY (PlassNr) REFERENCES Plass(PlassNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Seter(
	SeteNR INTEGER NOT NULL,
	PlassNr	INTEGER NOT NULL,
	CONSTRAINT Seter_PK PRIMARY KEY (SeteNR, PlassNr)
	CONSTRAINT Seter_FK1 FOREIGN KEY (PlassNr) REFERENCES Plass(PlassNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

-- Lagt til ny tabell Mellomstasjon
CREATE TABLE IF NOT EXISTS Mellomstasjon(
	StasjonNavn	VARCHAR(30),
	RuteID 	INTEGER NOT NULL,
	Ankomsttid VARCHAR(30),
	Avgangsstid	VARCHAR(30),
	CONSTRAINT Mellomstasjon_PK PRIMARY KEY (StasjonNavn, Ankomsttid, RuteID)
	CONSTRAINT Mellomstasjon_FK1 FOREIGN KEY (StasjonNavn) REFERENCES Jerbanestasjon(StasjonNavn)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT Mellomstasjon_FK2 FOREIGN KEY (RuteID) REFERENCES Togrute(RuteID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);



	








