# 使い方: /function tnt_floor_break_penalty:setup/create_box {width:10, height:1, depth:10, block:"minecraft:stone"}
# 実行したプレイヤーが立っているブロックを基準(1つ目の角)に、指定したサイズ・素材で床(箱)を自動生成し、監視範囲として設定する
# width=横(x方向) height=高さ(y方向) depth=縦(z方向)

# 基準座標(1つ目の角=プレイヤーの足元のブロック)を記録
execute store result score #x1 penalty run data get entity @s Pos[0] 1
execute store result score #y1 penalty run data get entity @s Pos[1] 1
scoreboard players remove #y1 penalty 1
execute store result score #z1 penalty run data get entity @s Pos[2] 1

# サイズを取得し、1つ目の角からのオフセット(サイズ-1)を計算
$scoreboard players set #w penalty $(width)
$scoreboard players set #h penalty $(height)
$scoreboard players set #d penalty $(depth)

scoreboard players operation #dx penalty = #w penalty
scoreboard players remove #dx penalty 1
scoreboard players operation #dy penalty = #h penalty
scoreboard players remove #dy penalty 1
scoreboard players operation #dz penalty = #d penalty
scoreboard players remove #dz penalty 1

# 2つ目の角の座標 = 1つ目の角 + オフセット
scoreboard players operation #x2 penalty = #x1 penalty
scoreboard players operation #x2 penalty += #dx penalty
scoreboard players operation #y2 penalty = #y1 penalty
scoreboard players operation #y2 penalty += #dy penalty
scoreboard players operation #z2 penalty = #z1 penalty
scoreboard players operation #z2 penalty += #dz penalty

# 座標・オフセット・素材ブロックをstorageへ保存
execute store result storage tnt_floor_break_penalty:box x1 int 1 run scoreboard players get #x1 penalty
execute store result storage tnt_floor_break_penalty:box y1 int 1 run scoreboard players get #y1 penalty
execute store result storage tnt_floor_break_penalty:box z1 int 1 run scoreboard players get #z1 penalty
execute store result storage tnt_floor_break_penalty:box x2 int 1 run scoreboard players get #x2 penalty
execute store result storage tnt_floor_break_penalty:box y2 int 1 run scoreboard players get #y2 penalty
execute store result storage tnt_floor_break_penalty:box z2 int 1 run scoreboard players get #z2 penalty
execute store result storage tnt_floor_break_penalty:box dx int 1 run scoreboard players get #dx penalty
execute store result storage tnt_floor_break_penalty:box dy int 1 run scoreboard players get #dy penalty
execute store result storage tnt_floor_break_penalty:box dz int 1 run scoreboard players get #dz penalty
$data modify storage tnt_floor_break_penalty:box block set value $(block)

# 床(箱)を自動生成する(1つ目の角を起点に、相対座標でfill)
function tnt_floor_break_penalty:internal/fill_box with storage tnt_floor_break_penalty:box

function tnt_floor_break_penalty:setup/calc_max_space
function tnt_floor_break_penalty:setup/record_baseline

tellraw @s [{"text":"[TNT床HP] 床を生成しました。サイズ: ","color":"green"},{"score":{"name":"#w","objective":"penalty"}},{"text":"(横)×"},{"score":{"name":"#h","objective":"penalty"}},{"text":"(高さ)×"},{"score":{"name":"#d","objective":"penalty"}},{"text":"(縦)。監視を開始しました","color":"green"}]
