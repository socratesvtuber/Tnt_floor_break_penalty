# 床HPが0になった瞬間の処理（-1WinをStreamToEarnオーバーレイへ反映する部分は未実装・要検討）
scoreboard players set #triggered penalty 1
title @a title [{"text":"床崩壊！","color":"red","bold":true}]
tellraw @a [{"text":"[TNT床HP] 床のHPが0になりました。-1Winの反映はStreamToEarn連携の実装待ちです","color":"red"}]
# TODO: StreamToEarnオーバーレイへ-1Winを通知する処理をここに追加
