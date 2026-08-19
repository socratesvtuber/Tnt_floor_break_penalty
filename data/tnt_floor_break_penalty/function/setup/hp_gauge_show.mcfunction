# 床HPゲージを表示する
scoreboard players set #hp_gauge_visible penalty 1
bossbar set minecraft:hp_gauge players @a
tellraw @s [{"text":"[TNT床HP] 床HPゲージを表示しました","color":"green"}]
