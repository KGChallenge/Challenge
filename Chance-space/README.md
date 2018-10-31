# 機会チームの空間情報に関する推論

- 各場所から到達できる場所リストを表示
- 隣接地点に行けない条件を段階的に反映し、候補絞り込みの様子を表示
- 応募要項の3種類のグラフに適用

## ナレッジグラフの修正
```
KnowledgeGraph/
  SpeckledBand-mod*.ttl  # 修正したシーンを削除した「まだらの紐」ナレッジグラフ
  holeClass.ttl  # 追加: 穴に関するクラスとインスタンス定義
  holeScene.ttl  # 修正: シーン関連
  garden.ttl     # 修正: 庭インスタンス統一
```

## 実行
```
bash run_inference.sh
```
- bin/sparql で apache-jena の sparql を実行できることを想定

## 結果

4地点を開始地点として設定
```
Start places: <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen> <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott> <http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott> <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia>
```

3種類のグラフで実行

(a) merged.ttl: 完全
```
***GRAPH output/merged.ttl***
```

0. 「通れない」条件の適用無し（穴を介して繋がっている全地点が通れるとする）
```
0. No constraint
----------------
From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia
http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia
http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen
```

1. 「パターン1: 人が通れない」を適用
```
1. With constraint 1
--------------------
From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia
http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia
http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen
```

2. 「パターン1: 人が通れない」「パターン2: 穴が障害物で塞がっている」を適用
```
2. With constraints 1 and 2
---------------------------
From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott> man can go to:

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen
```

3. 「パターン1: 人が通れない」「パターン2: 穴が障害物で塞がっている」「パターン3: 穴の性質（鍵がかかっている、狭い、閉まっている）」を適用
```
3. With all constraints
------------------------
From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott> man can go to:
http://kgc.knowledge-graph.jp/data/SpeckledBand/corridor
http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott> man can go to:

From <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia> man can go to:

```

(b) merged-268.ttl: 不完全（10%）, (c) merged_288.ttl: 不完全（25%）  
→同じ結果だったので省略