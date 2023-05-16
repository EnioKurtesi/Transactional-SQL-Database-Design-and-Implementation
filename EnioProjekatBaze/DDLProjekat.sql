if OBJECT_ID('Konferencija.Ima', 'U') is not null
drop table Konferencija.Ima
if OBJECT_ID('Konferencija.Ucestvuje', 'U') is not null
drop table Konferencija.Ucestvuje
go
if object_id ('Konferencija.Predaje_na','U') is not null
	drop table Konferencija.Predaje_na;
go
if object_id ('Konferencija.Sponzorise','U') is not null
	drop table Konferencija.Sponzorise;
go
if object_id ('Konferencija.Angazovan_za','U') is not null
	drop table Konferencija.Angazovan_za;
go
if object_id ('Konferencija.Odrzava_se','U') is not null
	drop table Konferencija.Odrzava_se;
go
if object_id ('Konferencija.Ucesnik_Poziv','U') is not null
	drop table Konferencija.Ucesnik_Poziv;
go
if object_id ('Konferencija.Redovni_Ucesnik','U') is not null
	drop table Konferencija.Redovni_Ucesnik;
go
if object_id ('Konferencija.Slusalac','U') is not null
	drop table Konferencija.Slusalac;
go



if object_id ('Konferencija.Ucesnik','U') is not null
	drop table Konferencija.Ucesnik;
go
if object_id('Konferencija.SEQ_id_ucesnik','SO') is not null
	drop sequence Konferencija.SEQ_id_ucesnik;

go
if object_id ('Konferencija.Kotizacija','U') is not null
	drop table Konferencija.Kotizacija;
go
if object_id('Konferencija.SEQ_id_kot','SO') is not null
	drop sequence Konferencija.SEQ_id_kot;

go

go
if object_id ('Konferencija.Prezentacija','U') is not null
	drop table Konferencija.Prezentacija;
go
if object_id('Konferencija.SEQ_id_prezentacija','SO') is not null
	drop sequence Konferencija.SEQ_id_prezentacija;

go

if object_id ('Konferencija.Konferencija','U') is not null
	drop table Konferencija.Konferencija;
go
if object_id('Konferencija.SEQ_id_konf','SO') is not null
	drop sequence Konferencija.SEQ_id_konf;

go
if object_id ('Konferencija.Donator','U') is not null
	drop table Konferencija.Donator;
go
if object_id('Konferencija.SEQ_id_don','SO') is not null
	drop sequence Konferencija.SEQ_id_don;

go
if object_id ('Konferencija.Recezent','U') is not null
	drop table Konferencija.Recezent;
go
if object_id('Konferencija.SEQ_id_recezent','SO') is not null
	drop sequence Konferencija.SEQ_id_recezent;

go
go
if object_id ('Konferencija.Sala','U') is not null
	drop table Konferencija.Sala;
go
if object_id('Konferencija.SEQ_id_sale','SO') is not null
	drop sequence Konferencija.SEQ_id_sale;

go
if schema_id ('Konferencija') is not null
	drop schema Konferencija;
go
create schema Konferencija
go


go
create sequence Konferencija.SEQ_id_ucesnik as int
start with 1
increment by 1
no cycle
go
create sequence Konferencija.SEQ_id_kot as int
start with 1
increment by 1
no cycle
go
create sequence Konferencija.SEQ_id_prezentacija as int
start with 1
increment by 1
no cycle
go
create sequence Konferencija.SEQ_id_konf as int
start with 1
increment by 1
no cycle
go
go
create sequence Konferencija.SEQ_id_don as int
start with 1
increment by 1
no cycle
go
create sequence Konferencija.SEQ_id_recezent as int
start with 1
increment by 1
no cycle
go
create sequence Konferencija.SEQ_id_sale as int
start with 1
increment by 1
no cycle
go

