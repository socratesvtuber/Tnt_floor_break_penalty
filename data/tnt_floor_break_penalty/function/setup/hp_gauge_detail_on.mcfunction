# 床HPゲージの表示を「詳細表示」（爆発回数・しきい値・総爆発回数も表示）に切り替える
scoreboard players set #hp_gauge_detail penalty 1
execute if score #configured penalty matches 1 run function tnt_floor_break_penalty:tick/update_gauge
tellraw @s [{"text":"[TNT床HP] 床HPゲージを詳細表示にしました（爆発回数・しきい値・総爆発回数も表示）","color":"green"}]
