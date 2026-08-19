# ブロックゲージを非表示にする
scoreboard players set #block_gauge_visible penalty 0
bossbar set minecraft:block_gauge players
tellraw @s [{"text":"[TNT床HP] ブロックゲージを非表示にしました","color":"yellow"}]
