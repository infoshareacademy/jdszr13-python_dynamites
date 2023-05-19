select count(*) as number_players_USA_EU,
avg(player_height) as AVG_height_EU_vs_USA, 
stddev(player_height) as STDDEV_height_EU_vs_USA, 
variance(player_height) VAR_height_EU_USA,  
corr (player_height, pts) as corr_height_pts_EU_vs_USA,
corr(player_height,usg_pct) as corr_height_usg_pct_EU_vs_USA,
corr(player_height,ts_pct) as corr_height_ts_pct_EU_vs_USA,
corr(player_height,ast) as corr_height_ast_EU_vs_USA,
corr(player_height,ast_pct) as corr_height_ast_pct_EU_vs_USA,
corr(player_height,reb) as corr_height_reb_EU_vs_USA,
corr(player_height,oreb_pct) as corr_height_oreb_pct_EU_vs_USA,
corr(player_height,dreb_pct) as corr_height_dreb_pct_EU_vs_USA,
avg(pts) as avg_pts_EU_vs_USA,
avg(usg_pct) as avg_usg_pct_EU_vs_USA,
avg(ts_pct) as avg_ts_pct_EU_vs_USA,
avg(ast) as avg_ast_EU_vs_USA,
avg(reb) as avg_reb_EU_vs_USA,
avg(oreb_pct) as avg_oreb_pct_EU_vs_USA,
avg(dreb_pct) as avg_dreb_pct_EU_vs_USA,
percentile_cont(0.25) within group (order by player_height) q1,
percentile_cont(0.5) within group (order by player_height) q2,
percentile_cont(0.75) within group (order by player_height) q3,
percentile_cont(0.25) within group (order by ts_pct) q1_ts_pct,
percentile_cont(0.5) within group (order by ts_pct) q2_ts_pct,
percentile_cont(0.75) within group (order by ts_pct) q3_ts_pct,
percentile_cont(0.25) within group (order by ast) q1_ast,
percentile_cont(0.5) within group (order by ast) q2_ast,
percentile_cont(0.75) within group (order by ast) q3_tast,
avg(player_weight/(player_height/100)^2) as BMI,
percentile_cont(0.25) within group (order by (player_weight/(player_height/100)^2)) BMI_q1,
percentile_cont(0.5) within group (order by (player_weight/(player_height/100)^2)) BMI_q2,
percentile_cont(0.75) within group (order by (player_weight/(player_height/100)^2)) BMI_q3
from
all_seasons
where country in
(select country
from all_seasons
where country in ('Poland', 'Bosnia & Herzegovina', 'Bosnia and Herzegovina', 'Czech Republic', 'Denmark','England', 'Finland', 'France', 'Georgia', 'Germany', 'Great Britain', 'Greece', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 'Macedonia', 'Netherlands', 'Poland', 'Portugal', 'Russia', 'Scotland', 'Serbia', 'Slovenia', 
'Spain', 'Sweden', 'Switzerland', 'Turkey', 'Ukraine', 'United Kingdom', 'Yugoslavia'))
union
select count(*) as number_player_USA_EU,
avg(player_height) as AVG_height_EU_vs_USA, 
stddev(player_height) as STDDEV_height_EU_vs_USA, 
variance(player_height) as VAR_height_EU_vs_USA, 
corr (player_height, pts) as corr_height_pts_EU_vs_USA, 
corr(player_height,usg_pct) as corr_height_usg_pct_EU_vs_USA, 
corr(player_height,ts_pct) as corr_height_ts_pct_EU_vs_USA,
corr(player_height,ast) as corr_height_ast_EU_vs_USA,
corr(player_height,ast_pct) as corr_height_ast_pct_EU_vs_USA,
corr(player_height,reb) as corr_height_reb_EU_vs_USA,
corr(player_height,oreb_pct) as corr_height_oreb_pct_EU_vs_USA,
corr(player_height,dreb_pct) as corr_height_dreb_pct_EU_vs_USA,
avg(pts) as avg_pts_EU_vs_USA,
avg(usg_pct) as avg_usg_pct_EU_vs_USA,
avg(ts_pct) as avg_ts_pct_EU_vs_USA,
avg(ast) as avg_ast_EU_vs_USA,
avg(reb) as avg_reb_EU_vs_USA,
avg(oreb_pct) as avg_oreb_pct_EU_vs_USA,
avg(dreb_pct) as avg_dreb_pct_EU_vs_USA,
percentile_cont(0.25) within group (order by player_height) q1,
percentile_cont(0.5) within group (order by player_height) q2,
percentile_cont(0.75) within group (order by player_height) q3,
percentile_cont(0.25) within group (order by ts_pct) q1_ts_pct,
percentile_cont(0.5) within group (order by ts_pct) q2_ts_pct,
percentile_cont(0.75) within group (order by ts_pct) q3_ts_pct,
percentile_cont(0.25) within group (order by ast) q1_ast,
percentile_cont(0.5) within group (order by ast) q2_ast,
percentile_cont(0.75) within group (order by ast) q3_ast,
avg(player_weight/(player_height/100)^2) as BMI,
percentile_cont(0.25) within group (order by (player_weight/(player_height/100)^2)) q1,
percentile_cont(0.5) within group (order by (player_weight/(player_height/100)^2)) BMI_q2,
percentile_cont(0.75) within group (order by (player_weight/(player_height/100)^2)) BMI_q3
from 
all_seasons
where country = 'USA'
group by country

--Wyżsi gracze mają więcej zbiórek
--Niżsi gracze mają wyższy procent asyst, ponieważ mogą mieć trudności w skutecznym rzucaniu na kosz lun rywalizacji w powietrzu

select player_name, player_height 
from
all_seasons
where player_height is null 

select * 
from
all_seasons

--W USA mamy niższy wzrost stosunku do EU i w USA wzrost jest bardziej zróżnicowany (zobaczymy jakie to teraz przełożenie na wyniki)
--Average number of points scored // Średnia liczba zdobytych punktów pts     

--Percentage of team plays used by the player while he was on the floor (FGA + Possession Ending FTA + TO) / POSS) //
--Procent zagrań zespołowych wykorzystanych przez zawodnika, gdy był na parkiecie (FGA + Zakończenie Posiadania FTA + TO) / POSS) usg_pct

--Measure of the player's shooting efficiency that takes into account free throws, 2 and 3 point shots (PTS / (2*(FGA + 0.44 * FTA)))
--Miara skuteczności rzutów zawodnika uwzględniająca rzuty wolne, rzuty za 2 i 3 punkty (PTS / (2*(FGA + 0,44 * FTA)) ts_pct

--Zawodnicy z Europy mają różnorodne style gry i techniki, które często różnią się od tych, z którymi spotykamy się w amerykańskiej koszykówce. 
--Niektórzy z europejskich zawodników wyróżniają się umiejętnościami strzeleckimi, inteligencją taktyczną czy umiejętnością gry zespołowej. 
--Wielu z nich ma również doświadczenie w profesjonalnych ligach europejskich przed dołączeniem do NBA, co przyczynia się do ich rozwoju jako zawodników.

--BMI
--Interpretacja wyniku
--<16,0	wygłodzenie
--16,0 – 16,9	wychudzenie
--17,0 - 18,5	niedowaga
--18,5–24,9	waga prawidłowa
--25,0–29,9	nadwaga
--30,0–34,9	otyłość I stopnia
--35,0–39,9	otyłość II stopnia
--≥40	otyłość III stopnia
