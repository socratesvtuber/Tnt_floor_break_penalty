# スコアボードとボスバーの初期化
scoreboard objectives add penalty dummy
bossbar add hp_gauge "床HP"
bossbar set minecraft:hp_gauge color green
bossbar set minecraft:hp_gauge players @a

# 計算用の固定数値
scoreboard players set #100 penalty 100
scoreboard players set #neg1 penalty -1

# 計測範囲の設定状態（0=未設定 / 1=設定済み）
scoreboard players set #configured penalty 0

# 角の座標・合計マス数の初期値（未設定時のダミー値）
scoreboard players set #x1 penalty 0
scoreboard players set #y1 penalty 0
scoreboard players set #z1 penalty 0
scoreboard players set #x2 penalty 0
scoreboard players set #y2 penalty 0
scoreboard players set #z2 penalty 0
scoreboard players set #max_space penalty 1

# HP計算用（壊れたブロック数としきい値。しきい値はデフォルト50個で、setup/set_max_hitsで変更可能）
scoreboard players set #initial_air penalty 0
scoreboard players set #broken penalty 0
scoreboard players set #max_hits penalty 50
scoreboard players set #triggered penalty 0

bossbar set minecraft:hp_gauge name [{"text":"床HP: 未設定（setup/set_corner1 と setup/set_corner2 で範囲を設定してください）","color":"red"}]
