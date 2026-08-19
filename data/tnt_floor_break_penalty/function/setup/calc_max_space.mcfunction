# dx = |x2 - x1| + 1
scoreboard players operation #dx penalty = #x2 penalty
scoreboard players operation #dx penalty -= #x1 penalty
execute if score #dx penalty matches ..-1 run scoreboard players operation #dx penalty *= #neg1 penalty
scoreboard players add #dx penalty 1

# dy = |y2 - y1| + 1
scoreboard players operation #dy penalty = #y2 penalty
scoreboard players operation #dy penalty -= #y1 penalty
execute if score #dy penalty matches ..-1 run scoreboard players operation #dy penalty *= #neg1 penalty
scoreboard players add #dy penalty 1

# dz = |z2 - z1| + 1
scoreboard players operation #dz penalty = #z2 penalty
scoreboard players operation #dz penalty -= #z1 penalty
execute if score #dz penalty matches ..-1 run scoreboard players operation #dz penalty *= #neg1 penalty
scoreboard players add #dz penalty 1

# 合計マス数 = dx * dy * dz
scoreboard players operation #max_space penalty = #dx penalty
scoreboard players operation #max_space penalty *= #dy penalty
scoreboard players operation #max_space penalty *= #dz penalty

scoreboard players set #configured penalty 1