create table Konferencija.Ucesnik(

id_ucesnik numeric(8) constraint DFT_Ucesnik_id_ucesnik default(next value for Konferencija.SEQ_id_ucesnik) not null,
ime varchar(18) not null,
sr_slovo varchar(3),
prz varchar(18) not null,
mail varchar(30) not null,
adresa varchar(30) not null,
drzava varchar(20) not null,
postanski_br numeric(10) not null,
institucija  varchar(30),
mesto_prebivalista varchar(30) not null,
telefon varchar(20) not null,
datum_rodjenja date constraint DFT_datum_rodjenja default (sysdatetime()),

constraint PK_Ucesnik primary key(id_ucesnik),
constraint CHK_postanski_br check(len(postanski_br)>=5),
constraint CHK_telefon_ucesnika check(telefon like '06%'),







);






create table Konferencija.Ucesnik_Poziv(
id_ucesnik_poziv numeric(8) not null,
odgovor varchar(2) not null,
cena decimal(9) not null

constraint PK_Ucesnik_Poziv primary key (id_ucesnik_poziv),
constraint FK_Ucesnik_Poziv_id_ucesnik_poziv foreign key (id_ucesnik_poziv) references Konferencija.Ucesnik (id_ucesnik),
constraint CHK_odgovor check(odgovor in ('da', 'ne')),

);


create table Konferencija.Kotizacija(
id_kot numeric(8) not null constraint DFT_Kotizacija_id_kot default (next value for Konferencija.SEQ_id_kot),
iznos_kot numeric(8) not null,
vrsta_kot varchar(15) not null,
valuta varchar(20) not null,


constraint PK_Kotizacija primary key(id_kot),
constraint CHK_vrsta_kot check(vrsta_kot in('studentska','redovna')),
constraint CHK_valuta check(valuta in ('euro', 'din')),
constraint CHK_iznos_kot check(iznos_kot > 0),

);
create table Konferencija.Slusalac(
id_slusalac numeric(8) not null,
id_kot numeric(8) not null,


constraint PK_Slusalac primary key (id_slusalac),
constraint FK_Slusalac_id_slusalac foreign key (id_slusalac) references Konferencija.Ucesnik (id_ucesnik),
constraint FK_Slusalac_id_kot foreign key (id_kot) references Konferencija.Kotizacija(id_kot)

);
create table Konferencija.Redovni_Ucesnik(
id_redovni_ucesnik numeric(8) not null,
id_kot numeric(8) not null,
constraint PK_Redovni_Ucesnik primary key (id_redovni_ucesnik),
constraint FK_Redovni_Ucesnik_id_redovni_ucesnik foreign key (id_redovni_ucesnik) references Konferencija.Ucesnik (id_ucesnik),
constraint FK_Redovni_Ucesnik_id_kot foreign key (id_kot) references Konferencija.Kotizacija(id_kot)
);



create table Konferencija.Prezentacija(
id_prezentacija numeric(8) not null constraint DFT_Prezentacija_id_prezentacija default (next value for Konferencija.SEQ_id_prezentacija),
vreme_pocetka date constraint  DFT_vreme_pocetka default (sysdatetime()),
vreme_zavrsetka date constraint DFT_vreme_zavrsetka default (sysdatetime()),

constraint PK_Prezentacija primary key(id_prezentacija),
constraint CHK_vreme check(vreme_pocetka < vreme_zavrsetka),


);



create table Konferencija.Konferencija(

id_konf numeric(8) constraint DFT_Konferencija_id_konf default(next value for Konferencija.SEQ_id_konf) not null,
naziv_konf varchar(18) not null,
datum_konf date not null constraint DFT_datum_konf default (sysdatetime()),
kraj_konf date not null constraint DFT_kraj_konf default (sysdatetime()),
broj_organizatora numeric(7) not null,
max_br_koaut numeric(4) not null,
max_br_rad numeric(4) not null,
dat_sl_abs date not null,
dat_sl_rad date not null,




constraint PK_Konferencija primary key(id_konf),
constraint CHK_datum_sl check(dat_sl_abs < dat_sl_rad),

);

