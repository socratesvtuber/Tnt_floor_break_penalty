# Tnt_floor_break_penalty

妨害マイクラ用のデータパック。TNTで床(ゆか)が爆風に晒されるたびに床HPをボスバーで表示し、壊れたブロック数が指定したしきい値に達すると床HPが0%になる。StreamToEarnのオーバーレイと連動して自動で「-1 Win」にする想定(連携部分は未実装)。

## 仕様

- **床(箱)の自動生成**: コマンド1つで、実行したプレイヤーの足元を基準に指定サイズ・指定ブロックの床を自動生成し、そのまま監視範囲として設定する
- **サイズ指定**: 横(x)・高さ(y)・縦(z)をコマンドの引数で指定
- **素材ブロック指定**: 床を構成するブロックの種類も引数で任意に指定可能(例: `minecraft:stone`)
- **HP表示**: 画面上部のボスバーで%表示。100%は緑、減っていくと黄色→赤へ段階的に色が変わる(100-67%:緑 / 66-34%:黄 / 33-0%:赤)
- **カウント方式**: 範囲内で壊れたブロック数をそのままカウント。1回のTNT爆発で複数ブロック壊れれば、その分まとめて減る
- **しきい値**: 「何個壊れたらHP0になるか」はコマンドで指定可能(デフォルト50個)

## 構成

- `pack.mcmeta` — データパックのメタ情報(pack_format 48)
- `data/minecraft/tags/function/load.json` / `tick.json` — バニラのload/tickタグへの登録
- `data/tnt_floor_break_penalty/function/load/main.mcfunction` — スコアボード・ボスバーの初期化
- `data/tnt_floor_break_penalty/function/setup/create_box.mcfunction` — 立っている場所を起点に、指定サイズ・指定ブロックで床を自動生成し、範囲確定・基準値記録・監視開始まで行う
- `data/tnt_floor_break_penalty/function/setup/calc_max_space.mcfunction` — 2点から範囲の合計マス数を計算する内部処理
- `data/tnt_floor_break_penalty/function/setup/record_baseline.mcfunction` — 範囲確定時点の空気ブロック数を基準値として記録し、破壊カウント・ゲージをリセットする内部処理
- `data/tnt_floor_break_penalty/function/setup/set_max_hits.mcfunction` — 「何個壊れたらHP0になるか」のしきい値を設定する
- `data/tnt_floor_break_penalty/function/internal/fill_box.mcfunction` — 起点からの相対座標・指定ブロックで実際に床を塗りつぶす内部処理
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

3. 床を生成したい場所(1つ目の角にしたいブロックの**真上**)に立って、サイズと素材ブロックを指定して実行

   ```
   /function tnt_floor_break_penalty:setup/create_box {width:10, height:1, depth:10, block:"minecraft:stone"}
   ```

   - `width` = 横(x方向)のマス数 / `height` = 高さ(y方向)のマス数 / `depth` = 縦(z方向)のマス数
   - `block` = 床の素材ブロック(例: `"minecraft:stone"` `"minecraft:oak_planks"` など、ブロックステート付きも指定可能)

   → 実行したプレイヤーの足元を起点に、指定サイズ・指定ブロックで床が自動生成されます。同時に範囲が確定し、生成直後(壊れていない状態)を基準値として記録、ボスバーに「床HP: 100%」が表示され監視が始まります。

4. 以降、範囲内でTNTが爆発してブロックが壊れるたびに、壊れたブロック数に応じて床HPが自動で減っていきます。しきい値に達すると0%になり、画面にタイトル表示とアナウンスが出ます。

※ 座標はコマンド実行時のプレイヤーの足元位置から自動取得します(Y座標は「乗っているブロックの1つ上」になる分を自動補正)。作り直したい場合は、別の場所であらためて `create_box` を実行すれば、範囲・基準値ともに新しい床のものに上書きされます(古い床のブロックはそのまま残るので、不要なら手動で削除してください)。

## 今後の検討事項

- **StreamToEarn連携**: `tick/on_zero.mcfunction` 内にTODOとして残してある。スコアボードの値をどう外部(オーバーレイ)に渡すか(ログ出力 / RCON / WebSocket / ファイル書き出し等)は、StreamToEarn側の入力仕様を確認して決める
- **誤検知対策**: 現状は「壊れたブロック数は減らない」前提。床を修復して基準値を取り直したい場合は `create_box` の再実行が必要(同じ場所・同じサイズ・同じブロックで実行すれば、床を復元しつつ基準値もリセットできる)
- **複数の床(箱)の保存/切り替え**: `umitate_gauge` にある `save_box` / `load_box` のような複数範囲の保存機能は、必要になれば追加する

## 参考

- 姉妹プロジェクト: [`umitate_gauge`](../umitate_gauge)(同じ妨害マイクラ企画のデータパック。箱作成・ボスバー表示の構成の参考元)
