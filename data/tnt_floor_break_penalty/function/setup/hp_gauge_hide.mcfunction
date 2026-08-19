# 床HPゲージを非表示にする
scoreboard players set #hp_gauge_visible penalty 0
bossbar set minecraft:hp_gauge players
tellraw @s [{"text":"[TNT床HP] 床HPゲージを非表示にしました","color":"yellow"}]
