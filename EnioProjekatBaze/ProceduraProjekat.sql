Na osnovu ID konferencije, izlistava njeno ime, datum pocetka, datum zavrsetka,
	ako nema konferencije napisati poruku
	ako ima konferencije a niko nije predavao ispisati poruku
	izlistati podatke o predavacima na konferenciji
	select * from Konferencija.Predaje_na
	select * from Konferencija.konferencija
	select * from Konferencija.Recezent
	select * from Konferencija.Ucesnik
	if OBJECT_ID('Konferencija.PrvaProcedura' ,'P') is not null
	drop proc Konferencija.PrvaProcedura
	go

	create proc Konferencija.PrvaProcedura

	@konferencijaId as int
	as
	begin

		declare @nazivKonferencije as varchar(30);
		declare @datumKonferencije as date;
		declare @krajKonferencije as date;
		declare @ukupnoPredavaca as int;
		declare @proveraKonferencije as int;
		declare @ukupnaCena as numeric(10,2);
		declare @imePredavaca as varchar(30);
		declare @prezimePredavaca as varchar(40);
		declare @adresaPredavaca as varchar(70);
		declare @institucijaPredavaca as varchar(50);
		declare @datumRodjenjaPredavaca as date;
		declare @redniBroj as int;
		declare @cena as int;

		set @proveraKonferencije = ( select COUNT(*) from Konferencija.Konferencija where id_konf = @konferencijaId);
		set @ukupnoPredavaca = ( select COUNT(id_ucesnik_poziv) from Konferencija.Predaje_na where id_konf = @konferencijaId);
		set @datumKonferencije = ( select datum_konf from Konferencija.Konferencija where id_konf = @konferencijaId);
		set @krajKonferencije = ( select kraj_konf from Konferencija.Konferencija where id_konf = @konferencijaId);


		set @ukupnaCena = ( select sum(up.cena) from Konferencija.Ucesnik_Poziv up left join Konferencija.Predaje_na pn on (up.id_ucesnik_poziv = pn.id_ucesnik_poziv)
				left join Konferencija.Konferencija k on (k.id_konf = pn.id_konf) where k.id_konf = @konferencijaId)

		if(@proveraKonferencije = 0)
		begin
		print('Ne postoji konferencija sa tim ID-em')
		return;
		end

		if(@ukupnoPredavaca = 0)
		begin
		print concat ('Na konferenciji sa ID-em', ' ', @konferencijaId, ' ', 'nema predavača');
		end
		else
		begin
			declare cursor_prva cursor fast_forward for
			select u.ime, u.prz, u.adresa, u.institucija, u.datum_rodjenja, up.cena from Konferencija.Ucesnik_Poziv up  left join Konferencija.Ucesnik u on (up.id_ucesnik_poziv = u.id_ucesnik)
				left join Konferencija.Predaje_na pn on (up.id_ucesnik_poziv = pn.id_ucesnik_poziv) left join Konferencija.Konferencija k on (k.id_konf = pn.id_konf) where k.id_konf = @konferencijaId
			open cursor_prva
			set @redniBroj = 1;
			fetch next from cursor_prva into  @imePredavaca, @prezimePredavaca, @adresaPredavaca, @institucijaPredavaca, @datumRodjenjaPredavaca, @cena
			print concat ('Na konferenciji sa ID-em', ' ', @konferencijaId, ' ', 'koja počinje' , ' ', @datumKonferencije, ' ' , 'a završava se' , ' ' , @krajKonferencije, ' ' , 'su sledeći predavači:');
			while(@@FETCH_STATUS = 0)
			begin
			print concat(@redniBroj, '.', @imePredavaca, ' ' , @prezimePredavaca, ' ' ,@adresaPredavaca, ' ' ,@institucijaPredavaca, ' ' ,@datumRodjenjaPredavaca, ' ', @cena);
			set @redniBroj = @redniBroj+1;
			fetch next from cursor_prva into  @imePredavaca, @prezimePredavaca, @adresaPredavaca, @institucijaPredavaca, @datumRodjenjaPredavaca, @cena
			end
			close cursor_prva
			deallocate cursor_prva
			print ('Ukupno predavača:' + cast(@ukupnoPredavaca as varchar));
			print ('Ukupno novca koliko treba izdvojiti za predavače =' + cast(@ukupnaCena as varchar));

		end
	

	end

	

	exec Konferencija.PrvaProcedura 75
	



	if OBJECT_ID('Konferencija.DrugaProc', 'P') is not null
	drop proc Konferencija.DrugaProc
	go

	

	create proc Konferencija.DrugaProc
	@donatorId as int
	as
	begin

	declare @imeDonatora as varchar(30);
	declare @proveraDonatora as int;
	declare @mailDonatora as varchar(30);
	declare @gradDonatora as varchar(30);
	declare @ukupnoKonferencija as int;
	declare @imeKonferencije as varchar(30);
	declare @maxAutora as int;
	declare @brojOrganizatora as int;
	declare @redniBroj as int;
	declare @nacinDoniranja as varchar(30);

	set @imeDonatora = ( select ime_don from Konferencija.Donator where id_don = @donatorId);
	set @mailDonatora = ( select mail_don  from Konferencija.donator where id_don = @donatorId);
	set @proveraDonatora = ( select COUNT(*) from Konferencija.Donator where id_don = @donatorId);
	set @ukupnoKonferencija = ( select COUNT(id_konf) from Konferencija.Sponzorise where id_don = @donatorId);
	set @gradDonatora = ( select adresa_don from Konferencija.Donator where id_don = @donatorId)
	
	if(@proveraDonatora = 0)
	begin
	print('Ne postoji donator sa tim ID-em');
	return;
	end

	if(@ukupnoKonferencija = 0)
	begin
	print('Donator nije donirao nigde');
	end
	else

	begin

			declare cursor_druga cursor fast_forward for
			select k.naziv_konf, k.broj_organizatora, k.max_br_rad, nacin_don from Konferencija.Konferencija k left join Konferencija.Sponzorise s on (k.id_konf = s.id_konf) left join konferencija.donator d on (d.id_don = s.id_don) where d.id_don = @donatorId 
			open cursor_druga
			set @redniBroj = 1;
			print concat ('Donator', ' ', @imeDonatora, ' ', 'iz grada:', ' ' , @gradDonatora, ' ', 'sa mailom:', ' ', @mailDonatora, ' ',  'je sponzorisao sledeće konferencije:');
			fetch next from cursor_druga into @imeKonferencije, @brojOrganizatora, @maxAutora, @nacinDoniranja
			while (@@FETCH_STATUS = 0)
			begin

			print concat(@redniBroj, ' ' , @imeKonferencije, ' ' , @brojOrganizatora,  ' ', @nacinDoniranja);
			set @redniBroj= @redniBroj +1;
			fetch next from cursor_druga into @imeKonferencije, @brojOrganizatora, @maxAutora, @nacinDoniranja

			end

			close cursor_druga
			deallocate cursor_druga

			print ('Ukupno konferencija:' + cast (@ukupnoKonferencija as varchar));
		


	end

		
		
	end

	exec Konferencija.DrugaProc 85
