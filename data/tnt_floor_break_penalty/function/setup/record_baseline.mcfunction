# TNT爆発回数のカウント(現在値・累計とも)をリセットする
# （以前この範囲を追跡していたTNTのタグが残っていれば外し、まっさらな状態から数え直す）
tag @e[type=minecraft:tnt,tag=tfp_tracked] remove tfp_tracked
scoreboard players set #tnt_current penalty 0
scoreboard players set #tnt_prev penalty 0
scoreboard players set #broken penalty 0
scoreboard players set #total_explosions penalty 0
scoreboard players set #triggered penalty 0

function tnt_floor_break_penalty:tick/update_gauge

# ブロックゲージ(床を除いた内部空間の埋まり具合)は基準値を持たず毎回その場の状態を表示するので、
# ここでは現在の空気ブロック数を数えて即座に反映するだけでよい
execute if score #interior_space penalty matches 1.. run function tnt_floor_break_penalty:internal/count_air with storage tnt_floor_break_penalty:interior_region
execute if score #interior_space penalty matches 1.. run function tnt_floor_break_penalty:tick/update_block_gauge
execute if score #interior_space penalty matches ..0 run function tnt_floor_break_penalty:tick/update_block_gauge_na
