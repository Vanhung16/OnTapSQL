create database QLBenhVien_OT
use QLBenhVien_OT

create table benhvien(
mabv nvarchar(10) , 
tenbv char(30),
diachi char(30),
dienthoai int,
primary key(mabv)
)

create table khoakham(
makhoa nvarchar(10),
tenkhoa char(30),
sobenhnhan int,
mabv nvarchar(10),
primary key(makhoa),
constraint fk_khoakham_mabv foreign key (mabv) references benhvien(mabv) on update cascade on delete cascade
)

create table benhnhan(
mabn nvarchar(10),
hoten char(30),
ngaysinh datetime,
gioitinh char(10),
songaynv int,
makhoa nvarchar(10)
primary key(mabn),
constraint fk_benhnhan_makhoa foreign key(makhoa) references khoakham(makhoa) on update cascade on delete cascade
)

--insert data
insert into benhvien values('mabv 1','tenbv 1','diachi 1',0123),
							('mabv 2','tenbv 2','diachi 2',0987)

insert into khoakham values('makhoa 1','tenkhoa 1',10,'mabv 1'),
							('makhoa 2','tenkhoa 2',15,'mabv 2')

insert into benhnhan values('mabn 1','ten1','12/12/1999','Nam',4,'makhoa 1'),
							('mabn 2','ten2','11/11/1991','Nu',1,'makhoa 2'),
							('mabn 3','ten3','10/10/1992','Nam',2,'makhoa 1'),
							('mabn 4','ten4','9/8/1992','Nu',3,'makhoa 2'),
							('mabn 5','ten5','8/9/1993','Nam',4,'makhoa 1')

select * from benhvien
select * from khoakham
select * from benhnhan

--cau2:
alter view cau2
as
select benhnhan.makhoa,tenkhoa,count(mabn) as 'so nguoi'
from benhnhan inner join khoakham on benhnhan.makhoa = khoakham.makhoa
where gioitinh = 'Nam'
group by benhnhan.makhoa,tenkhoa

select * from cau2

--cau 3:
create function tongtien(@tenkhoa char(30))
returns money
as
begin	
	declare @tong money
	select @tong = sum(songaynv*60000)
	from benhnhan inner join khoakham on benhnhan.makhoa = khoakham.makhoa
	where tenkhoa = @tenkhoa
	return @tong
end

select dbo.tongtien('tenkhoa 1') as 'tong tien thu'

--cau3:
create trigger cau4
on benhnhan
for insert
as
begin 
if(not exists(select * from khoakham inner join inserted on khoakham.makhoa = inserted.makhoa))
	begin 
		raiserror ('loi khong co khoa',16,1)
		rollback transaction
	end
else
	begin
		declare @sobenhnhan int
		select @sobenhnhan = khoakham.sobenhnhan from khoakham inner join inserted
		on khoakham.makhoa = inserted.makhoa
		if(@sobenhnhan > 50)
			begin 
				raiserror('warning',16,1)
				rollback transaction
			end
		else
			update khoakham set khoakham.sobenhnhan = khoakham.sobenhnhan + 1
			from khoakham inner join inserted on khoakham.makhoa = inserted.makhoa
	end
end

select * from benhnhan
select * from khoakham
insert 	into benhnhan values('mabn 6','ten 6','12/12/2012',1,5,'makhoa 1')
select * from benhnhan
select * from khoakham



