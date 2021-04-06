create database QLHang_OT
use QLHang_OT
create table hang(
mahang nvarchar(10) primary key,
tenhang char(30),
dvtinh char(10),
slton int,
) 

create table hdban(
mahd nvarchar(10) primary key,
ngayban datetime,
hotenkhach char(30),
)

create table hangban(
mahd nvarchar(10),
mahang nvarchar(10),
dongia money,
soluong int,
constraint pk_hangban primary key(mahd,mahang),
constraint fk_hangban foreign key(mahd) references hdban(mahd) on update cascade on delete cascade,
constraint fk_hangban_2 foreign key(mahang) references hang(mahang) on update cascade on delete cascade
)
--insert data
insert into hang values('mahang 1','tenhang 1','cai',19),
						('mahang 2','tenhang 2','cai',20)

insert into hdban values('mahd 1','1/1/2019','ten 1'),('mahd 2','2/5/2019','ten 2')

insert into hangban values('mahd 1','mahang 1',1000,3),
							('mahd 2','mahang 2',2000,4),
							('mahd 1','mahang 2',3000,5),
							('mahd 2','mahang 1',2000,1)

		select * from hang
		select * from hdban
		select * from hangban

--cau2
create view cau2
as
select hangban.mahd,ngayban,sum(soluong * dongia) as'tongtien'
from hdban inner join hangban on hdban.mahd = hangban.mahd
group by hangban.mahd,ngayban

select * from cau2

--cau3
create proc cau3(@thang int, @nam int)
as
begin
	select hangban.mahang, tenhang,ngayban,soluong,datepart(weekday,ngayban) as 'ngay thu'
	from hang inner join hangban on hang.mahang = hangban.mahang 
	inner join hdban on hangban.mahd = hdban.mahd
	where year(ngayban) = @nam and month(ngayban) = @thang
end

		select * from hang
		select * from hdban
		select * from hangban
exec cau3 1,2019
