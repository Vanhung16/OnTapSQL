create database QLHang_OT
use QLHang_OT

create table vattu(
mavt nvarchar(10) primary key,
tenvt char(30),
dvtinh char(10),
slcon int
)

create table hdban1(
mahd nvarchar(10) primary key,
ngayxuat datetime,
hotenkhach char(30),
)

create table hangxuat(
mahd nvarchar(10) ,
mavt nvarchar(10),
dongia money,
slban int,
constraint pk_hangxuat primary key(mahd,mavt),
constraint fk_hangxuat_mahd foreign key(mahd) references hdban1(mahd) on update cascade on delete cascade,
constraint fk_hangxuat_mavt foreign key(mavt) references vattu(mavt) on update cascade on delete cascade
)

--insert data
insert into vattu values('mavt 1','tenvt 1','dvt 1',10),('mavt 2','tenvt 2','dvt 2',15)

insert into hdban1 values('mahd 1','1/1/2019','tenkhach 1'),('mahd 2','1/1/2012','tenkhach 2')

insert into hangxuat values('mahd 1','mavt 1',1000,2),
('mahd 2','mavt 2',2000,3),
('mahd 1','mavt 2',2000,3),
('mahd 2','mavt 1',4000,5)

select * from vattu
select * from hdban1
select * from hangxuat

--cau2
create view cau2
as
select hangxuat.mahd,hdban1.ngayxuat,hangxuat.mavt,tenvt,(sum(slban * dongia)) as 'thanh tien'
from hangxuat inner join vattu on hangxuat.mavt = vattu.mavt inner join hdban1 on hdban1.mahd = hangxuat.mahd
group by  hangxuat.mahd,hdban1.ngayxuat,hangxuat.mavt,tenvt

select * from cau2

--cau3
create function cau3(@mahd nvarchar(30))
returns @danhsach table(
mahd nvarchar(10),
ngayxuat datetime,
mavt nvarchar(10),
dongia money,
slban int,
ngaythu char(10)
)
as
begin
	insert into @danhsach
	select hdban1.mahd,ngayxuat,vattu.mavt,dongia,slban,datepart(weekday,ngayxuat)
	from
	hdban1 inner join hangxuat on hdban1.mahd = hangxuat.mahd
	inner join vattu on vattu.mavt = hangxuat.mavt
	where hdban1.mahd = @mahd
	return
end

select * from cau3('mahd 1')

--cau4
create trigger cau4
on hangxuat
for insert
as
begin
	declare @slcon int
	declare @slban int
	select @slcon = slcon from vattu inner join inserted on vattu.mavt = inserted.mavt
	select @slban = hangxuat.slban from hangxuat inner join inserted on hangxuat.mavt = inserted.mavt

	if(@slban > @slcon)
		begin
			raiserror('warning',16,1)
			rollback transaction
		end
	else
		update vattu set slcon = slcon - @slban from vattu inner join inserted 
		on vattu.mavt = inserted.mavt 
end

insert into hdban1 values('mahd 3','1/1/2021','tenkhach 3')

select * from vattu
select * from hangxuat
insert into hangxuat values('mahd 3','mavt 1',3000,1)
select * from vattu
select * from hangxuat