# 現在の範囲内の空気ブロック数を「基準値」として記録する
# （以降、これより増えた分 = TNTで壊れたブロック数として扱う。範囲設定時、床は壊れていない状態を想定）
function tnt_floor_break_penalty:internal/count_air with storage tnt_floor_break_penalty:box
scoreboard players operation #initial_air penalty = #air penalty

scoreboard players set #broken penalty 0
scoreboard players set #triggered penalty 0

function tnt_floor_break_penalty:tick/update_gauge
function tnt_floor_break_penalty:tick/update_block_gauge
