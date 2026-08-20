# 床HPが0になった瞬間の処理（-1WinをStreamToEarnオーバーレイへ自動反映する部分は未実装・要検討。
# 現状は画面表示で手動対応を促し、10秒後に自動でゲージをリセットする）
scoreboard players set #triggered penalty 1
title @a title ["",{"text":"Win数をマイナス1してください","color":"gold","bold":true},{"text":"\n"},{"text":"床崩壊！","color":"red","bold":true}]
tellraw @a [{"text":"[TNT床HP] 床のHPが0になりました。Win数をマイナス1してください","color":"red"}]
# TODO: StreamToEarnオーバーレイへ-1Winを自動で通知する処理をここに追加

# 10秒後に床HPゲージ(現在の爆発回数)を自動でリセットする
schedule function tnt_floor_break_penalty:tick/reset_after_zero 10s replace
