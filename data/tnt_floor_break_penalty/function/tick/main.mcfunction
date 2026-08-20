# 範囲が未設定の間は監視しない
execute if score #configured penalty matches 0 run return 0

# 1. 範囲内のTNT爆発回数を検知(ブロック破壊ではなくTNTエンティティの消滅で判定) → 床HPゲージを更新
function tnt_floor_break_penalty:tick/track_tnt with storage tnt_floor_break_penalty:box
function tnt_floor_break_penalty:tick/update_gauge

# 床HPが0になってからリセットまでの間、Win通知をアクションバーに毎tick出し続ける。
# チャット欄の行数(TNT連続爆発時など)に影響されず常に同じ位置に見える。
execute if score #triggered penalty matches 1 run title @a actionbar [{"text":"Win数をマイナス1してください","color":"gold","bold":true}]

# 2. 床を除いた内部空間の空気ブロック数を数える → ブロックゲージを更新
# （内部空間が無い(高さ1の)箱の場合はupdate_block_gauge_naで「対象外」表示にする）
execute if score #interior_space penalty matches 1.. run function tnt_floor_break_penalty:internal/count_air with storage tnt_floor_break_penalty:interior_region
execute if score #interior_space penalty matches 1.. run function tnt_floor_break_penalty:tick/update_block_gauge
execute if score #interior_space penalty matches ..0 run function tnt_floor_break_penalty:tick/update_block_gauge_na
