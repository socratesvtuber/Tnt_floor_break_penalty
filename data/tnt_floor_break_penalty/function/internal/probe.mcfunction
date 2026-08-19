# 探索の1ステップ。(x,y,z)が空気でなければ、そこを壁とみなし1マス手前(dx,dzを引いた座標)を
# 境界としてprobe_resultに記録して終了する。空気ならさらに1マス先へ進んで探索を続ける。
# remainingが尽きても壁が見つからなければ、探索失敗(#probe_ok=0)として打ち切る。
$scoreboard players set #probe_remaining penalty $(remaining)

$execute unless block $(x) $(y) $(z) #minecraft:air run function tnt_floor_break_penalty:internal/probe_hit with storage tnt_floor_break_penalty:probe
$execute if block $(x) $(y) $(z) #minecraft:air if score #probe_remaining penalty matches ..0 run function tnt_floor_break_penalty:internal/probe_timeout
$execute if block $(x) $(y) $(z) #minecraft:air if score #probe_remaining penalty matches 1.. run function tnt_floor_break_penalty:internal/probe_advance with storage tnt_floor_break_penalty:probe
