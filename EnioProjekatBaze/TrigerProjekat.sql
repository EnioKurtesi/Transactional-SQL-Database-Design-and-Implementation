select * from konferencija.ima where id_konf=5
delete from konferencija.ima where id_konf= 5 and id_kot=3
--obrisano ovo iz dmla

if object_id('Konferencija.PrvaTrigercuga','TR') is not null
	drop trigger Konferencija.PrvaTrigercuga;
go
create trigger Konferencija.PrvaTrigercuga
on konferencija.predaje_na
after insert,update
as
begin
declare @stariPredavac as int;
declare @noviPredavac as int;
declare @godine as int;
declare @odgovor as varchar(2);

set @stariPredavac = (select id_ucesnik_poziv from deleted);
set @noviPredavac = (select id_ucesnik_poziv from inserted);

if(@stariPredavac<>@noviPredavac or @stariPredavac is null)
begin
set @godine = (select DATEDIFF(year,datum_rodjenja,getdate()) from Konferencija.Ucesnik where id_ucesnik=@noviPredavac);
set @odgovor = (select odgovor from Konferencija.Ucesnik_Poziv where id_ucesnik_poziv=@noviPredavac);
if(@godine<18)
begin
raiserror('Nije moguæe postaviti maloletnu osobu za predavaèa na konferenciji!',16,0);
rollback transaction;
end
else if (@odgovor='ne')
begin
raiserror('Nije moguæe postaviti osobu za predavaèa na konferenciji koja je odbila da predaje na konferenciji!',16,0);
rollback transaction;
end
end
end

insert into Konferencija.Ucesnik (ime,sr_slovo,prz,mail,adresa,drzava,postanski_br,institucija,mesto_prebivalista,telefon,datum_rodjenja)
values ('Lazar','B','Milic','robot@example.com','Gagarinova 25','Srbija',14000,'FTN','Cacak','0641515225','2006-07-31');

select * from Konferencija.Ucesnik

insert into Konferencija.Ucesnik_Poziv values (31,'da',0)

select * from Konferencija.Ucesnik_Poziv

insert into Konferencija.Predaje_na values(31,3,1)

select * from Konferencija.Predaje_na

update Konferencija.Ucesnik_Poziv 
set odgovor='NE'
where id_ucesnik_poziv = 31

update Konferencija.Ucesnik 
set datum_rodjenja = ' 1995-04-04'
where id_ucesnik=31


select * from Konferencija.ucesnik

if object_id('Konferencija.FunnyTrigger','TR') is not null
	drop trigger Konferencija.FunnyTrigger;
go
create trigger Konferencija.FunnyTrigger
on konferencija.ucestvuje
after insert,update
as
begin
declare @noviUcesnik as int;
declare @stariUcesnik as int;
declare @kotizacija as int;
declare @proveriDaLiJeRedovniUcesnik as int;
declare @proveriDaLiJeSlusalac as int;
declare @konferencija as int;

set @noviUcesnik = (select id_ucesnik from inserted);
set @stariUcesnik = (select id_ucesnik from deleted);
set @konferencija = (select id_konf from inserted)
set @proveriDaLiJeRedovniUcesnik = (select count(*) from Konferencija.Redovni_Ucesnik where id_redovni_ucesnik=@noviUcesnik);
set @proveriDaLiJeSlusalac = (select count(*) from Konferencija.Slusalac where id_slusalac=@noviUcesnik);
if(@proveriDaLiJeRedovniUcesnik!=0)
begin
set @kotizacija = (select id_kot from Konferencija.Redovni_Ucesnik where id_redovni_ucesnik=@noviUcesnik );
if(@stariUcesnik<>@noviUcesnik or @stariUcesnik is null )
begin
if(@kotizacija is null)
begin
raiserror('Nije moguce dodati ucesnika na konferenciju koji je redovni ucesnik a nije platio kotizaciju',16,0);
rollback transaction;
end
else if (@kotizacija not in (select id_kot from Konferencija.ima where id_konf = @konferencija))
begin
raiserror('Nije moguce dodati ucesnika na konferenciju koji je redovni ucesnik a platio je kotizaciju koju data konferencija ne podrzava',16,0);
rollback transaction;
end
end
end
else if(@proveriDaLiJeSlusalac!=0)
begin
set @kotizacija = (select id_kot from Konferencija.Slusalac where id_slusalac=@noviUcesnik );
if(@stariUcesnik<>@noviUcesnik or @stariUcesnik is null )
begin
if(@kotizacija is null)
begin
raiserror('Nije moguce dodati ucesnika na konferenciju koji je slusalac a nije platio kotizaciju',16,0);
rollback transaction;
end
else if (@kotizacija not in (select id_kot from Konferencija.ima where id_konf = @konferencija))
begin
raiserror('Nije moguce dodati ucesnika na konferenciju koji je slusalac a platio je kotizaciju koju data konferencija ne podrzava',16,0);
rollback transaction;
end
end
end
end

select * from konferencija.Redovni_Ucesnik 
update 

select * from Konferencija.Ucestvuje

delete from Konferencija.Ucestvuje
where id_ucesnik=22 and id_konf=5

insert into Konferencija.Ucestvuje values (22,5)