
---------------------------------------------------------------BAZA DANYCH: NORTHWIND----------------------------------------------------------------------------------

--2a
--Ile zamówień złożono w 1997 roku?---

select count(*) as order_count
from orders o
where extract(year from o.order_date) = 1997 

--2b
-- Jakie są unikatowe nazwy kategorii produktów (CategoryProduct)?

select distinct category_name 
from categories c 

--2c
--Czy ID zamówień (OrderID) jest unikalne?

select count(distinct order_id) as unique_order_count, count(*) as total_order_count
from orders o 

--2d
--Ile klientow złożyło więcej niż 5 zamówień?

select count(*) as num_customer_5
from  
(select count(*) 
from orders o 
group by customer_id
having count(*) > 5) foo

--2e
-- Ile zamówień (OrderID) zawierają produkty (ProductName) o nazwie "Chai"

select count(*) as num_order_Chai 
from order_details od
join products p on od.product_id = p.product_id
where product_name = 'Chai'

--2f
--Jaki kraj (Country) ma najmniejszą średnią wartość zamówienia (Qantity X UnitPrice), a jaki największą?


with c as (select foo.ship_country, avg(od.quantity*od.unit_price) avg_order
from order_details od
join
(select o.order_id , o.ship_country 
from orders o ) foo
on foo.order_id = od.order_id
group by foo.ship_country)
select *
from c
where avg_order in ((select max(avg_order) from c), (select min(avg_order) from c))

--2g
--Jakie produkty należą do kategorii "Napoje" (Beverages) i kosztują (UnitPrice) więcej niż 10$?

select p.product_name , p.unit_price 
from categories c 
left join products p on c.category_id = p.category_id 
where c.category_name ='Beverages' and unit_price > 10

--2h
--Jakie są miasta, w których mieszka więcej niż 3 pracowników
select city, count(*) as num_employee 
from employees e
group by city
having count(*) > 3 

--2i
-- Jakie produkty(Products) zostały zamówione mniej niż 10 razy?
select p.product_id, p.product_name, count(*) as num_product
from products p
join order_details od on p.product_id = od.product_id
group by p.product_id
having  count(*) < 10
order by num_product desc 

select*
from categories c 

select*
from order_details od

select*
from order_details od 

--2j
--Zakładając, że produkty, które kosztują(UnitPrice) mniej niż 10$ możemy uznać za tanie,
--te między 10$ a 50$ za średnie, a te powyżej 50$ za drogie, ile produktów należy do poszczególnych predziałów?

select 
	case
		WHEN unit_price > 50 THEN 'Drogo'
		WHEN unit_price >=10 and unit_price <=50 THEN 'Średnio drogo'
		ELSE 'Tanio'
		end as zakres_cen,
		count(*) as ilosc
from order_details od
group by zakres_cen


--2k
-- czy najdroższy produkt z kategorii z największą średnią ceną to najdroższy produkt ogólnie?


select p.category_id, p.product_name, c.category_name, p.unit_price, (select max(p.unit_price) from products p) as general_max_price_product_from_all
from products p 
left join categories c on c.category_id = p.category_id
where c.category_name in
(select foo.category_name
from 
(select c.category_name, avg(p.unit_price) avg_price
from products p
join categories c on p.category_id = c.category_id
group by c.category_name
order by avg_price desc
limit 1) foo)
order by p.unit_price desc
limit 1


--2l
--Ile kosztuje najtańszy, najdroższy i ile średnio kosztuje produkt od każdego z dostawców?
-- UWAGA - te dane powinny być przedstawione z nawami dostawców, nie ich identyfikatorami.

select s.company_name, min(p.unit_price) as cheapest_prod , max(p.unit_price) as most_expensive_prod , avg(p.unit_price) as avg_price_prod
from products p 
left join suppliers s  on p.supplier_id = s.supplier_id  
group by s.company_name
order by company_name asc

--2m
--Jak się nazywają i jakie mają numery kontaktowe wszystcy dostawcy i klienci (ContactName)z Londynu? Jeśli nie ma numeru telefonu, wyświetl fax.

select c.contact_name, c.phone
from customers c 
where city = 'London'
union
select s.contact_name  , s.phone
from suppliers s
where city = 'London'

--2n
--Jakie produkty były na najdroższym zamówieniu (OrderID)? Uwzględnij zniżki (Discount).


select*
from products p 
join order_details od on od.product_id = p.product_id
join
(select foo.order_id, sum(foo.price_after_discount) as the_most_expensive_order
from
(select od.order_id, od.unit_price*od.quantity*(1 - od.discount) as price_after_discount
from order_details od) foo
group by foo.order_id
order by the_most_expensive_order desc
limit 1) foo2
on od.order_id = foo2.order_id

--2o
--Które miejsce cenowo (od najtańszego) zajmują w swojej kategorii (CategoryID) wszystkie produkty?

select c.*,p.product_name, p.unit_price, 
rank()over(partition by c.category_id order by p.unit_price) rk 
from categories c
left join products p on p.category_id = c.category_id



--------------------------------------BAZA DANYCH: SUMMARY OF WEATHER, WEATHER STATION LOCATION------------------------------------------------------------

