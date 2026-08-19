# 範囲(x1,y1,z1)〜(x2,y2,z2)内の空気ブロック数を数え、#airに格納する
# umitate_gaugeと同じ手法：範囲を上空(0 250 0)へfiltered cloneし、その成功個数を結果として取得する
$execute store result score #air penalty run clone $(x1) $(y1) $(z1) $(x2) $(y2) $(z2) 0 250 0 filtered air normal
