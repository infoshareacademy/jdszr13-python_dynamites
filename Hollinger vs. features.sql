--tabela do działań analitycznych

with cechy as 
(select 
season as cechy_season
, player_name 
, "position"
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
from draft_combine_stats dcs
where dcs.player_name in (select h.player from hollingersstats h
union
select dcs.player_name from draft_combine_stats dcs)),

per as
(select per
, left(season,4)::int as per_season
, concat(left(season,2),right(season,2))::int as per_season2 
, player
from hollingersstats h 
where h.player in (select h.player from hollingersstats h 
union
select dcs.player_name from draft_combine_stats dcs))

select 
cechy_season
, per_season
, per_season2
, cechy.player_name 
, cechy."position"
, cechy.height_wo_shoes
, cechy.height_w_shoes
, cechy.weight
, cechy.wingspan
, cechy.standing_reach
, cechy.body_fat_pct
, cechy.hand_length
, cechy.hand_width
, cechy.standing_vertical_leap
, cechy.max_vertical_leap
, cechy.lane_agility_time
, cechy.three_quarter_sprint
, cechy.bench_press
, per.per
from cechy
join
per on cechy.player_name = per.player
where cechy_season = per_season or cechy_season = per_season2
order by cechy.player_name




--
--korelacja

select corr(height_wo_shoes,per)
from
(with cechy as 
(select 
season as cechy_season
, player_name 
, "position"
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
from draft_combine_stats dcs
where dcs.player_name in (select h.player from hollingersstats h
union
select dcs.player_name from draft_combine_stats dcs)),

per as
(select per
, left(season,4)::int as per_season
, concat(left(season,2),right(season,2))::int as per_season2 
, player
from hollingersstats h 
where h.player in (select h.player from hollingersstats h 
union
select dcs.player_name from draft_combine_stats dcs))

select 
cechy_season
, per_season
, per_season2
, cechy.player_name 
, cechy."position"
, cechy.height_wo_shoes
, cechy.height_w_shoes
, cechy.weight
, cechy.wingspan
, cechy.standing_reach
, cechy.body_fat_pct
, cechy.hand_length
, cechy.hand_width
, cechy.standing_vertical_leap
, cechy.max_vertical_leap
, cechy.lane_agility_time
, cechy.three_quarter_sprint
, cechy.bench_press
, per.per
from cechy
join
per on cechy.player_name = per.player
where cechy_season = per_season or cechy_season = per_season2
order by cechy.player_name) foo_fighters

