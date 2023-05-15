

--połączone tabele drafts i all_seasons po stworzonym id
select corr (pts, weight) pts_weight
,corr (reb, weight) reb_weight
,corr (ast, weight) ast_weight
,corr (pts, standing_reach) pts_standing_reach
from
(select * from
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



