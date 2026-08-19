# 床を除いた内部空間が無い場合(create_boxで高さ1の床を作った場合など)の表示（0除算を避けるための専用処理）
execute if score #block_gauge_visible penalty matches 1 run bossbar set minecraft:block_gauge players @a

scoreboard players set #filled penalty 0
scoreboard players set #block_percent penalty 0
execute store result bossbar minecraft:block_gauge value run scoreboard players get #block_percent penalty

bossbar set minecraft:block_gauge name [{"text":"ブロックゲージ: 内部空間なし（床のみのため対象外）","color":"gray"}]
