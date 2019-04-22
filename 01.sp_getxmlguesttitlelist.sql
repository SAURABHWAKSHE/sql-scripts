--sp_getxmlguesttitlelist
--drop procedure sp_getxmlguesttitlelist
go
drop procedure sp_xml_guesttitlelist
go
create procedure sp_xml_guesttitlelist


as
begin 
	select t.TitleCode, t.TitleName from TitleMast t (nolock) where Active=1 and isnull(t.TitleForXML,0)=1 order by t.orderno
end

