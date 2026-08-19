# スコアボードとボスバーの初期化
scoreboard objectives add penalty dummy

bossbar add hp_gauge "床HP"
bossbar set minecraft:hp_gauge color green
bossbar set minecraft:hp_gauge players @a

bossbar add block_gauge "ブロックゲージ"
bossbar set minecraft:block_gauge color blue
bossbar set minecraft:block_gauge players @a

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

# ブロックゲージ計算用（床を除いた内部空間で、埋まっているブロック数の割合＝埋め立て度）
scoreboard players set #filled penalty 0
scoreboard players set #block_percent penalty 0
scoreboard players set #interior_space penalty 0

# 各ゲージの表示ON/OFF状態（0=非表示 / 1=表示。デフォルトは両方表示）
scoreboard players set #hp_gauge_visible penalty 1
scoreboard players set #block_gauge_visible penalty 1

# setup/detect_boxの壁探索で使う最大探索距離（この距離内に壁が見つからなければ探索失敗とする）
scoreboard players set #probe_max penalty 128

bossbar set minecraft:hp_gauge name [{"text":"床HP: 未設定（setup/create_box または setup/detect_box で範囲を設定してください）","color":"red"}]
bossbar set minecraft:block_gauge name [{"text":"ブロックゲージ: 未設定（setup/create_box または setup/detect_box で範囲を設定してください）","color":"red"}]
