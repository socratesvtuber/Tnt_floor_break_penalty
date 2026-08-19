# 床(1層)の空気ブロック数を「基準値」として記録する
# （以降、これより増えた分 = TNTで壊れたブロック数として扱う。範囲設定時、床は壊れていない状態を想定）
function tnt_floor_break_penalty:internal/count_air with storage tnt_floor_break_penalty:floor_region
scoreboard players operation #initial_air penalty = #air penalty

scoreboard players set #broken penalty 0
scoreboard players set #triggered penalty 0

function tnt_floor_break_penalty:tick/update_gauge

# ブロックゲージ(内部空間の埋まり具合)は基準値を持たず毎回その場の状態を表示するので、
# ここでは現在の内部空間の空気ブロック数を数えて即座に反映するだけでよい
execute if score #interior_space penalty matches 1.. run function tnt_floor_break_penalty:internal/count_air with storage tnt_floor_break_penalty:interior_region
execute if score #interior_space penalty matches 1.. run function tnt_floor_break_penalty:tick/update_block_gauge
execute if score #interior_space penalty matches ..0 run function tnt_floor_break_penalty:tick/update_block_gauge_na
