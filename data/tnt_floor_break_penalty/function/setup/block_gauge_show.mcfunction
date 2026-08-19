# ブロックゲージを表示する
scoreboard players set #block_gauge_visible penalty 1
bossbar set minecraft:block_gauge players @a
tellraw @s [{"text":"[TNT床HP] ブロックゲージを表示しました","color":"green"}]
