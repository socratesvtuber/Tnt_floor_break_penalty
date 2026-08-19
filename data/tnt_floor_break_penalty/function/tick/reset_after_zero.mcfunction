# 床HPが0になってから10秒後、自動で呼ばれる処理。
# 現在の爆発回数(#broken)とTNT追跡状態だけをリセットして床HPを100%に戻す。
# 累計の総爆発回数(#total_explosions)はここではリセットしない(create_box/detect_boxで
# 新しく範囲を設定し直したときにのみリセットされる)。

tag @e[type=minecraft:tnt,tag=tfp_tracked] remove tfp_tracked
scoreboard players set #tnt_current penalty 0
scoreboard players set #tnt_prev penalty 0
scoreboard players set #broken penalty 0
scoreboard players set #triggered penalty 0

function tnt_floor_break_penalty:tick/update_gauge

tellraw @a [{"text":"[TNT床HP] 10秒経過したため床HPゲージをリセットしました(100%に復帰)","color":"green"}]
