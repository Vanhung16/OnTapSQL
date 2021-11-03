create database QLBanHang_OT
go 
use QLBanHang_OT

create table congty(
mact nvarchar(10) primary key,
tenct nvarchar(30),
diachi nvarchar(30)
)

create table sanpham (
masp nvarchar(10) primary key,
tensp nvarchar(30),
soluongco int,
giaban money
)

create table cungung(
mact nvarchar(10),
masp nvarchar(10),
soluongcungung int,
primary key(mact,masp),
constraint fk_cungung_mact foreign key (mact) references congty(mact) on update cascade on delete cascade,
constraint fk_cungung_masp foreign key (masp) references sanpham(masp) on update cascade on delete cascade
)

--insert data
insert into congty values('mact 1','tenct 1','diachi 1'),('mact 2','tenct 2','diachi 2'),('mact 3','tenct 3','diachi 3')

insert into sanpham values ('masp 1','tensp 1',10,1000),('masp 3','tensp 3',30,3000),('masp 2','tensp 2',20,2000)

insert into cungung values ('mact 1','masp 1',50),('mact 2','masp 2',30),
							('mact 3','masp 3',40),
							('mact 1','masp 2',60),('mact 2','masp 1',70)

select * from congty
select * from sanpham
select * from cungung

--cau 2:
create view cau2
as
select sanpham.masp,tensp,soluongco,soluongcungung 
from sanpham inner join cungung on sanpham.masp = cungung.masp


select * from cau2
--cau3:Viết thủ tục thêm mới 1 công ty với mã công ty, tên công ty,
--địa chỉ nhập từ bàn phím, nếu tên công ty đó tồn tại trước đó hãy 
--hiển thị thông báo và trả về 1,ngược lại cho phép thêm mới và
--trả về 0.

alter proc cau3(@mact nvarchar(10),@tenct nvarchar(30),@diachi nvarchar(30) , @KQ int output) 
as
begin
	if(exists (select * from congty where tenct = @tenct))
		begin
			set @KQ = 1
		end
	else
		begin
			insert into congty values(@mact,@tenct,@diachi)
			set @KQ = 0
		end
	return @KQ
end

select * from congty
declare @check int
exec cau3 'mact 6','tenct 6','diachi 1',@check output
select @check as 'ket qua'
select * from congty
--Câu 4: (2.5. điểm)
--Tạo Trigger Update trên bảng CUNGUNG cập nhật lại số lượng cung ứng, kiểm tra xem nếu số lượng cung ứng mới – số lượng cung ứng cũ <= số lượng có
-- hay không? nếu thỏa mãn hãy cập nhật lại số lượng có trên bảng SANPHAM, ngược lại đưa ra thông báo.

alter trigger cau4
on cungung
for update
as
begin
	declare @soluongcungungmoi int
	declare @soluongcungungcu int
	declare @soluongco int
	select @soluongcungungmoi = soluongcungung from inserted 
	select @soluongcungungcu = soluongcungung from deleted
	select @soluongco = soluongco from sanpham
	if(@soluongcungungmoi - @soluongcungungcu > @soluongco)
		begin
			raiserror ('warnning',16,1)
			rollback transaction
		end
	else
		begin
			update sanpham set soluongco = soluongco -(@soluongcungungmoi - @soluongcungungcu)
			--from sanpham inner join inserted on sanpham.masp = inserted.masp inner join deleted on sanpham.masp = deleted.masp
		end
end

select * from sanpham
select * from cungung
update cungung set soluongcungung = 10 where mact = 'mact 2'and  masp = 'masp 2'
select * from sanpham
select * from cungung
