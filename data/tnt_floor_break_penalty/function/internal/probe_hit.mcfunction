# 壁を検知。1マス手前(dx,dzだけ戻った座標)を範囲の内側境界としてprobe_resultへ記録する
$scoreboard players set #probe_x penalty $(x)
$scoreboard players set #probe_z penalty $(z)
$scoreboard players set #probe_dx penalty $(dx)
$scoreboard players set #probe_dz penalty $(dz)
scoreboard players operation #probe_x penalty -= #probe_dx penalty
scoreboard players operation #probe_z penalty -= #probe_dz penalty

execute store result storage tnt_floor_break_penalty:probe_result x int 1 run scoreboard players get #probe_x penalty
execute store result storage tnt_floor_break_penalty:probe_result z int 1 run scoreboard players get #probe_z penalty
scoreboard players set #probe_ok penalty 1
