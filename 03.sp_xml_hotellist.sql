--sp_xml_hotellist 'OM','','','','001426'  
drop procedure sp_xml_hotellist
go
create procedure sp_xml_hotellist
(  
 @CtryCode varchar(100),  
 @CityCode varchar(100),   
 @Sectorcode varchar(100),  
 @CatCode varchar(100),  
 @agentCode  varchar(100)=''  
)  
as  
begin  
	execute sp_getxmlhotellist @CtryCode, @CityCode, @Sectorcode, @CatCode, @agentCode
end
