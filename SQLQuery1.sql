create database QLSach

use QLSach

create table sach (
masach nvarchar(10) primary key,
tensach nvarchar(30),
slco int,
matg nvarchar(10),
ngayxb datetime
)

create table nxb(
manxb nvarchar(10) primary key,
tennxb nvarchar(30),
)

create table xuatsach (
manxb nvarchar(10),
masach nvarchar(10),
soluong int,
gia money
constraint pk_xuatsach primary key(manxb,masach),
constraint fk_xuatsach_manxb foreign key(manxb) references nxb(manxb) on update cascade on delete cascade,
constraint fk_xuatsach_mansach foreign key(masach) references sach(masach) on update cascade on delete cascade,
)

--insert data
insert into sach values ('masach 1','tensach 1',12,'matg 1','12/12/2020'),('masach 2','tensach 2',15,'matg 2','11/11/2020'),('masach 3','tensach 3',30,'matg 3','11/15/2020')

insert into nxb values ('manxb 1','tennxb 1'),('manxb 2','tennxb 2')

insert into xuatsach values ('manxb 1','masach 1',5,10000),('manxb 2','masach 2',2,12000),('manxb 1','masach 3',3,1000),
('manxb 2','masach 1',4,4000),('manxb 1','masach 2',5,5000)

select * from sach
select * from nxb
select * from xuatsach

--cau 2: tạo một thủ tục sửa ngày xuất bản theo mọt quyển sách với mã sach được nhập từ bàn phím .
--kiểm tra ko có mã sách trong bảng thì đưa ra thông báo, nếu mã sách tồn tại thì kiểm tra ngày xuất bản,
--nếu ngày xuất bản trùng hoặc sau ngày hiện tại thì đưa ra thông báo: không thể sửa , ngược lại cho phép sửa

alter proc cau2(@masach nvarchar(10), @ngaysua datetime)
as
begin
	if(not exists (select * from sach where masach = @masach))
		print 'khong ton tai ma sach la : ' + @masach + ' trong bang '
	else
		declare @ngayxb datetime
		select @ngayxb =  ngayxb from sach where masach = @masach
		if(@ngayxb >= getdate())
			print 'khong the sua'
		else
			update sach
			set ngayxb = @ngaysua
			where masach = @masach
end

select * from sach
exec cau2 'masach 2','01/02/2001'
select * from sach

--cau 3 tạo trigger nhập mới 1 quyển sách kiểm tra năm xuất bản <= năm hiện tại thì thêm vào bảng sách ngược lại thì đưa ra thông báo 
alter trigger cau3
on sach
for insert
as
	begin	
		declare @namxb datetime
		select @namxb = year(sach.ngayxb) from sach inner join inserted on sach.masach = inserted.masach
		if(@namxb >= year(getdate()))
			raiserror ('warnning' ,16,1)
			--rollback transaction
	end

insert into sach values('masach 5','tensach 5', 10,'matg1','01/01/2023')
select * from sach