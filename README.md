# Tnt_floor_break_penalty

妨害マイクラ用のデータパック。TNTでゆか(床)が爆破されたことを検知し、自動で「-1 Win」になるようにする。StreamToEarnのオーバーレイと連動させる想定。

## 現状

まだ設計段階。ディレクトリ構成のみ作成済み(中身は未実装)。

## 構成(予定)

- `pack.mcmeta` — データパックのメタ情報(pack_format 48)
- `data/tnt_floor_break_penalty/function/load/main.mcfunction` — 初期化処理(未実装)
- `data/tnt_floor_break_penalty/function/tick/main.mcfunction` — 毎tick処理(未実装)
- `data/minecraft/tags/function/load.json` / `tick.json` — バニラのload/tickタグへの登録

## 検討中の論点(次回チャットで壁打ち予定)

- 「TNTで床が壊れた」の検知方法
  - advancement(`minecraft:tnt_lit`系トリガー)を使うか、`fill`/`clone`によるブロック監視(umitate_gaugeと同様の方式)にするか
  - 「床」の範囲をどう定義するか(座標指定 / 特定ブロックタグ指定など)
- StreamToEarnオーバーレイとの連携方法
  - スコアボードの値をどう外部(オーバーレイ)に渡すか(ログ出力 / RCON / WebSocket / ファイル書き出し等)
  - 「-1 Win」の反映先はStreamToEarn側のAPI・入力仕様に依存するため要確認
- 誤検知防止(プレイヤーが自分で置いたTNT以外での誤爆判定、複数回連続爆破時の多重減点など)

## 参考

- 姉妹プロジェクト: [`umitate_gauge`](../umitate_gauge)(同じ妨害マイクラ企画のデータパック。構成・命名規則の参考)
