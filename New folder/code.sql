create database QLSinhVien_OT
use QLSinhVien_OT

create table khoa(
makhoa nvarchar(10) primary key,
tenkhoa char(30),
)

create table lop(
malop nvarchar(10) PRIMARY KEY,
tenlop char(30),
siso int,
makhoa nvarchar(10),
constraint fk_lop foreign key(makhoa) references khoa(makhoa) on update cascade on delete cascade
)

create table sinhvien(
masv nvarchar(10) primary key,
hoten char(30),
ngaysinh datetime,
gioitinh bit,
malop nvarchar(10),
constraint fk_sinhvien foreign key(malop) references lop(malop) on update cascade on delete cascade
)

--insert data
insert into khoa values('makhoa 1','tenkhoa 1'),('makhoa 2','tenkhoa 2')

insert into lop values('malop 1','tenlop 1',15,'makhoa 1'),('malop 2','tenlop 2',30,'makhoa 2')

insert into sinhvien values('masv 1','hoten 1','1/1/1989',1,'malop 1'),
							('masv 2','hoten 2','1/2/1989',0,'malop 1'),
							('masv 3','hoten 3','2/3/1990',1,'malop 2'),
							('masv 4','hoten 4','4/5/1989',0,'malop 2'),
							('masv 5','hoten 5','7/6/1989',1,'malop 1'),
							('masv 6','hoten 6','8/9/1990',0,'malop 1'),
							('masv 7','hoten 7','1/23/1989',1,'malop 2')

select * from khoa
select * from lop
select * from sinhvien

--cau2
create view cau2
as
select masv,hoten,(year(getdate()) - year(ngaysinh)) as tuoi
from sinhvien
where year(ngaysinh) = (select max(year(ngaysinh)) from sinhvien)

select * from cau2

--cau3
alter proc cau3(@tutuoi int, @dentuoi int)
as
begin
	if(not exists (select * from sinhvien inner join lop on sinhvien.malop = lop.malop 
		inner join khoa on lop.makhoa = khoa.makhoa
	where (year(getdate()) - year(ngaysinh)) between @tutuoi and @dentuoi))
			print ('khong co sinh vien nao trong khoang tuoi do')
	else
	select masv,hoten,ngaysinh,tenlop,tenkhoa,(year(getdate()) - year(ngaysinh)) as tuoi
	from sinhvien inner join lop on sinhvien.malop = lop.malop 
		inner join khoa on lop.makhoa = khoa.makhoa
	where (year(getdate()) - year(ngaysinh)) between @tutuoi and @dentuoi
end

exec cau3 33,34

--cau 4:
create trigger cau4
on sinhvien
for insert
as
begin
	declare @siso int
	select @siso = siso from lop inner join inserted on lop.malop = inserted.malop
	
	if(@siso >80)
		begin
			raiserror(N'warnning quá số lượng sinh viên',16,1)
			rollback transaction
		end
	else
		begin
			update lop set siso = siso + 1 from lop inner join inserted on lop.malop = inserted.malop
		end
end

select * from lop
select * from sinhvien
insert into sinhvien values('masv 8','ten 8','12/12/1980',1,'malop 1')
select * from lop
select * from sinhvien