# 空気だったので1マス先(dx,dz方向)へ進んで探索を続ける
$scoreboard players set #probe_x penalty $(x)
$scoreboard players set #probe_y penalty $(y)
$scoreboard players set #probe_z penalty $(z)
$scoreboard players set #probe_dx penalty $(dx)
$scoreboard players set #probe_dz penalty $(dz)
scoreboard players operation #probe_x penalty += #probe_dx penalty
scoreboard players operation #probe_z penalty += #probe_dz penalty
scoreboard players remove #probe_remaining penalty 1

execute store result storage tnt_floor_break_penalty:probe x int 1 run scoreboard players get #probe_x penalty
execute store result storage tnt_floor_break_penalty:probe y int 1 run scoreboard players get #probe_y penalty
execute store result storage tnt_floor_break_penalty:probe z int 1 run scoreboard players get #probe_z penalty
execute store result storage tnt_floor_break_penalty:probe dx int 1 run scoreboard players get #probe_dx penalty
execute store result storage tnt_floor_break_penalty:probe dz int 1 run scoreboard players get #probe_dz penalty
execute store result storage tnt_floor_break_penalty:probe remaining int 1 run scoreboard players get #probe_remaining penalty

function tnt_floor_break_penalty:internal/probe with storage tnt_floor_break_penalty:probe
