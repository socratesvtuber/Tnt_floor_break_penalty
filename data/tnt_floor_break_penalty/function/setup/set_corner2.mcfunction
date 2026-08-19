# 立っているブロックの真上を基準に、足元の座標から2つ目の角を記録する
execute store result score #x2 penalty run data get entity @s Pos[0] 1
execute store result score #y2 penalty run data get entity @s Pos[1] 1
scoreboard players remove #y2 penalty 1
execute store result score #z2 penalty run data get entity @s Pos[2] 1

execute store result storage tnt_floor_break_penalty:box x2 int 1 run scoreboard players get #x2 penalty
execute store result storage tnt_floor_break_penalty:box y2 int 1 run scoreboard players get #y2 penalty
execute store result storage tnt_floor_break_penalty:box z2 int 1 run scoreboard players get #z2 penalty

function tnt_floor_break_penalty:setup/calc_max_space
function tnt_floor_break_penalty:setup/record_baseline

tellraw @s [{"text":"[TNT床HP] 2つ目の角を記録しました。範囲の合計マス数: ","color":"green"},{"score":{"name":"#max_space","objective":"penalty"},"color":"gold"},{"text":"個。監視を開始しました","color":"green"}]
