create database quanlybanhang;
use quanlybanhang;

create table CUSTOMERS(
customer_id varchar(4) primary key not null,
name varchar(100) not null,
email varchar(100) not null,
phone varchar(25) not null,
address varchar (255));

create table ORDERS(
order_id varchar(4) primary key not null,
customer_id varchar(4) not null,
foreign key (customer_id) references CUSTOMERS (customer_id),
order_date date not null,
total_amount double not null);

create table PRODUCTS(
product_id varchar(4) primary key not null,
name varchar(255) not null,
description text,
price double not null,
status bit(1) default 1 not null);

create table ORDERS_DETAILS(
order_id varchar(4) not null,
foreign key (order_id) references ORDERS (order_id),
product_id varchar(4) not null,
foreign key (product_id) references PRODUCTS (product_id),
primary key (order_id, product_id),
price double not null,
quantity int(11) not null
);

insert into CUSTOMERS() values("C001","Nguyễn Trung Mạnh","manhnt@gmail.com","984756322","Cầu Giấy, Hà Nội");
insert into CUSTOMERS() values("C002","Hồ Hải Nam","namhh@gmail.com","984875926","Ba Vì, Hà Nội");
insert into CUSTOMERS() values("C003","Tô Ngọc Vũ","vutn@gmail.com","904725784","Mộc Châu, Sơn La");
insert into CUSTOMERS() values("C004","Phạm Ngọc Anh","anhpn@gmail.com","984635365","Vinh, Nghệ An");
insert into CUSTOMERS() values("C005","Trương Minh Cường","cuongtm@gmail.com","989735624","Hai Bà Trưng, Hà Nội");

insert into PRODUCTS() values("P001","Iphone 13 ProMax","Bản 512 GB, xanh lá",22999999,1);
insert into PRODUCTS() values("P002","Dell Vostro V3510","Core i5, RAM 8 GB",14999999,1);
insert into PRODUCTS() values("P003","Macbook Pro M2","8CPU 10CPU 8GB 256GB",28999999,1);
insert into PRODUCTS() values("P004","Apple Watch Ultra","TItanium Alpine Lôp Small",18999999,1);
insert into PRODUCTS() values("P005","Iphone 13 ProMax","Bản 512 GB, xanh lá",4090000,1);

insert into ORDERS(order_id,customer_id,total_amount,order_date) values
('H001','C001',52999997,'2023-02-22'),
('H002','C001',80999997,'2023-03-11'),
('H003','C002',54359998,'2023-01-22'),
('H004','C003',102999995,'2023-03-14'),
('H005','C003',80999997,'2023-03-12'),
('H006','C004',110449994,'2023-02-01'),
('H007','C004',79999996,'2023-03-29'),
('H008','C005',29999998,'2023-02-14'),
('H009','C005',28999999,'2023-01-10'),
('H010','C005',149999994,'2023-04-01');
update ORDERS set order_date = "2022-03-12" where order_id="H005";

insert into ORDERS_DETAILS() values
('H001', 'P002', 14999999, 1),
('H001', 'P004', 18999999, 2),
('H002', 'P001', 22999999, 1),
('H002', 'P003', 28999999, 2),
('H003', 'P004', 18999999, 2),
('H003', 'P005', 4090000, 4),
('H004', 'P002', 14999999, 3),
('H004', 'P003', 28999999, 2),
('H005', 'P001', 22999999, 1),
('H005', 'P003', 28999999, 2),
('H006', 'P005', 4090000, 5),
('H006', 'P002', 14999999, 6),
('H007', 'P004', 18999999, 3),
('H007', 'P001', 22999999, 1),
('H008', 'P002', 14999999, 2),
('H009', 'P003', 28999999, 1),
('H010', 'P003', 28999999, 2),
('H010', 'P001', 22999999, 4);

-- Bài 3: Truy vấn dữ liệu [30 điểm]:
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .[4 điểm]
select c.name as "Tên khách hàng" , c.email as "Email", c.phone as "Số điện thoại" , c.address as "Địa chỉ" from CUSTOMERS c;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng). [4 điểm]
select c.name as "Tên khách hàng" , c.phone as "Số điện thoại" , c.address as "Địa chỉ", o.order_date as "Ngày đặt" 
from CUSTOMERS c
join ORDERS o on c.customer_id = o.customer_id
where month(order_date) = 3;

-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ). [4 điểm]
select sum(o.total_amount) as "Tổng doanh thu", month(o.order_date) as "Tháng" 
from ORDERS o 
group by month(o.order_date)
order by month(o.order_date);

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
-- hàng, địa chỉ , email và số điên thoại). [4 điểm]
select c.name as "Tên khách hàng" , c.address as "Địa chỉ", c.email as "Email", c.phone as "Số điện thoại" 
from customers c
left join orders ord 
on ord.customer_id = c.customer_id 
and year(ord.order_date) = 2023 
and month(ord.order_date) = 2
where ord.order_id is null;
    
