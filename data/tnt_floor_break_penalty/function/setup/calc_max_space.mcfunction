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

# 合計マス数(参考表示用。床も含めた箱全体) = dx * dy * dz
scoreboard players operation #max_space penalty = #dx penalty
scoreboard players operation #max_space penalty *= #dy penalty
scoreboard players operation #max_space penalty *= #dz penalty

# 床を除いた内部空間(y1+1〜y2)を「ブロックゲージ」用の範囲として保存
# （床は構造物として常に埋まっているため、ブロックゲージの集計からは除外する。
# 　高さ1(内部空間が無い)場合は#interior_spaceが0になり、ブロックゲージは対象外扱いにする）
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

# 箱全体(x1,y1,z1〜x2,y2,z2)をTNT検知(爆発回数カウント)のセレクタ範囲として保存
# （dx/dy/dzはセレクタ用に「x2-x1」等の差分そのものにする。create_box経由でも同じ値になる想定だが、
# 　detect_box経由でも必ず正しい値になるよう、ここで毎回上書きする）
scoreboard players operation #sel_dx penalty = #dx penalty
scoreboard players remove #sel_dx penalty 1
scoreboard players operation #sel_dy penalty = #dy penalty
scoreboard players remove #sel_dy penalty 1
scoreboard players operation #sel_dz penalty = #dz penalty
scoreboard players remove #sel_dz penalty 1
execute store result storage tnt_floor_break_penalty:box dx int 1 run scoreboard players get #sel_dx penalty
execute store result storage tnt_floor_break_penalty:box dy int 1 run scoreboard players get #sel_dy penalty
execute store result storage tnt_floor_break_penalty:box dz int 1 run scoreboard players get #sel_dz penalty

scoreboard players set #configured penalty 1