create table Konferencija.Donator(

id_don numeric(8) constraint DFT_Donator_id_don default(next value for Konferencija.SEQ_id_don) not null,
ime_don varchar(18) not null,
adresa_don varchar(30) not null,
mail_don varchar(30) not null,
nacin_don  varchar(30) not null,
obavesten_don varchar(2) not null,



constraint PK_Donator primary key(id_don),
constraint CHK_nacin_don check(nacin_don in('robna', 'novcana')),
constraint CHK_obavesten check(obavesten_don in('da', 'ne')),

);






create table Konferencija.Recezent(

id_recezent numeric(8) constraint DFT_Recezent_id_recezent default(next value for Konferencija.SEQ_id_recezent) not null,
ime_rec varchar(18) not null,
prz_rec varchar(18) not null,
struka_rec varchar(30) not null,
constraint PK_Recezent primary key(id_recezent),





);


create table Konferencija.Sala(

id_sale numeric(8) constraint DFT_Sala_id_sale default(next value for Konferencija.SEQ_id_sale) not null,
br_sale numeric(8) not null,
kapacitet_sale numeric(7) not null,




constraint PK_Sala primary key(id_sale),
constraint CHK_kapacitet check(kapacitet_sale > 50),


);


create table Konferencija.Odrzava_se (
id_konf numeric(8) not null,
id_sale numeric(8) not null,


constraint PK_Odrzava_se primary key (id_konf, id_sale),
constraint FK_Odrzava_se_id_konf foreign key (id_konf) references Konferencija.Konferencija (id_konf) on delete cascade,
constraint FK_Odrzava_se_id_sale foreign key (id_sale) references Konferencija.Sala (id_sale) on delete cascade,
);



create table Konferencija.Angazovan_za (
id_recezent numeric(8) not null,
id_konf numeric(8) not null,


constraint PK_Angazovan_za primary key (id_recezent, id_konf),
constraint FK_Angazovan_za_id_rec foreign key (id_recezent) references Konferencija.Recezent (id_recezent) on delete cascade,
constraint FK_Angazovan_za_id_konf foreign key (id_konf) references Konferencija.Konferencija (id_konf) on delete cascade,
);


create table Konferencija.Sponzorise (
id_don numeric(8) not null,
id_konf numeric(8) not null,


constraint PK_Sponzorise primary key (id_don, id_konf),
constraint FK_Sponzorise_id_don foreign key (id_don) references Konferencija.Donator (id_don) on delete cascade,
constraint FK_Sponzorise_id_konf foreign key (id_konf) references Konferencija.Konferencija (id_konf) on delete cascade,
);



create table Konferencija.Predaje_na (
id_ucesnik_poziv numeric(8) not null,
id_konf numeric(8) not null,
id_prezentacija numeric(8) not null,



constraint PK_Predaje_na primary key (id_konf, id_ucesnik_poziv),
constraint FK_Predaje_na_id_ucesnik foreign key (id_ucesnik_poziv) references Konferencija.Ucesnik_Poziv (id_ucesnik_poziv) on delete cascade,
constraint FK_Predaje_na_id_konf foreign key (id_konf) references Konferencija.Konferencija (id_konf) on delete cascade,
constraint FK_Predaje_na_id_prezentacija foreign key (id_prezentacija) references Konferencija.Prezentacija (id_prezentacija) on delete cascade,
);


create table Konferencija.Ucestvuje (

id_ucesnik numeric(8) not null,
id_konf numeric(8) not null
constraint PK_Ucestvuje primary key (id_ucesnik, id_konf),
constraint FK_Ucestvuje_id_ucesnik foreign key (id_ucesnik) references Konferencija.Ucesnik (id_ucesnik) on delete cascade,
constraint FK_Ucestvuje_id_konf foreign key (id_konf) references Konferencija.Konferencija (id_konf) on delete cascade,


);


create table Konferencija.Ima (

id_kot numeric(8) not null,
id_konf numeric(8) not null


constraint PK_Ima primary key (id_kot, id_konf),
constraint FK_Ima_id_kot foreign key (id_kot) references Konferencija.Kotizacija (id_kot) on delete cascade,
constraint FK_Ima_id_konf foreign key (id_konf) references Konferencija.Konferencija (id_konf) on delete cascade,



);


