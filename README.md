# Tnt_floor_break_penalty

妨害マイクラ用のデータパック。TNTで床(ゆか)が爆風に晒されるたびに床HPをボスバーで表示し、壊れたブロック数が指定したしきい値に達すると床HPが0%になる。StreamToEarnのオーバーレイと連動して自動で「-1 Win」にする想定(連携部分は未実装)。

## 仕様

- **範囲(床)の指定**: 埋め立てマイクラ用の箱作成コマンド(`umitate_gauge`と同じ2点指定方式)を流用し、床の範囲=座標を取得する
- **HP表示**: 画面上部のボスバーで%表示。100%は緑、減っていくと黄色→赤へ段階的に色が変わる(100-67%:緑 / 66-34%:黄 / 33-0%:赤)
- **カウント方式**: 範囲内で壊れたブロック数をそのままカウント。1回のTNT爆発で複数ブロック壊れれば、その分まとめて減る
- **しきい値**: 「何個壊れたらHP0になるか」はコマンドで指定可能(デフォルト50個)

## 構成

- `pack.mcmeta` — データパックのメタ情報(pack_format 48)
- `data/minecraft/tags/function/load.json` / `tick.json` — バニラのload/tickタグへの登録
- `data/tnt_floor_break_penalty/function/load/main.mcfunction` — スコアボード・ボスバーの初期化
- `data/tnt_floor_break_penalty/function/setup/set_corner1.mcfunction` — 立っている場所を1つ目の角として記録
- `data/tnt_floor_break_penalty/function/setup/set_corner2.mcfunction` — 2つ目の角を記録し、範囲確定・基準値記録・監視開始
- `data/tnt_floor_break_penalty/function/setup/calc_max_space.mcfunction` — 2点から範囲の合計マス数を計算する内部処理
- `data/tnt_floor_break_penalty/function/setup/record_baseline.mcfunction` — 範囲確定時点の空気ブロック数を基準値として記録し、破壊カウント・ゲージをリセットする内部処理
- `data/tnt_floor_break_penalty/function/setup/set_max_hits.mcfunction` — 「何個壊れたらHP0になるか」のしきい値を設定する
- `data/tnt_floor_break_penalty/function/internal/count_air.mcfunction` — 範囲内の空気ブロック数を数える共通処理(マクロ経由で座標を利用)
- `data/tnt_floor_break_penalty/function/tick/main.mcfunction` — 毎tick、範囲が設定済みなら壊れたブロック数を再計算しゲージを更新
- `data/tnt_floor_break_penalty/function/tick/update_gauge.mcfunction` — 残りHP%を計算し、ボスバーの表示・色を更新
- `data/tnt_floor_break_penalty/function/tick/on_zero.mcfunction` — HPが0になった瞬間に一度だけ発火する処理(現状はアナウンスのみ、-1Win連携はTODO)

## 使い方

1. データパックを `datapacks` フォルダに配置し、`/reload`(または再起動)
2. (任意)しきい値を変更する場合は先に実行。省略時は50個

   ```
   /function tnt_floor_break_penalty:setup/set_max_hits {count:50}
   ```

3. 床の1つ目の角のブロックの**真上に乗って**以下を実行

   ```
   /function tnt_floor_break_penalty:setup/set_corner1
   ```

4. 床の対角にあたる、もう1つの角のブロックの**真上に乗って**以下を実行

   ```
   /function tnt_floor_break_penalty:setup/set_corner2
   ```

   → この時点で範囲が確定し、現在の状態(壊れていない状態)を基準値として記録、ボスバーに「床HP: 100%」が表示され監視が始まります。

5. 以降、範囲内でTNTが爆発してブロックが壊れるたびに、壊れたブロック数に応じて床HPが自動で減っていきます。しきい値に達すると0%になり、画面にタイトル表示とアナウンスが出ます。

※ 座標はコマンド実行時のプレイヤーの足元位置から自動取得します(Y座標は「乗っているブロックの1つ上」になる分を自動補正)。範囲を変更したい場合は、あらためて `set_corner1` / `set_corner2` を実行し直せば、範囲・基準値ともに上書きされます。

## 今後の検討事項

- **StreamToEarn連携**: `tick/on_zero.mcfunction` 内にTODOとして残してある。スコアボードの値をどう外部(オーバーレイ)に渡すか(ログ出力 / RCON / WebSocket / ファイル書き出し等)は、StreamToEarn側の入力仕様を確認して決める
- **誤検知対策**: 現状は「壊れたブロック数は減らない」前提。床を修復して基準値を取り直したい場合は `set_corner1` / `set_corner2` の再実行が必要
- **複数の床(箱)の保存/切り替え**: `umitate_gauge` にある `save_box` / `load_box` のような複数範囲の保存機能は、必要になれば追加する

## 参考

- 姉妹プロジェクト: [`umitate_gauge`](../umitate_gauge)(同じ妨害マイクラ企画のデータパック。箱作成・ボスバー表示の構成の参考元)
