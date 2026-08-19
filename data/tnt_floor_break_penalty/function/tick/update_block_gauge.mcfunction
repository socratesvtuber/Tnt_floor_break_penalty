# 表示ON/OFF状態を反映（ONの間は毎tick再表示し、新規参加者にも見えるようにする）
execute if score #block_gauge_visible penalty matches 1 run bossbar set minecraft:block_gauge players @a

# 埋まっている（＝壊れていない）ブロック数 = 合計マス数 − 空気ブロック数
scoreboard players operation #filled penalty = #max_space penalty
scoreboard players operation #filled penalty -= #air penalty

# ％の計算（範囲全体に対する残存ブロックの割合）
scoreboard players operation #block_percent penalty = #filled penalty
scoreboard players operation #block_percent penalty *= #100 penalty
scoreboard players operation #block_percent penalty /= #max_space penalty

# ボスバーのゲージ長を更新
execute store result bossbar minecraft:block_gauge value run scoreboard players get #block_percent penalty

# 表示テキストを更新
bossbar set minecraft:block_gauge name [{"text":"ブロックゲージ: "},{"score":{"name":"#block_percent","objective":"penalty"},"color":"aqua"},{"text":"% （残り "},{"score":{"name":"#filled","objective":"penalty"},"color":"gold"},{"text":" / "},{"score":{"name":"#max_space","objective":"penalty"},"color":"gold"},{"text":"）"}]
