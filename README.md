# Tnt_floor_break_penalty

妨害マイクラ用のデータパック。範囲内でTNTが爆発するたびに床HPをボスバーで表示し、爆発回数が指定したしきい値に達すると床HPが0%になる。あわせて、床を除いた内部空間にどれだけブロックが積まれているか(埋め立て度)を示す「ブロックゲージ」も表示できる。StreamToEarnのオーバーレイと連動して自動で「-1 Win」にする想定(連携部分は未実装)。

床HPの判定はTNTエンティティの消滅(=起爆)そのものを検知する方式のため、`/gamerule mobGriefing false`でブロック破壊が無効化されたサーバーでも動作する。

## 仕様

- **床(箱)の自動生成**: コマンド1つで、実行したプレイヤーの足元を基準に指定サイズ・指定ブロックの床を自動生成し、そのまま監視範囲として設定する
- **サイズ指定**: 横(x)・高さ(y)・縦(z)をコマンドの引数で指定
- **素材ブロック指定**: 床を構成するブロックの種類も引数で任意に指定可能(例: `minecraft:stone`)
- **既存の埋め立て用ボックスの自動検出**: 既に埋め立て用ボックス(4方向を壁で囲まれた箱)の内部にプレイヤーが立っている場合、コマンド1つで壁の座標を自動探索し、その範囲をブロックゲージ・床HPゲージ両方の監視範囲としてまとめてセットアップできる(新規に床を生成する`create_box`とは別の入口)
- **床HPゲージ**: 画面上部のボスバーで%表示。100%は緑、減っていくと黄色→赤へ段階的に色が変わる(100-67%:緑 / 66-34%:黄 / 33-0%:赤)
- **カウント方式**: 範囲(箱全体)内で起爆したTNTの数をそのままカウント。ブロック破壊の有無を見ていないため、`mobGriefing`の設定に関係なく動作する
- **しきい値**: 「何回爆発したらHP0になるか」はコマンドで指定可能(デフォルト50回)
- **ブロックゲージ**: 床HPゲージとは別に、床を除いた内部空間(床の1つ上〜天井)にどれだけブロックが積まれているか(埋め立て度)をもう1本のボスバーで表示。床自体は「埋まっているブロック」としてカウントしない。高さ1の箱(内部空間が無い)の場合は「対象外」表示になる
- **表示ON/OFF**: 床HPゲージ・ブロックゲージそれぞれ、独立してコマンドで表示/非表示を切り替え可能

## 構成

- `pack.mcmeta` — データパックのメタ情報(pack_format 48)
- `data/minecraft/tags/function/load.json` / `tick.json` — バニラのload/tickタグへの登録
- `data/tnt_floor_break_penalty/function/load/main.mcfunction` — スコアボード・ボスバーの初期化
- `data/tnt_floor_break_penalty/function/setup/create_box.mcfunction` — 立っている場所を起点に、指定サイズ・指定ブロックで床を自動生成し、範囲確定・基準値記録・監視開始まで行う
- `data/tnt_floor_break_penalty/function/setup/detect_box.mcfunction` — 既存の埋め立て用ボックスの内部から東西南北へ壁を自動探索して範囲を検出し、範囲確定・基準値記録・監視開始まで行う
- `data/tnt_floor_break_penalty/function/setup/calc_max_space.mcfunction` — 2点から範囲の合計マス数を計算し、「内部空間(床を除いた上部、ブロックゲージ用)」の範囲・容量と、「箱全体(TNT検知用)」のセレクタ範囲を算出して保存する内部処理
- `data/tnt_floor_break_penalty/function/setup/record_baseline.mcfunction` — TNT追跡タグ・爆発回数カウントをリセットし、両ゲージを初期表示にする内部処理
- `data/tnt_floor_break_penalty/function/setup/set_max_hits.mcfunction` — 「何回爆発したらHP0になるか」のしきい値を設定する
- `data/tnt_floor_break_penalty/function/setup/hp_gauge_show.mcfunction` / `hp_gauge_hide.mcfunction` — 床HPゲージの表示ON/OFF
- `data/tnt_floor_break_penalty/function/setup/block_gauge_show.mcfunction` / `block_gauge_hide.mcfunction` — ブロックゲージの表示ON/OFF
- `data/tnt_floor_break_penalty/function/internal/fill_box.mcfunction` — 起点からの相対座標・指定ブロックで実際に床を塗りつぶす内部処理
- `data/tnt_floor_break_penalty/function/internal/count_air.mcfunction` — 範囲内の空気ブロック数を数える共通処理(マクロ経由で座標を利用)
- `data/tnt_floor_break_penalty/function/internal/probe.mcfunction` / `probe_advance.mcfunction` / `probe_hit.mcfunction` / `probe_timeout.mcfunction` — `detect_box`が使う、1方向へ1マスずつ進みながら壁(空気以外のブロック)を探す再帰処理一式
- `data/tnt_floor_break_penalty/function/tick/main.mcfunction` — 毎tick、範囲が設定済みならTNT爆発回数の検知と内部空間の空気ブロック数の再計算を行い、両ゲージを更新
- `data/tnt_floor_break_penalty/function/tick/track_tnt.mcfunction` — 範囲内のTNTエンティティにタグを付けて追跡し、消滅(=爆発)した数を爆発回数へ積算する
- `data/tnt_floor_break_penalty/function/tick/update_gauge.mcfunction` — 残りHP%を計算し、床HPゲージの表示・色を更新
- `data/tnt_floor_break_penalty/function/tick/update_block_gauge.mcfunction` — 内部空間の埋め立て度を計算し、ブロックゲージの表示を更新
- `data/tnt_floor_break_penalty/function/tick/update_block_gauge_na.mcfunction` — 内部空間が無い(高さ1の)箱の場合に、ブロックゲージを「対象外」表示にする
- `data/tnt_floor_break_penalty/function/tick/on_zero.mcfunction` — HPが0になった瞬間に一度だけ発火する処理(現状はアナウンスのみ、-1Win連携はTODO)

