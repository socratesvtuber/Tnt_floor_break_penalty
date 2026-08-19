# 範囲が未設定の間は監視しない
execute if score #configured penalty matches 0 run return 0

# 1. 範囲内のTNT爆発回数を検知(ブロック破壊ではなくTNTエンティティの消滅で判定) → 床HPゲージを更新
function tnt_floor_break_penalty:tick/track_tnt with storage tnt_floor_break_penalty:box
function tnt_floor_break_penalty:tick/update_gauge

# 2. 箱全体(床も含む)の空気ブロック数を数える → ブロックゲージを更新
function tnt_floor_break_penalty:internal/count_air with storage tnt_floor_break_penalty:box
function tnt_floor_break_penalty:tick/update_block_gauge