--3a
--Dla jakiej stacji pogodowej średnia roczna temperatura była mniejsza niż 0°?
select*
from weather_station_locations wsl 
join
(select sta, sow.yr, avg(sow.meantemp) as mean_year_temp 
from weather_station_locations wsl 
left join summary_of_weather sow on wsl.wban = sow.sta
group by sta, sow.yr
having avg(sow.meantemp) < 0
order by sta asc) foo
on wsl.wban = foo.sta

--3b
--Jaka była i w jakim kraju miała miejsce najwyższa dzienna amplituda temperatury?
 
select wsl."NAME", wsl."STATE/COUNTRY ID", foo.maxtemp
from weather_station_locations wsl
join
(select distinct sta, maxtemp 
from summary_of_weather sow
where maxtemp in 
(select max(maxtemp)
from summary_of_weather sow)) foo
on wsl.wban = foo.sta

--3c
--Które stacje pogodowe zarejestrowały nawiększą liczbę dni z opadami śniegu w danym roku?

select wsl.wban, wsl."NAME", wsl."STATE/COUNTRY ID", foo.year, foo.num_days
from weather_station_locations wsl 
left join 
(select date_trunc('year', "Date"::date) as year, sta, count(distinct(date_trunc('day', "Date"::date))) as num_days
from summary_of_weather sow
where  snowfall > 0 
group by date_trunc('year', "Date"::date), sta 
order by num_days desc) foo
on wsl.wban = foo.sta

--3d
--Ile stacji pogodowych znajduje się na półkuli północnej, a ile na południowej?

select 
case
	when latitude between 0 and 90 then 'półkula północna'
	else 'półkula południowa'
end polkola,
count(*) as ilość_stacji_pogodowych
from weather_station_locations wsl
group by polkola

--3e
--Na której stacji opady atmosferyczne były najwyższe, przy czym nie uwzględniaj dni, w których wystąpiły opady śniegu.
--Wyświetl wynik wraz z nawą stacji i datą. 


select wsl."NAME", wsl."STATE/COUNTRY ID", foo."Date" , foo.precip_1 
from weather_station_locations wsl
join
(select coalesce(nullif(precip, 'T')::numeric, 0) as precip_1 , sta, "Date" 
from summary_of_weather sow
where snowfall = 0
order by precip_1 desc
limit 1) foo
on wsl.wban = foo.sta

--3f
--Z czym silniej skorelowana jest średnia dzienna temperatura dla stacji – szerokością (latitude) czy długością (longitude) geograficzną?

select corr(sow.meantemp, wsl.latitude) as mean_temp_lat, corr(sow.meantemp, wsl.longitude) as  mean_temp_lon
from weather_station_locations wsl 
join summary_of_weather sow 
on wsl.wban = sow.sta


--3g
--Pokaż obserwacje, w których suma opadów atmosferycznych(precipitation) przekroczyła sumę opadów z ostatnich 5 obserwacji na danej stacji.

select*
from
summary_of_weather sow2
join 
(select*
from
(select sta, "Date"::date, coalesce(nullif(precip, 'T')::numeric, 0) as precipitation,
sum(coalesce(nullif(precip, 'T')::numeric, 0)) over(partition by sta order by "Date"::date desc ) last_5_measures,
row_number()over(partition by sta order by "Date"::date desc ) rn
from summary_of_weather sow
order by sta, "Date"::date desc) foo
where rn = 5) a
on sow2.sta = a.sta
where coalesce(nullif(precip, 'T')::numeric, 0) > last_5_measures
order by sow2.sta


--3h
--Znajdź wszystkie stacje pogodowe, które zarejestrowały opady w dniach, 
--gdy temperatura była wyższa niż 30 stopni Celsjusza używając do tego operacji EXIST.

select* 
from weather_station_locations wsl
where exists
(select*
from summary_of_weather sow 
where sow.sta = wsl.wban and maxtemp > 30 and coalesce(nullif(precip, 'T')::numeric, 0) > 0)

--3i
--Uszereguj stany/państwa według od najniższej temperatury zanotowanej tam w okresie obserwacji używając do tego funkcji okna.

select wsl."STATE/COUNTRY ID", min(c.mintemp) as low_temp
from weather_station_locations wsl
join
(select sta, mintemp, rk
from
(select *,
row_number()over(partition by sta order by mintemp asc) rk
from summary_of_weather sow) t
where rk = 1) c
on wsl.wban = c.sta
group by  wsl."STATE/COUNTRY ID"
order by low_temp asc

select 
from weather_station_locations wsl 
where "STATE/COUNTRY ID" = 'UK'

--3j
--Jakie są średnie temperatury dla każdego miesiąca w UK? (BONUS)


select distinct date_trunc('month', "Date"::date), a.avg_mean_temp_month, "STATE/COUNTRY ID"
from weather_station_locations wsl 
left join
(select*,
avg(meantemp) over(partition by mo)avg_mean_temp_month
from summary_of_weather sow) a
on wsl.wban = a.sta
where "STATE/COUNTRY ID" = 'UK'









































 