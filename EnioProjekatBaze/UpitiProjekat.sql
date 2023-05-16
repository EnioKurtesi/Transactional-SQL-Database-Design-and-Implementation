--izlistati ime i vrstu sponzorstva donatora, naziv konferencije na kojoj je donirao
--samo sa one konferencije koje se odrzavaju u salama koje imaju kapacitet veci od prosečnog kapaciteta


select distinct ime_don, nacin_don, naziv_konf
from Konferencija.donator d join Konferencija.sponzorise s on (d.id_don = s.id_don)
	join Konferencija.Konferencija k on (k.id_konf = s.id_konf)
	join Konferencija.Odrzava_se od on (od.id_konf = k.id_konf)
	join Konferencija.Sala sala on (sala.id_sale = od.id_sale)
	where kapacitet_sale < (select avg (kapacitet_sale) from Konferencija.Sala)
	group by ime_don, nacin_don, naziv_konf
	order by naziv_konf desc;


	--Izlistati inicijale ucesnika koji je najmladji, instituciju odakle dolazi, vrstu kotizacije koju je platio,ako je NULL napisati da ne treba da placa, valutu,ako placa, ako ne ne mora nista, i godinu rodjenja 
	select left(ime,1)+ left(prz,1) as 'Inicijali najmladjeg', institucija as 'Institucija', 
	iif(vrsta_kot is not null,vrsta_kot, 'Nije platio kotizaciju,pozvan je') as 'Vrsta kotizacije', 
	iif(valuta is not null,valuta,'Ne treba da plati') as 'Valuta', datepart(year, datum_rodjenja) as 'godina rodjenja'
	from Konferencija.Ucesnik u left join Konferencija.Slusalac s on (u.id_ucesnik = s.id_slusalac)
	left join Konferencija.Redovni_Ucesnik ru on (u.id_ucesnik = ru.id_redovni_ucesnik)
	left join Konferencija.Kotizacija k on (k.id_kot = ru.id_kot)
	where datum_rodjenja = (select max(datum_rodjenja) from Konferencija.Ucesnik) 
	group by ime,institucija,vrsta_kot, valuta, prz,datum_rodjenja



	--Izlistati ime i prezime predavača u jednoj koloni kao "Ime i prezime predavača", instituciju odakle dolazi, izlistati cenu njegovog angažovanja za konferenciju
	--Neophodno je izlistati i naziv konferencije. U obzir uzeti samo one konferencije koje se održavaju u nedelju kao i onog predavača
	-- za kog je potrebno platiti najviše novca da bi održao svoje predavanje. Izlistati i broj donatora na toj konferenciji.

	select distinct ime + ' ' + prz as 'Ime i prezime predavača', cena as 'Cena predavača', naziv_konf as 'Naziv Konferencije', count(d.id_don) as 'Broj donatora'
	from Konferencija.Ucesnik u join Konferencija.Ucesnik_Poziv up on (u.id_ucesnik = up.id_ucesnik_poziv)
	join Konferencija.Predaje_na pn on (pn.id_ucesnik_poziv = up.id_ucesnik_poziv)
	join Konferencija.Konferencija k on (k.id_konf = pn.id_konf)
	join Konferencija.Sponzorise sp on (sp.id_konf = k.id_konf)
	join Konferencija.Donator d on (d.id_don = sp.id_don)
	join Konferencija.Prezentacija p on (p.id_prezentacija = pn.id_prezentacija)
	join Konferencija.Odrzava_se os on (os.id_konf = k.id_konf)
	join Konferencija.sala s on (s.id_sale = os.id_sale)
	where DATENAME(dw,datum_konf) = 'Sunday' and  cena = (select max(cena) from Konferencija.Ucesnik_Poziv)
	group by ime,prz, k.id_konf,br_sale, naziv_konf, datum_konf, cena 
	


	--Izlistava nazive svih konferencija, mesec u kom se odrzava svaka konferencija  
--Uz pomoc ovog upita vidimo neke osnovne informacije o konferencijama. Funkcija Month nam vraca mesec iz datuma kada je konferencija otvorena.
-- U interesu nam je da izlistamo samo one konferencije koje su dobile sredstva iz Toronta kao i koju vrstu donacije su dobili. Bitno je da je broj organizatora manji od prosecnog broja organizatora
select distinct naziv_konf as 'Konferencija',  MONTH(datum_konf) as 'Mesec odrzavanja',
DATEDIFF(day,datum_konf,kraj_konf) as 'Trajanje konferencije u danima', nacin_don as 'Vrsta donacije'
	from Konferencija.Konferencija k  join Konferencija.Angazovan_za az on (k.id_konf = az.id_konf)
		 join Konferencija.Recezent r on (r.id_recezent = az.id_recezent)
		join Konferencija.sponzorise s on (s.id_konf = k.id_konf)
		 join konferencija.donator d on (d.id_don = s.id_don)
		 where adresa_don = 'Toronto'
		group by naziv_konf, ime_rec, prz_rec, struka_rec,datum_konf,kraj_konf,nacin_don,broj_organizatora
		having broj_organizatora < (select avg(broj_organizatora) from Konferencija.konferencija)
		order by month(datum_konf) asc;
	
	
	
	--za svaku konferenciju izlistava najjeftnijeg predavaca 
	select k.naziv_konf as 'Naziv konferencije', u.ime + ' ' + u.prz as 'Ime i prezime najpovoljnijeg predavača', up.cena as 'Cena predavača'
		from Konferencija.Konferencija k  join Konferencija.Predaje_na pn on (k.id_konf = pn.id_konf)
			 join Konferencija.Ucesnik_Poziv up on (up.id_ucesnik_poziv = pn.id_ucesnik_poziv)
			 join Konferencija.Ucesnik u on (u.id_ucesnik = up.id_ucesnik_poziv)
			 join (select id_konf, min(cena) maksi from Konferencija.Ucesnik_Poziv  join Konferencija.Predaje_na  on ( Konferencija.Ucesnik_Poziv.id_ucesnik_poziv = Konferencija.Predaje_na.id_ucesnik_poziv) group by id_konf ) novaTab on k.id_konf = novaTab.id_konf
			 where up.cena = novaTab.maksi
			 order by k.naziv_konf desc;