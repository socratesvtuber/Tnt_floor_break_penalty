# 使い方: /function tnt_floor_break_penalty:setup/set_max_hits {count:50}
# 範囲内で壊れたブロック数がこの数に達すると床HPが0%になる、というしきい値を設定する
$scoreboard players set #max_hits penalty $(count)
execute if score #configured penalty matches 1 run function tnt_floor_break_penalty:tick/update_gauge
tellraw @s [{"text":"[TNT床HP] しきい値を設定しました: ","color":"green"},{"score":{"name":"#max_hits","objective":"penalty"},"color":"gold"},{"text":" 個","color":"green"}]
