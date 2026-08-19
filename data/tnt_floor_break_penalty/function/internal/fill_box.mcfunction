# 実行者(=create_boxを実行したプレイヤー)の足元のブロックを起点に、
# 相対座標(dx,dy,dz)分の直方体を指定ブロック(block)で塗りつぶす
$execute positioned ~ ~-1 ~ run fill ~ ~ ~ ~$(dx) ~$(dy) ~$(dz) $(block)
