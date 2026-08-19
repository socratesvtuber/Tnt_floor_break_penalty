# 範囲が未設定の間は監視しない
execute if score #configured penalty matches 0 run return 0

# 1. 範囲内のTNT爆発回数を検知(ブロック破壊ではなくTNTエンティティの消滅で判定) → 床HPゲージを更新
function tnt_floor_break_penalty:tick/track_tnt with storage tnt_floor_break_penalty:box
function tnt_floor_break_penalty:tick/update_gauge

# 2. 床を除いた内部空間の空気ブロック数を数える → ブロックゲージを更新
# （高さ1で内部空間が無い場合はupdate_block_gauge_naで「対象外」表示にする）
execute if score #interior_space penalty matches 1.. run function tnt_floor_break_penalty:internal/count_air with storage tnt_floor_break_penalty:interior_region
execute if score #interior_space penalty matches 1.. run function tnt_floor_break_penalty:tick/update_block_gauge
execute if score #interior_space penalty matches ..0 run function tnt_floor_break_penalty:tick/update_block_gauge_na
