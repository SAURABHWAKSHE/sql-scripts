--sp_getxmlhotel_DescriptiveInfo '001426','000006'
--drop procedure sp_getxml_hotel_DescriptiveInfo
go
drop procedure sp_xml_hotel_DescriptiveInfo
go
create procedure sp_xml_hotel_DescriptiveInfo
(
	@agentCode varchar(100),
	@partycode	varchar(100)
)
as
begin
	declare @baseurl varchar(1000) = ''
	select top 1 @baseurl = option_selected from reservation_parameters (nolock) where param_id=5340

	declare @xmlmode int=0 --changed by mohamed on 20/02/2019  
	if exists(select top 1 't' from agentmast (nolock) where agentcode=@agentCode and isnull(xmlmode,0)=1)  
	begin  
		select @xmlmode=1
	end  

	select ISNULL(A.PartyName,'') PartyName,ISNULL(A.CurrCode,'') CurrCode,
	ISNULL(CONVERT(VARCHAR,B.Latitude),'') Latitude,ISNULL(CONVERT(VARCHAR,B.Longitude),'') Longitude,
	ISNULL(B.hoteltext,'') HotelOverView,ISNULL(A.Add1,'') Add1,ISNULL(A.Add2,'') Add2,ISNULL(A.Add3,'') Add3,
	ISNULL(A.Email,'') Email,ISNULL(A.SEmail,'') SEmail,'' Email_Online,ISNULL(A.Tel1,'') Tel1,
	ISNULL(A.Tel2,'') Tel2,ISNULL(A.Fax,'') Fax,ISNULL(A.SFax,'') SFax,ISNULL(A.Stel1,'') STel1,ISNULL(A.Stel2,'') STel2, 
	'' HotLine,ISNULL(A.WebSite,'') WebSite 
	, case when isnull(@baseurl,'')='' or isnull(b.imagename,'')='' then '' else 
			@baseurl + '/PriceListModule/UploadedImages/' + isnull(b.imagename,'') end hotelimageurl
	into #partymaindet
	FROM PartyMast A 
	LEFT OUTER JOIN party_webinfo B ON A.PartyCode = B.PartyCode 
	where a.partycode=@partycode 
	and isnull(a.xmltestmode,0)=case when @xmlmode=1 then isnull(A.xmltestmode,0) else 1 end

	--Hotel Reference Point, Media, Contact information
	select * from #partymaindet

	declare @recordstoshow int=0
	if exists(select top 1 't' from #partymaindet)
	begin
		set @recordstoshow = 1
	end

	--Room Info
	select rm.rmtypcode, rm.rmtypname, 
		case when isnull(@baseurl,'')='' then '' else @baseurl + 
			'/PriceListModule/RoomImages/Uploded/' + rm.partycode + '_' + rm.rmtypcode + '_main.jpg' end roomimageurl,
		rm.rmtypname RoomDescription, d.maxadults, d.maxchilds, 0 maxinfants, d.maxoccpancy maxoccupancy, 
		d.maxeb, d.noofextraperson, d.pricepax
	from partyrmtyp rm (nolock), partymaxaccomodation d (nolock) 
	where rm.partycode=@partycode and @recordstoshow=1 and isnull(rm.inactive,0)=0
		and d.partycode=rm.partycode and d.rmtypcode=rm.rmtypcode
	order by rm.rankord

	--Room -Allowed Adult, Child Combination
	select rm.rmtypcode, d.rmcatcode, rc.rmcatname, d.maxadults adult, d.maxchilds child
	from partyrmtyp rm (nolock), maxaccom_details d (nolock), rmcatmast rc (nolock)
	where rm.partycode=@partycode and @recordstoshow=1 and isnull(rm.inactive,0)=0
		and d.partycode=rm.partycode and d.rmtypcode=rm.rmtypcode and rc.rmcatcode=d.rmcatcode
	order by rm.rankord, rm.rmtypcode, d.maxadults, d.maxchilds
	
	--Amenities
	select a.AmenityName, t.AmenityTypeCode 
	from TB_PartyAmenities p (nolock), TB_AmenityTypeMaster t (nolock), TB_HotelAmenitiesMaster a (nolock)
	where p.AmenityCode=a.AmenityCode and p.AmenityTypecode=t.AmenityTypeCode and
		p.PartyCode=@partycode and @recordstoshow=1
	group by a.AmenityName, t.AmenityTypeCode, t.RankOrder, a.RankOrder
	order by t.RankOrder, a.RankOrder

	--General Text
	select isnull(general,'') generalpolicy from partymast p (nolock) where p.PartyCode=@partycode and @recordstoshow=1
end
