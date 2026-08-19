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

# 合計マス数(参考表示用) = dx * dy * dz
scoreboard players operation #max_space penalty = #dx penalty
scoreboard players operation #max_space penalty *= #dy penalty
scoreboard players operation #max_space penalty *= #dz penalty

# 床(y1の1層だけ)を「床HPゲージ」用の範囲として保存
execute store result storage tnt_floor_break_penalty:floor_region x1 int 1 run scoreboard players get #x1 penalty
execute store result storage tnt_floor_break_penalty:floor_region z1 int 1 run scoreboard players get #z1 penalty
execute store result storage tnt_floor_break_penalty:floor_region x2 int 1 run scoreboard players get #x2 penalty
execute store result storage tnt_floor_break_penalty:floor_region z2 int 1 run scoreboard players get #z2 penalty
execute store result storage tnt_floor_break_penalty:floor_region y1 int 1 run scoreboard players get #y1 penalty
execute store result storage tnt_floor_break_penalty:floor_region y2 int 1 run scoreboard players get #y1 penalty

# 床を除いた内部空間(y1+1〜y2)を「ブロックゲージ」用の範囲として保存
# （高さ1の箱は内部空間が無いので、#interior_spaceは0になる＝ブロックゲージは対象外扱い）
scoreboard players operation #interior_h penalty = #dy penalty
scoreboard players remove #interior_h penalty 1
execute if score #interior_h penalty matches ..-1 run scoreboard players set #interior_h penalty 0

scoreboard players operation #interior_space penalty = #dx penalty
scoreboard players operation #interior_space penalty *= #dz penalty
scoreboard players operation #interior_space penalty *= #interior_h penalty

execute store result storage tnt_floor_break_penalty:interior_region x1 int 1 run scoreboard players get #x1 penalty
execute store result storage tnt_floor_break_penalty:interior_region z1 int 1 run scoreboard players get #z1 penalty
execute store result storage tnt_floor_break_penalty:interior_region x2 int 1 run scoreboard players get #x2 penalty
execute store result storage tnt_floor_break_penalty:interior_region z2 int 1 run scoreboard players get #z2 penalty
scoreboard players operation #interior_y1 penalty = #y1 penalty
scoreboard players add #interior_y1 penalty 1
execute store result storage tnt_floor_break_penalty:interior_region y1 int 1 run scoreboard players get #interior_y1 penalty
execute store result storage tnt_floor_break_penalty:interior_region y2 int 1 run scoreboard players get #y2 penalty

scoreboard players set #configured penalty 1
