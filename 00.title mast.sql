alter table TitleMast add TitleForAdult int, TitleForChild int, OrderNo int, TitleForXML int
go

begin tran
select * into TitleMastOld_17032019 from TitleMast
select * from TitleMast
delete from TitleMast

insert into TitleMast (TitleCode, TitleName, Active, TitleForAdult, TitleForChild, OrderNo)
select '--','0',1,1,1,1
union 
select 'Mr','Mr',1,1,0,2
union 
select 'Mrs','Mrs',1,1,0,3
union 
select 'Ms','Ms',1,1,0,4
union 
select 'Dr','Dr',1,1,0,5
union 
select 'Prof','Prof',1,1,0,6
union 
select 'Dr Mr','Dr Mr',1,1,0,7
union 
select 'Dr Mrs','Dr Mrs',1,1,0,8
union 
select 'Dr Ms','Dr Ms',1,1,0,9
union 
select 'Prof Mr','Prof Mr',1,1,0,10
union 
select 'Prof Mrs','Prof Mrs',1,1,0,11
union 
select 'Prof Ms','Prof Ms',1,1,0,12
--Child
union 
select 'Child','Child',1,0,1,13
union 
select 'Child Male','Child Male',1,0,1,14
union 
select 'Child Female','Child Female',1,0,1,15

update TitleMast set TitleForXML = 1
update TitleMast set TitleForXML = 0 where TitleCode='--'

select * from TitleMast order by orderno
--rollback tran
commit tran

alter table TitleMast add adddate datetime
go
update TitleMast set adddate = getdate()
go
alter table TitleMast add adduser varchar(100),moddate datetime,moduser varchar(100)
go
update TitleMast set adduser = 'admin', moddate=null, moduser=null
go