-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
-- sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]
select p.product_id as "Mã sản phẩm", p.name as "Tên sản phẩm", sum(od.quantity) as "Số lượng bán ra"
from PRODUCTS p
join ORDERS_DETAILS od
on p.product_id = od.product_id
join ORDERS o
on o.order_id = od.order_id
where month(o.order_date) = 3 and year(o.order_date) = 2023
group by p.product_id;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]
select c.customer_id as "Mã khách hàng", c.name as "Tên khách hàng", sum(o.total_amount) as "Tổng chi tiêu"
from CUSTOMERS c 
join ORDERS o
on c.customer_id = o.customer_id
where year(o.order_date)=2023
group by c.customer_id
order by sum(o.total_amount) desc;

-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]
select c.name as "Tên người mua", sum(o.total_amount) as "Tổng tiền", o.order_date as "Ngày tạo hóa đơn", sum(od.quantity) as "Tổng số lượng sản phẩm"
from CUSTOMERS c
join ORDERS o
on c.customer_id = o.customer_id
join ORDERS_DETAILS od
on o.order_id = od.order_id
group by o.order_id
having sum(od.quantity) > 5 ;

-- Bài 4: Tạo View, Procedure [30 điểm]:
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn . [3 điểm]
create view view_orders_info as
select c.name as "Tên khách hàng", c.phone as "Số điện thoại", c.address as "Địa chỉ", sum(o.total_amount) as "Tổng tiền", any_value(o.order_date) as "Ngày tạo hóa đơn"
from CUSTOMERS c
join ORDERS o
on c.customer_id = o.customer_id
group by c.customer_id;

select * from view_orders_info;

-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
-- số đơn đã đặt. [3 điểm]
create view view_customers_info as
select c.name as "Tên khách hàng",c.address as "Địa chỉ", c.phone as "Số điện thoại", count(*) as "Tổng số đơn đã đặt"
from CUSTOMERS c
join ORDERS o
on c.customer_id = o.customer_id
group by c.customer_id;

select * from view_customers_info;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm.[3 điểm]
create view view_products_info as
select p.name as "Tên sản phẩm", p.description as "Mô tả", p.price as "Giá", count(*) as "Tổng số lượng đã bán ra"
from PRODUCTS p
join ORDERS_DETAILS od
on p.product_id = od.product_id
group by p.product_id;

select * from view_products_info;

-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]
create index index_phone on CUSTOMERS (phone);
create index index_email on CUSTOMERS (email);

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
delimiter //
create procedure get_all_info_of_customer (in customerId varchar(4))
begin
select c.name as "Tên khách hàng", c.email as "Email", c.phone as "Số điện thoại", c.address as "Địa chỉ"
from CUSTOMERS c
where c.customer_id = customerId;
end;
//
call get_all_info_of_customer("C001");

-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
delimiter //
create procedure get_all_info_of_product ()
begin
select * from PRODUCTS;
end;
//
call get_all_info_of_product();

-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]
delimiter //
create procedure show_all_info_of_order_list (in customerId varchar(4))
begin
select o.order_id as "Mã đơn", o.total_amount as "Tổng tiền", o.order_date as "Ngày mua" from ORDERS o
where o.customer_id = customerId;
end;
//
call show_all_info_of_order_list("C001");

-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
-- tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]
delimiter //
create procedure add_new_a_order(in 
orderId varchar(4),
customerId varchar(4),
total_amount double, 
order_date date)
begin
insert into ORDERS(order_id, customer_id, total_amount, order_date) values (orderId, customerId, total_amount, order_date);
select order_id from ORDERS
where order_id=orderId;
end;
//
call add_new_a_order("H012","C004",3599999,"2023-11-23");

-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]
delimiter //
create procedure sales_statistics (in start_date date , end_date date )
begin
select p.product_id as "Mã sản phẩm" , p.name as "Tên sản phẩm" , count(*) as "Số lượng bán ra"
from PRODUCTS p
join ORDERS_DETAILS od
on p.product_id = od.product_id
join ORDERS o
on od.order_id = o.order_id
where order_date between start_date and end_date
group by p.product_id, p.name;
end;
//

call sales_statistics ("2022-12-31","2023-5-31");

-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]
delimiter //
create procedure sales_statistics_by_year_and_month (in input_month int , input_year int )
begin
select p.product_id as "Mã sản phẩm" , p.name as "Tên sản phẩm" , count(*) as "Số lượng bán ra"
from PRODUCTS p
join ORDERS_DETAILS od
on p.product_id = od.product_id
join ORDERS o
on od.order_id = o.order_id
where month(o.order_date) = input_month
and year(o.order_date) = input_year
group by p.product_id, p.name
order by count(*) desc;
end;
//
call sales_statistics_by_year_and_month(3,2023);