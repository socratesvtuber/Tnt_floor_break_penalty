# 立っているブロックの真上を基準に、足元の座標から1つ目の角（床の範囲）を記録する
# （プレイヤーの足元Y座標は「乗っているブロックの1つ上」になるため、Yは-1補正する）
execute store result score #x1 penalty run data get entity @s Pos[0] 1
execute store result score #y1 penalty run data get entity @s Pos[1] 1
scoreboard players remove #y1 penalty 1
execute store result score #z1 penalty run data get entity @s Pos[2] 1

execute store result storage tnt_floor_break_penalty:box x1 int 1 run scoreboard players get #x1 penalty
execute store result storage tnt_floor_break_penalty:box y1 int 1 run scoreboard players get #y1 penalty
execute store result storage tnt_floor_break_penalty:box z1 int 1 run scoreboard players get #z1 penalty

tellraw @s [{"text":"[TNT床HP] 1つ目の角を記録しました: ","color":"green"},{"score":{"name":"#x1","objective":"penalty"}},{"text":", "},{"score":{"name":"#y1","objective":"penalty"}},{"text":", "},{"score":{"name":"#z1","objective":"penalty"}}]
