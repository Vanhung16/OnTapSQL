select * from khoa
select * from lop
select * from sinhvien

--cau 2:
alter function cau2(@tenkhoa char(30), @tenlop char(30))
returns @danhsach table (
masv nvarchar(10),
hoten char(30),
tuoi int
)
as
begin
	insert into @danhsach
	select masv,hoten,(year(getdate())-year(ngaysinh)) as tuoi 
	from sinhvien inner join lop on sinhvien.malop = lop.malop inner join khoa on lop.makhoa = khoa.makhoa
	where tenkhoa = @tenkhoa and tenlop = @tenlop
	return
end
select * from cau2('CNTT','tenlop 1')
select * from khoa
select * from lop
select * from sinhvien

--cau 3
create proc cau3(@tenkhoa char(30), @x int)
as
begin
	if(not exists (select * from khoa where tenkhoa = @tenkhoa))
		print 'khong ton tai ten khoa '+@tenkhoa+' trong CSDL'
	else
		if()
end