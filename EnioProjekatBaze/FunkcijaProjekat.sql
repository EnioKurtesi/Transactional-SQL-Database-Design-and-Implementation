
if OBJECT_ID('Konferencija.PrvaFunkcija', 'TF') is not null
drop function Konferencija.PrvaFunkcija
go
CREATE FUNCTION Konferencija.PrvaFunkcija
(
     
    @valuta  as varchar(30)
)
RETURNS @returntable TABLE 
(
	ime varchar(30),
	prezime varchar(30),
	vrsta_kotizacije varchar(30),
	iznos_kotizacije int,
	adresa varchar(200),
	broj_telefona varchar(30),
	godine int
)
AS
BEGIN
    INSERT @returntable
    SELECT distinct ime,prz,vrsta_kot, iznos_kot, cast(postanski_br as varchar)+ ' ' + mesto_prebivalista + ' ' + adresa,
	case when drzava='Srbija' then concat('+381',substring(telefon,2,len(telefon))) 
	when drzava = 'Crna Gora' then concat('+382',substring(telefon,2,len(telefon))) 
	when drzava = 'BiH' then concat('+387',substring(telefon,2,len(telefon)))
	end, datediff(year,datum_rodjenja, getdate()) from konferencija.Ucesnik inner join Konferencija.Ucestvuje on (Konferencija.Ucesnik.id_ucesnik = Konferencija.Ucestvuje.id_ucesnik)
	inner join konferencija.konferencija on (konferencija.konferencija.id_konf = konferencija.ucestvuje.id_konf)
	inner join konferencija.ima on (konferencija.ima.id_konf = konferencija.konferencija.id_konf)
	inner join konferencija.kotizacija on ( konferencija.kotizacija.id_kot = konferencija.ima.id_kot)
	where konferencija.kotizacija.id_kot in (select id_kot from konferencija.kotizacija where valuta = @valuta)
    RETURN 
END


select * from Konferencija.PrvaFunkcija('euro')



if OBJECT_ID('Konferencija.DrugaFunkcija', 'FN') is not null
drop function Konferencija.DrugaFunkcija
go
CREATE FUNCTION Konferencija.DrugaFunkcija
(
   
	@idPredavac int
)
RETURNS varchar(400)
AS
BEGIN

    declare @imePredavaca varchar(30);
	declare @prezimePredavaca varchar(30);
	declare @institucijaPredavaca varchar(30);
	declare @cenaPredavaca int;
	declare @adresaPredavaca varchar(100);
	declare @prosecnaCena numeric(10,2);
	declare @brojUcesnika int;
	declare @datumKonferencije date;
	declare @proveraPredavaca int;
	declare @proveraUcesnika int;
	declare @return varchar(400);
	declare @razlika numeric(10,2);
	set @proveraPredavaca = ( select count(*) from konferencija.Ucesnik_Poziv where id_ucesnik_poziv = @idPredavac);
	set @proveraUcesnika = ( select count(*) from konferencija.ucesnik where id_ucesnik = @idpredavac);
	if(@proveraPredavaca = 0 and @proveraUcesnika = 1)
	begin
	set @return ='Id koji ste prosledili pripada ucesniku koji ucestvuje na konferencijama, ali nije predavaè';
	end
	else if(@proveraPredavaca = 0 and @proveraUcesnika = 0)
	begin
	set @return = 'Prosledili ste nepoznat ID. Ta osoba nije ni predavaè ni uèesnik.';
	end
	else
	begin
			set @imePredavaca = ( select ime from konferencija.ucesnik join konferencija.ucesnik_poziv on 
			( konferencija.ucesnik.id_ucesnik = konferencija.ucesnik_poziv.id_ucesnik_poziv) where konferencija.ucesnik_poziv.id_ucesnik_poziv = @idPredavac);
			set @prezimePredavaca = ( select prz from konferencija.ucesnik join konferencija.ucesnik_poziv on 
			( konferencija.ucesnik.id_ucesnik = konferencija.ucesnik_poziv.id_ucesnik_poziv) where konferencija.ucesnik_poziv.id_ucesnik_poziv = @idPredavac);
			set @institucijaPredavaca = ( select institucija from konferencija.ucesnik join konferencija.ucesnik_poziv on 
			( konferencija.ucesnik.id_ucesnik = konferencija.ucesnik_poziv.id_ucesnik_poziv) where konferencija.ucesnik_poziv.id_ucesnik_poziv = @idPredavac);
			set @cenaPredavaca = ( select cena from konferencija.ucesnik_poziv where konferencija.ucesnik_poziv.id_ucesnik_poziv = @idPredavac);
			set @adresaPredavaca = ( select adresa from konferencija.ucesnik join konferencija.ucesnik_poziv on 
			( konferencija.ucesnik.id_ucesnik = konferencija.ucesnik_poziv.id_ucesnik_poziv) where konferencija.ucesnik_poziv.id_ucesnik_poziv = @idPredavac);
			set @prosecnaCena = ( select avg(cena) from konferencija.ucesnik_poziv);
			set @datumKonferencije = ( select top 1 datum_konf from konferencija.konferencija inner join konferencija.predaje_na on
			(konferencija.konferencija.id_konf = konferencija.predaje_na.id_konf)
			where konferencija.predaje_na.id_ucesnik_poziv = @idPredavac order by datum_konf desc);

			set @brojUcesnika = ( select count(id_ucesnik) from konferencija.ucestvuje 
			where id_konf in ( select id_konf from konferencija.konferencija where datum_konf = @datumKonferencije))

			if(@cenaPredavaca > @prosecnaCena)
			begin
			set @razlika = @cenaPredavaca - @prosecnaCena
			set @return = concat('Predavac sa ID-em ',@idPredavac, 'je: ', @imePredavaca,' ',@prezimePredavaca, ' sa adresom ',@adresaPredavaca,
			' i njegova cena je: ', @cenaPredavaca,' i to je 
			 za  ', @razlika,' veca od prosecne cene predavaca. Poslednja konferencija na kojoj je predavao je odrzana ',@datumKonferencije, 'i na njoj je bilo ',
			 @brojUcesnika,' ucesnika');
			end
			else if(@cenaPredavaca < @prosecnaCena)
			begin
			set @razlika = @prosecnaCena - @cenaPredavaca
			set @return = concat('Predavac sa ID-em ',@idPredavac, 'je: ', @imePredavaca,' ',@prezimePredavaca, ' sa adresom ',@adresaPredavaca,
			' i njegova cena je: ', @cenaPredavaca,' i to je 
			 za  ', @razlika,' manja od prosecne cene predavaca. Poslednja konferencija na kojoj je predavao je odrzana ',@datumKonferencije, 'i na njoj je bilo ',
			 @brojUcesnika,' ucesnika');
			end
			if(@cenaPredavaca = @prosecnaCena)
			begin
			set @return = concat('Predavac sa ID-em ',@idPredavac, 'je: ', @imePredavaca,' ',@prezimePredavaca, ' sa adresom ',@adresaPredavaca,
			' i njegova cena je: ', @cenaPredavaca,' i to je 
			 jednako prosecnoj ceni predavaca. Poslednja konferencija na kojoj je predavao je odrzana ',@datumKonferencije, 'i na njoj je bilo ',
			 @brojUcesnika,' ucesnika');
			end
			
	end

	return @return;
END


print konferencija.DrugaFunkcija(25)

select * from konferencija.konferencija