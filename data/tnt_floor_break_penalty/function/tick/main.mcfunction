# 範囲が未設定の間は監視しない
execute if score #configured penalty matches 0 run return 0

# 1. 範囲内の空気ブロック数を数える
function tnt_floor_break_penalty:internal/count_air with storage tnt_floor_break_penalty:box

# 2. 基準値との差分 = 壊れたブロック数（ブロックは増えない想定なので負値は0にクランプ）
scoreboard players operation #broken penalty = #air penalty
scoreboard players operation #broken penalty -= #initial_air penalty
execute if score #broken penalty matches ..-1 run scoreboard players set #broken penalty 0

# 3. ゲージの計算・表示を更新
function tnt_floor_break_penalty:tick/update_gauge
