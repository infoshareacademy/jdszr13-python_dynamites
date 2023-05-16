

--połączone tabele drafts i all_seasons po stworzonym id

--pierwsze korelacje
select corr (pts, weight) pts_weight
,corr (reb, weight) reb_weight
,corr (ast, weight) ast_weight
,corr (pts, standing_reach) pts_standing_reach
from
(select 
zawodnik_nba
, team_abbreviation,
wszystkiesezony.age
player_height,
player_weight,
college,
country,
gp,
pts,
reb,
ast,
net_rating,
oreb_pct,
dreb_pct,
usg_pct,
ts_pct
, ast_pct
, sezon
, position
, height_wo_shoes
, height_w_shoes
, weight
, wingspan
, standing_reach
, body_fat_pct
, hand_length
, hand_width
, standing_vertical_leap
, max_vertical_leap
, lane_agility_time
, three_quarter_sprint
, bench_press
from
(select 
*,  
dra.season as sezon,
nba.player_name as zawodnik_nba,
dra.player_name as zawodnik_dra,
left(nba.season,4)::int pierwszy,
concat((substring(nba.season,1,2)),(right(nba.season,2)))::int drugi
	from
	(select * from all_seasons as3 
	where player_name in
	(select player_name from all_seasons as2 
	union
	select player_name from draft_combine_stats dcs)) nba
	left join 
	(select * from draft_combine_stats dcs2 
	where player_name in
	(select player_name from all_seasons as2 
	union
	select player_name from draft_combine_stats dcs)) dra
	on nba.player_name = dra.player_name) wszystkiesezony
where zawodnik_dra = zawodnik_nba and sezon = pierwszy or sezon=drugi
order by zawodnik_dra) tabeleczka

--tabelka do zabawy

select 
zawodnik_nba
, team_abbreviation,
wszystkiesezony.age
player_height,
player_weight,
college,
country,
gp,
pts,
reb,
ast,
net_rating,
oreb_pct,
dreb_pct,
usg_pct,
ts_pct
, ast_pct
, sezon
, position
, height_wo_shoes
, height_w_shoes
, weight
, wingspan
, standing_reach
, body_fat_pct
, hand_length
, hand_width
, standing_vertical_leap
, max_vertical_leap
, lane_agility_time
, three_quarter_sprint
, bench_press
from
(select 
*,  
dra.season as sezon,
nba.player_name as zawodnik_nba,
dra.player_name as zawodnik_dra,
left(nba.season,4)::int pierwszy,
concat((substring(nba.season,1,2)),(right(nba.season,2)))::int drugi
	from
	(select * from all_seasons as3 
	where player_name in
	(select player_name from all_seasons as2 
	union
	select player_name from draft_combine_stats dcs)) nba
	left join 
	(select * from draft_combine_stats dcs2 
	where player_name in
	(select player_name from all_seasons as2 
	union
	select player_name from draft_combine_stats dcs)) dra
	on nba.player_name = dra.player_name) wszystkiesezony
where zawodnik_dra = zawodnik_nba and sezon = pierwszy or sezon=drugi
order by zawodnik_dra