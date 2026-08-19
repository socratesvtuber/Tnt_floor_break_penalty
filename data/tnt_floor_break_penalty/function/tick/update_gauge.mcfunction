# 表示ON/OFF状態を反映（ONの間は毎tick再表示し、新規参加者にも見えるようにする）
execute if score #hp_gauge_visible penalty matches 1 run bossbar set minecraft:hp_gauge players @a

# 残りHP = しきい値 − TNT爆発回数（0未満は0にクランプ）
scoreboard players operation #remaining penalty = #max_hits penalty
scoreboard players operation #remaining penalty -= #broken penalty
execute if score #remaining penalty matches ..-1 run scoreboard players set #remaining penalty 0

# ％の計算
scoreboard players operation #percent penalty = #remaining penalty
scoreboard players operation #percent penalty *= #100 penalty
scoreboard players operation #percent penalty /= #max_hits penalty

# ボスバーのゲージ長を更新
execute store result bossbar minecraft:hp_gauge value run scoreboard players get #percent penalty

# 色を段階的に切り替える（100-67%:緑 / 66-34%:黄 / 33-0%:赤）
execute if score #percent penalty matches 67.. run bossbar set minecraft:hp_gauge color green
execute if score #percent penalty matches 34..66 run bossbar set minecraft:hp_gauge color yellow
execute if score #percent penalty matches ..33 run bossbar set minecraft:hp_gauge color red

# 表示テキストを更新
bossbar set minecraft:hp_gauge name [{"text":"床HP: "},{"score":{"name":"#percent","objective":"penalty"},"color":"gold"},{"text":"% （爆発回数: "},{"score":{"name":"#broken","objective":"penalty"}},{"text":" / "},{"score":{"name":"#max_hits","objective":"penalty"}},{"text":" ・ 総爆発回数: "},{"score":{"name":"#total_explosions","objective":"penalty"},"color":"aqua"},{"text":"）"}]

# HPが0になった瞬間に一度だけ発火
execute if score #percent penalty matches 0 if score #triggered penalty matches 0 run function tnt_floor_break_penalty:tick/on_zero
