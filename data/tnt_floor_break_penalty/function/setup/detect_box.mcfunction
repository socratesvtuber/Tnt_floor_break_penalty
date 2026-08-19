# 使い方: /function tnt_floor_break_penalty:setup/detect_box {height:5}
# プレイヤーが既存の埋め立て用ボックスの内部(床の上)に立っている前提で、
# 東西南北へ壁(空気以外のブロック)を自動探索して床の範囲(x1,z1,x2,z2)を検出し、
# ブロックゲージ・床HPゲージの両方をこの範囲でまとめてセットアップする。
# 天井の無い箱を想定しているため、高さ(Y方向)だけは引数 height で指定する。

# 基準座標(プレイヤーの足元のブロック)
execute store result score #origin_x penalty run data get entity @s Pos[0] 1
execute store result score #origin_y penalty run data get entity @s Pos[1] 1
scoreboard players remove #origin_y penalty 1
execute store result score #origin_z penalty run data get entity @s Pos[2] 1

# 壁探索は床の1つ上(プレイヤーが実際に立っている空気の階層)で行う
# （床ブロック自体の高さで探索すると、床が空気でないため探索開始直後に壁と誤判定してしまう）
scoreboard players operation #probe_y_level penalty = #origin_y penalty
scoreboard players add #probe_y_level penalty 1

scoreboard players set #probe_ok penalty 1

# +X方向(東)を探索 → x2
data modify storage tnt_floor_break_penalty:probe dx set value 1
data modify storage tnt_floor_break_penalty:probe dz set value 0
execute store result storage tnt_floor_break_penalty:probe x int 1 run scoreboard players get #origin_x penalty
execute store result storage tnt_floor_break_penalty:probe y int 1 run scoreboard players get #probe_y_level penalty
execute store result storage tnt_floor_break_penalty:probe z int 1 run scoreboard players get #origin_z penalty
execute store result storage tnt_floor_break_penalty:probe remaining int 1 run scoreboard players get #probe_max penalty
execute if score #probe_ok penalty matches 1 run function tnt_floor_break_penalty:internal/probe with storage tnt_floor_break_penalty:probe
execute if score #probe_ok penalty matches 1 run execute store result score #x2 penalty run data get storage tnt_floor_break_penalty:probe_result x

# -X方向(西)を探索 → x1
data modify storage tnt_floor_break_penalty:probe dx set value -1
data modify storage tnt_floor_break_penalty:probe dz set value 0
execute store result storage tnt_floor_break_penalty:probe x int 1 run scoreboard players get #origin_x penalty
execute store result storage tnt_floor_break_penalty:probe y int 1 run scoreboard players get #probe_y_level penalty
execute store result storage tnt_floor_break_penalty:probe z int 1 run scoreboard players get #origin_z penalty
execute store result storage tnt_floor_break_penalty:probe remaining int 1 run scoreboard players get #probe_max penalty
execute if score #probe_ok penalty matches 1 run function tnt_floor_break_penalty:internal/probe with storage tnt_floor_break_penalty:probe
execute if score #probe_ok penalty matches 1 run execute store result score #x1 penalty run data get storage tnt_floor_break_penalty:probe_result x

# +Z方向(南)を探索 → z2
data modify storage tnt_floor_break_penalty:probe dx set value 0
data modify storage tnt_floor_break_penalty:probe dz set value 1
execute store result storage tnt_floor_break_penalty:probe x int 1 run scoreboard players get #origin_x penalty
execute store result storage tnt_floor_break_penalty:probe y int 1 run scoreboard players get #probe_y_level penalty
execute store result storage tnt_floor_break_penalty:probe z int 1 run scoreboard players get #origin_z penalty
execute store result storage tnt_floor_break_penalty:probe remaining int 1 run scoreboard players get #probe_max penalty
execute if score #probe_ok penalty matches 1 run function tnt_floor_break_penalty:internal/probe with storage tnt_floor_break_penalty:probe
execute if score #probe_ok penalty matches 1 run execute store result score #z2 penalty run data get storage tnt_floor_break_penalty:probe_result z

# -Z方向(北)を探索 → z1
data modify storage tnt_floor_break_penalty:probe dx set value 0
data modify storage tnt_floor_break_penalty:probe dz set value -1
execute store result storage tnt_floor_break_penalty:probe x int 1 run scoreboard players get #origin_x penalty
execute store result storage tnt_floor_break_penalty:probe y int 1 run scoreboard players get #probe_y_level penalty
execute store result storage tnt_floor_break_penalty:probe z int 1 run scoreboard players get #origin_z penalty
execute store result storage tnt_floor_break_penalty:probe remaining int 1 run scoreboard players get #probe_max penalty
execute if score #probe_ok penalty matches 1 run function tnt_floor_break_penalty:internal/probe with storage tnt_floor_break_penalty:probe
execute if score #probe_ok penalty matches 1 run execute store result score #z1 penalty run data get storage tnt_floor_break_penalty:probe_result z

# 既定の探索距離内に壁が見つからなかった場合は中断
execute unless score #probe_ok penalty matches 1 run tellraw @s [{"text":"[TNT床HP] 壁が見つかりませんでした。埋め立て用ボックスの内部(床の上)で実行してください","color":"red"}]
execute unless score #probe_ok penalty matches 1 run return 0

# 高さ(Y方向)は引数指定。y1=足元の高さ、y2=y1+height-1
$scoreboard players set #h penalty $(height)
scoreboard players operation #y1 penalty = #origin_y penalty
scoreboard players operation #y2 penalty = #y1 penalty
scoreboard players operation #y2 penalty += #h penalty
scoreboard players remove #y2 penalty 1

# 検出した範囲をstorageへ保存
execute store result storage tnt_floor_break_penalty:box x1 int 1 run scoreboard players get #x1 penalty
execute store result storage tnt_floor_break_penalty:box y1 int 1 run scoreboard players get #y1 penalty
execute store result storage tnt_floor_break_penalty:box z1 int 1 run scoreboard players get #z1 penalty
execute store result storage tnt_floor_break_penalty:box x2 int 1 run scoreboard players get #x2 penalty
execute store result storage tnt_floor_break_penalty:box y2 int 1 run scoreboard players get #y2 penalty
execute store result storage tnt_floor_break_penalty:box z2 int 1 run scoreboard players get #z2 penalty

# ブロックゲージ・床HPゲージの両方をこの範囲でまとめてセットアップ
function tnt_floor_break_penalty:setup/calc_max_space
function tnt_floor_break_penalty:setup/record_baseline

tellraw @s [{"text":"[TNT床HP] 既存の箱を検出しました。範囲: x","color":"green"},{"score":{"name":"#x1","objective":"penalty"}},{"text":"〜"},{"score":{"name":"#x2","objective":"penalty"}},{"text":" / z"},{"score":{"name":"#z1","objective":"penalty"}},{"text":"〜"},{"score":{"name":"#z2","objective":"penalty"}},{"text":" / 高さ"},{"score":{"name":"#h","objective":"penalty"}},{"text":"（合計 "},{"score":{"name":"#max_space","objective":"penalty"},"color":"gold"},{"text":" マス）。監視を開始しました","color":"green"}]
