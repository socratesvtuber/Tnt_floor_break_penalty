# 範囲(箱全体)内のTNTエンティティを追跡し、消滅(=爆発)した数を#brokenへ積算する。
# mobGriefingがfalseでブロックが壊れない環境でも、TNTの起爆自体はブロックの有無に関係なく検知できる。
# 呼び出し方: function ...:tick/track_tnt with storage tnt_floor_break_penalty:box

# 1. まだ追跡していないTNTにタグを付ける
$tag @e[type=minecraft:tnt,tag=!tfp_tracked,x=$(x1),y=$(y1),z=$(z1),dx=$(dx),dy=$(dy),dz=$(dz)] add tfp_tracked

# 2. 現在、範囲内で追跡中のTNTの数を数える
scoreboard players set #tnt_current penalty 0
$execute as @e[type=minecraft:tnt,tag=tfp_tracked,x=$(x1),y=$(y1),z=$(z1),dx=$(dx),dy=$(dy),dz=$(dz)] run scoreboard players add #tnt_current penalty 1

# 3. 前回より減っていれば、その差分だけ爆発した(=範囲外に消えた)とみなしてカウントする
# （TNTが爆発せず範囲の外へ転がり出た場合も稀に誤カウントし得るが、簡易的にこの方式とする）
# #brokenは10秒後の自動リセットで0に戻る「現在の爆発回数」、#total_explosionsはリセットされない累計値
scoreboard players operation #tnt_diff penalty = #tnt_prev penalty
scoreboard players operation #tnt_diff penalty -= #tnt_current penalty
execute if score #tnt_diff penalty matches 1.. run scoreboard players operation #broken penalty += #tnt_diff penalty
execute if score #tnt_diff penalty matches 1.. run scoreboard players operation #total_explosions penalty += #tnt_diff penalty

scoreboard players operation #tnt_prev penalty = #tnt_current penalty
