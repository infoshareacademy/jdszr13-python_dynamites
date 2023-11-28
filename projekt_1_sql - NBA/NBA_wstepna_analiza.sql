------------ PRZYGOTOWANIE DANYCH ------------------------

--sprawdzenie czy są brakujące dane
select * from all_seasons as2 
where not (as2 is not null);

--zliczenie unikatowych zawodnikow
select 
	count(player_name) as num_of_records, 
	count(distinct player_name) as distinct_num_players,
	count(distinct case when country = 'USA' then player_name end) as usa_players,
	count(distinct case when country != 'USA' then player_name end) as not_usa_players
from all_seasons as2;

--gracze którzy rozegrali tylko jedna gre 
--(w dalszej analizie moża uznać za outliers)
select * from all_seasons as2 
where gp = 1; 

----------- TOP 10 GRACZY NA BAZIE RÓŻNYCH METRYK --------------------

--gracze z najwiekszą liczbą punktów
select player_name, pts from all_seasons as2
order by 2 desc limit 10

--gracze z najwiekszą liczbą asyst
select player_name, ast from all_seasons as2
order by 2 desc limit 10

--gracze z najwiekszą liczbą rebounds (zbiórek)
select player_name, reb from all_seasons as2
order by 2 desc limit 10

--gracze z najwyzszym net_rating
select player_name, net_rating  from all_seasons as2
order by 2 desc limit 10

--gracze ktorzy zagrali w najwiekszej liczbie sezonów
select player_name, count(season) as played_seasons
from all_seasons as2 
group by player_name 
order by 2 desc limit 10;

-------- PRZEGLAD OGOLNY DANYCH -------------------

--wartości min, max, średnia, odchylenie standardowe, kwantyl Q1, Q2, Q3
select 
	column_name, 
	round(min(val)::numeric, 2) min_value, 
	round(max(val)::numeric, 2) max_value, 
	round(stddev(val)::numeric, 2) std_value, 
	round(avg(val)::numeric, 2) avg_value,
	round(percentile_cont(0.25) within group (order by val)::numeric, 2) q1_,
	round(percentile_cont(0.5) within group (order by val)::numeric, 2) q2_,
	round(percentile_cont(0.75) within group (order by val)::numeric, 2) q3_
from all_seasons as2 , lateral
     (values 
     	('age', "age"), 
     	('player_height', player_height),
     	('player_weight', player_weight),
     	('gp', gp),
     	('pts', pts),
     	('reb', reb),
     	('ast', ast),
     	('net_rating', net_rating),
     	('oreb_pct', oreb_pct),
     	('dreb_pct', dreb_pct),
     	('usg_pct', usg_pct),
     	('ts_pct', ts_pct),
     	('ast_pct', ast_pct) ) v (column_name, val)
group by column_name
order by 1;

----------- PRZYKLADY KORELACJI ----------------------

--korelacja miedzy wzrostem a wagą
select corr(player_height, player_weight) as hw_corr
from all_seasons as2;

-- korelacja miedzy wzrostem a wagą dla każdego sezonu
select season, corr(player_height, player_weight)
from all_seasons as2 
group by season
order by 1 asc;

------------ ANALIZA DO WYKRESOW ------------------

--procent zawodnikow z USA, a pozostałe kraje dla pierwszego draftu
select *, 
	round((usa_players/total::float * 100)::numeric, 2) as precentage_usa,
	round((not_usa_players/total::float*100)::numeric, 2) as precetange_other
from (
	select 
		count(distinct player_name) as total,
		count(distinct case when country = 'USA' then player_name end) as usa_players,
		count(distinct case when country != 'USA' then player_name end) as not_usa_players
	from all_seasons as2 
	where draft_round = '1') foo

--wzrost i waga zawodnikow na bazie kraju
--minimum 3 różnych zawodnikow na kraj
select 
	country, 
	count(distinct player_name) as num_players,
	round(avg(player_height)::numeric, 2) as avg_height, 
	round(avg(player_weight)::numeric, 2) as avg_weight 
from all_seasons as2
group by country
having count(player_name) > 3
order by 2 desc;

--średni wzrost, waga i bmi w kazdym sezonie
select 
	season, 
	--count(distinct player_name) as num_players,
	round(avg(player_height)::numeric, 2) as avg_height, 
	round(avg(player_weight)::numeric, 2) as avg_weight,
	round(avg(player_weight / power(player_height/100, 2))::numeric, 2) as avg_bmi,
	round(avg("age")::numeric, 0) as avg_age
from all_seasons as2 
group by season
order by 1 asc;

--średni wzrost i waga zawodnikow z wiekiem
select 
	"age",
	--count(distinct player_name) as num_players,
	round(avg(player_height)::numeric, 2) as avg_height, 
	round(avg(player_weight)::numeric, 2) as avg_weight,
	round(avg(player_weight / power(player_height/100, 2))::numeric, 2) as avg_bmi 
from all_seasons as2 
group by "age"
order by 1 asc;

--liczba draftow w danej druzynie



------------ MATERIALY DODATKOWE --------------------

--pozycje graczy, potrzebny plik csv common_player_info 
--link: https://www.kaggle.com/datasets/wyattowalsh/basketball
select 
	as2.player_name, 
	cpi.display_first_last, 
	cpi."position", 
	as2.season 
from all_seasons as2 
left join common_player_info cpi
	on as2.player_name = cpi.display_first_last
order by as2.season;

--rozkład liczebności pozycji graczy (nie wszyscy gracze z pliku all_seasons!)
--puste oznacza chyba brak informacji o pozycji? 
select 
	 cpi."position",
	 count(as2.player_name)
from all_seasons as2 
left join common_player_info cpi
	on as2.player_name = cpi.display_first_last
where cpi.display_first_last is not null
group by cpi."position"
order by 1;



