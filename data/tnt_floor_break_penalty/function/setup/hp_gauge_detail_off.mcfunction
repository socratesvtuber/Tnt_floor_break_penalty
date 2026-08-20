# 床HPゲージの表示を「シンプル表示」（床HP%のみ）に切り替える
scoreboard players set #hp_gauge_detail penalty 0
execute if score #configured penalty matches 1 run function tnt_floor_break_penalty:tick/update_gauge
tellraw @s [{"text":"[TNT床HP] 床HPゲージをシンプル表示にしました（床HP%のみ）","color":"green"}]