## 使い方

1. データパックを `datapacks` フォルダに配置し、`/reload`(または再起動)
2. (任意)しきい値を変更する場合は先に実行。省略時は50回

   ```
   /function tnt_floor_break_penalty:setup/set_max_hits {count:50}
   ```

3. 床を生成したい場所(1つ目の角にしたいブロックの**真上**)に立って、サイズと素材ブロックを指定して実行

   ```
   /function tnt_floor_break_penalty:setup/create_box {width:10, height:1, depth:10, block:"minecraft:stone"}
   ```

   - `width` = 横(x方向)のマス数 / `height` = 高さ(y方向)のマス数 / `depth` = 縦(z方向)のマス数
   - `block` = 床の素材ブロック(例: `"minecraft:stone"` `"minecraft:oak_planks"` など、ブロックステート付きも指定可能)

   → 実行したプレイヤーの足元を起点に、指定サイズ・指定ブロックで床が自動生成されます。同時に範囲が確定し、ボスバーに「床HP: 100%」が表示され監視が始まります。

4. 以降、範囲内でTNTが爆発するたびに爆発回数に応じて床HPゲージが自動で更新されます(ブロックが実際に壊れるかどうかは関係ありません)。しきい値に達すると0%になり、画面にタイトル表示とアナウンスが出ます。ブロックゲージは、床を除いた内部空間にブロックが積まれるたびに更新されます。

### 既存の埋め立て用ボックスを使う場合(create_boxの代わり)

すでに壁付きの埋め立て用ボックスが建ててあり、その中にプレイヤーが立っている場合は、`create_box`の代わりに以下を実行すると、壁の座標を自動探索して範囲を検出し、ブロックゲージ・床HPゲージの両方を1コマンドでセットアップできます。

```
/function tnt_floor_break_penalty:setup/detect_box {height:5}
```

- 探索は、実行したプレイヤーの足元の高さで東西南北へ1マスずつ進み、最初に「空気以外のブロック」に当たった場所を壁とみなす(既定では最大128マスまで探索。それでも壁が見つからない場合は失敗としてメッセージを表示し中断する)
- 天井が無い(上部が開放された)箱を想定しているため、高さ(Y方向)だけは自動検出できず、`height`引数で明示的に指定する必要がある(y1=足元の高さ、y2=足元+height-1)
- 検出後は`create_box`と同様、その場でブロックゲージ・床HPゲージの両方が「現在の状態」を基準値として監視を開始する

### ゲージの表示ON/OFF

必要に応じて、床HPゲージ・ブロックゲージをそれぞれ独立して表示/非表示にできます(デフォルトは両方表示)。

```
/function tnt_floor_break_penalty:setup/hp_gauge_hide
/function tnt_floor_break_penalty:setup/hp_gauge_show
/function tnt_floor_break_penalty:setup/block_gauge_hide
/function tnt_floor_break_penalty:setup/block_gauge_show
```

※ 座標はコマンド実行時のプレイヤーの足元位置から自動取得します(Y座標は「乗っているブロックの1つ上」になる分を自動補正)。作り直したい場合は、別の場所であらためて `create_box` を実行すれば、範囲・基準値ともに新しい床のものに上書きされます(古い床のブロックはそのまま残るので、不要なら手動で削除してください)。

## うまく動かないときの確認事項

- **TNTを爆発させても床HPが反応しない**: 床HPはTNTエンティティ(`minecraft:tnt`)の消滅を検知する方式のため、`mobGriefing`の設定には影響されません。反応しない場合は、TNTが監視範囲(箱全体の座標。`create_box`/`detect_box`実行時のtellrawに表示される)の中で起爆しているか確認してください
- **意図しないボスバーが一緒に表示される**: `umitate_gauge` など他のデータパックが同じワールドに入っている場合、そちら側が作ったボスバー(例: `minecraft:fill_gauge`)が一緒に表示されることがあります。このデータパックからは制御できないため、非表示にしたい場合は該当データパック側のIDを指定して個別に実行してください(例: `/bossbar set minecraft:fill_gauge players`)

## 今後の検討事項

- **StreamToEarn連携**: `tick/on_zero.mcfunction` 内にTODOとして残してある。スコアボードの値をどう外部(オーバーレイ)に渡すか(ログ出力 / RCON / WebSocket / ファイル書き出し等)は、StreamToEarn側の入力仕様を確認して決める
- **TNTの誤検知**: 爆発せず範囲外へ転がり出たTNTも、まれに「爆発した」とカウントされる可能性がある(範囲内でのTNT数の減少を爆発とみなす簡易的な方式のため)
- **やり直し**: 床を作り直して爆発回数をリセットしたい場合は `create_box` または `detect_box` の再実行が必要
- **複数の床(箱)の保存/切り替え**: `umitate_gauge` にある `save_box` / `load_box` のような複数範囲の保存機能は、必要になれば追加する

## 参考

- 姉妹プロジェクト: [`umitate_gauge`](../umitate_gauge)(同じ妨害マイクラ企画のデータパック。箱作成・ボスバー表示の構成の参考元)
