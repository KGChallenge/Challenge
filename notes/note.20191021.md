# 人工知能学会 SWO研究会ワークショップ「ナレッジグラフ推論チャレンジ2019技術勉強会＆応募相談会」：まだ間に合う！応募に向けた実践講座
## 昨年度の応募作品(上小田中411チーム)の実行例など
- こちらは[推論チャレンジ2019技術勉強会](https://kgrc2019ws2.peatix.com/)に関連する資料です   
\* 実行などは自己責任でお願いします．


---
# 0. この資料の大まかな内容
- 実行環境の作成
- 実行
- 今年度のKG向けに多少の改善
  - 今回だけでは完全には対応しません．

--- 
# 1.1. 実行環境の作成 (以降はbashでの実行)
- docker imageのビルド
```
$ cd $KGCC_HOME
$ git clone https://github.com/KGChallenge/Challenge.git
$ cd Challenge/dockerfiles
$ docker build -t image_name:tag . # image_name, tag は適宜変更可能 
$                                  # (変更した場合は，以下のコマンドもそれに合わせる)
```

- dockerコンテナ上にホストのディレクトリをマウントしてコンテナを起動

```shell
$ cd $KGCC_HOME
$ docker run --rm -it -v `pwd`:/root/work image_name:tag /bin/bash
```

\* /root にマウントすると，.bashrcが消えて，環境変数がうまく設定されないので注意 

---
# 1.1'. 実行環境の作成 (Dockerを使った別の方法)
> こちらの方がわかりやすいかもしれません．
- docker コンテナを作成
```shell
$ docker run -itd -w /root/work --name container_name image_name:tag  # container_name は適宜変更可能
```

- docker コンテナにファイルをコピーして実行
```shell
$ cd $KGCC_HOME
$ docker cp Challenge container_name:/root/work/
$ docker exec -it container_name /bin/bash       # container_name に入る
```
\* エディタは含まれていませんので，`apt`などでインストールしてください．

---
# 1.2. 昨年度応募作品(上小田中411)の実行
- 実行
```shell
# cd ~/work/Challenge/Motivation/Binaries         # 以下のコマンドは container_name の中で実行されている
# bash run_inference.sh                          # 殺人動機を推論

# cd ~/work/Challenge/Chance-time/Binaries
# bash run_inference_chance_time.sh \
         ../../KnowledgeGraph/SpeckledBand.ttl   # 事件当夜，各々が居た場所を推論

# cd ~/work/Challenge/Chance-space
# bash run_inference.sh \
           KnowledgeGraph/SpeckledBand_mod.ttl   # 移動できた場所を推論

# cd ~/work/Challenge/Means/Binaries
# sparql --data ../KnowledgeGraph/merge-all.ttl \
         --query ../KnowledgeGraph/query1.txt    # 殺害された方法を推論
# python3 method_person.py \
           ../Output/query1_all_result.json \
           out.txt \
           rule-all.conf                         # 推論された殺害方法を実行できた人物を推論
# cat out.txt                                    # 推論結果を表示 
```

\* 詳細は[GitHub](https://github.com/KGChallenge/Challenge.git)を確認してください．

---

# 2.0. 2019年度に追加されたKGへの対応

---
# 2.1. 事件当夜の各々の居場所を取得するSPARQL
- 事件当夜をハードコーディングしているので，他のKGに対して推論できない．
```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX kgc: <http://kgc.knowledge-graph.jp/ontology/kgc.owl#>
PREFIX kd: <http://kgc.knowledge-graph.jp/data/SpeckledBand/>
SELECT DISTINCT ?id ?source ?predicate ?subj ?where
WHERE{
  BIND(kd:67 as ?event)                  # ID67のシーンをジュリアが殺害された日として指定
                                         # ★ このハードコーディングを改善したい
  
  ?event kgc:when ?crime_time.           # 事件当夜の時間を取得

  ?id kgc:when ?crime_time;              # 事件当夜と同じ時間に起きたシーンの一覧を取得
      kgc:source ?source;
      kgc:hasPredicate ?predicate;
      kgc:subject ?subj;
      kgc:where ?where.

  ?subj a kgc:Person.                    # 事件当夜と同じ時刻に起きたシーンのうち，
                                         # 主語がkgc:Personクラスのインスタンスであるものを取得 

  FILTER(LANG(?source) = 'ja').        
  MINUS{
    ?event kgc:then+ ?id.                # ID67からkgc:thenで繋がっているシーンは削除
  }
}
```

---
# 2.2. まずはID67について見てみる
- どうやって？

---
# 2.2.1. 公式ページの[初めての方へ](https://challenge.knowledge-graph.jp/reference.html)が参考になる
- 3.ナレッジグラフを使いたい
  - 3-4. ナレッジグラフ推論チャレンジのサンプルSPARQLクエリ集
    - [指定した場面（例：｢まらだのひも」の場面36）の内容（トリプル一覧）を取得する](https://github.com/KnowledgeGraphJapan/Challenge/blob/master/rdf/2019/SPARQLsample.md#%E6%8C%87%E5%AE%9A%E3%81%97%E3%81%9F%E5%A0%B4%E9%9D%A2%E4%BE%8B%E3%81%BE%E3%82%89%E3%81%A0%E3%81%AE%E3%81%B2%E3%82%82%E3%81%AE%E5%A0%B4%E9%9D%A236%E3%81%AE%E5%86%85%E5%AE%B9%E3%83%88%E3%83%AA%E3%83%97%E3%83%AB%E4%B8%80%E8%A6%A7%E3%82%92%E5%8F%96%E5%BE%97%E3%81%99%E3%82%8B)

---
# 2.2.2. サンプルを動かしてみる．
```sparql
# query1.rq
select ?p ?o
{
  <http://kgc.knowledge-graph.jp/data/SpeckledBand/36> ?p ?o .
}
```

- 実行結果 (`query1.rq`は作成してください)
```
$ cd ~/work/Challenge/
$ sparql --data KnowledgeGraph/SpeckledBand.ttl --query query1.rq
------------------------------------------------------------------------------------------------------------------------------------------
| p                                                             | o                                                                      |
==========================================================================================================================================
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#time>         | "1881-04-01T10:00:00"^^<http://www.w3.org/2001/XMLSchema#DateTime>     |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#then>         | <http://kgc.knowledge-graph.jp/data/SpeckledBand/37>                   |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#subject>      | <http://kgc.knowledge-graph.jp/data/SpeckledBand/Julia>                |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#hasPredicate> | <http://kgc.knowledge-graph.jp/data/SpeckledBand/meet>                 |
| <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>             | <http://kgc.knowledge-graph.jp/ontology/kgc.owl#Situation>             |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#whom>         | <http://kgc.knowledge-graph.jp/data/SpeckledBand/lieutenant_commander> |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#when>         | <http://kgc.knowledge-graph.jp/data/SpeckledBand/2_years_ago>          |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#source>       | "ジュリアは２年前に海軍少佐とハロウで知り合う"@ja                                            |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#source>       | "Julia gets acquainted with Major Navy two years ago at Harrow"@en     |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#where>        | <http://kgc.knowledge-graph.jp/data/SpeckledBand/Harrow>               |
------------------------------------------------------------------------------------------------------------------------------------------
```

---
# 2.2.3. そもそも，どういう構造になっている？

---
# 2.2.3'. 公式ページの[初めての方へ](https://challenge.knowledge-graph.jp/reference.html)が参考になる
- 1.ナレッジグラフ推論チャレンジとは
  - 1-2.[第一回報告＆第二回説明スライド](https://www.slideshare.net/KnowledgeGraph/2018-148835458#4)
    - p4-6

---
# 2.2.4. ID67について調べてみる．
```
# query2.rq
select ?p ?o
{
  <http://kgc.knowledge-graph.jp/data/SpeckledBand/67> ?p ?o .
}
```

- 結果 (`death_day_of_xxx`で`xxx`が亡くなった日が指定されていそう．)
```
$ cd ~/work/Challenge/
$ sparql --data KnowledgeGraph/SpeckledBand.ttl --query query2.rq
----------------------------------------------------------------------------------------------------------------------------------------
| p                                                             | o                                                                    |
========================================================================================================================================
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#time>         | "1881-12-02T00:00:00"^^<http://www.w3.org/2001/XMLSchema#DateTime>   |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#then>         | <http://kgc.knowledge-graph.jp/data/SpeckledBand/68>                 |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#subject>      | <http://kgc.knowledge-graph.jp/data/SpeckledBand/Helen>              |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#hasPredicate> | <http://kgc.knowledge-graph.jp/data/SpeckledBand/hear>               |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#what>         | <http://kgc.knowledge-graph.jp/data/SpeckledBand/voice_of_Julia>     |
| <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>             | <http://kgc.knowledge-graph.jp/ontology/kgc.owl#Situation>           |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#when>         | <http://kgc.knowledge-graph.jp/data/SpeckledBand/death_day_of_Julia> |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#source>       | "Julia's voice was heard on death day of Julia"@en                   |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#source>       | "事件当夜，ジュリアの声が聞こえた"@ja                                                |
| <http://kgc.knowledge-graph.jp/ontology/kgc.owl#where>        | <http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen>   |
----------------------------------------------------------------------------------------------------------------------------------------
```

---

# 2.3. 2019年のデータからdeath_day_of_...を持つSceneを取り出すには？ 
## 公式ページの[初めての方へ](https://challenge.knowledge-graph.jp/reference.html)を参照
- 3.ナレッジグラフを使いたい
  - 3-4. ナレッジグラフ推論チャレンジのサンプルSPARQLクエリ集
    - [場面の一覧を取得する](https://github.com/KnowledgeGraphJapan/Challenge/blob/master/rdf/2019/SPARQLsample.md#%E5%A0%B4%E9%9D%A2%E3%81%AE%E4%B8%80%E8%A6%A7%E3%82%92%E5%8F%96%E5%BE%97%E3%81%99%E3%82%8B)


---
# 2.3.1. 場面の一覧を取得するSPARQLは...
```
# query3.rq
PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX kgc: <http://kgc.knowledge-graph.jp/ontology/kgc.owl#>

SELECT ?s 
WHERE{
  ?s rdf:type kgc:Situation .
}
```
- 結果

```shell
$ sparql --data KnowledgeGraph/SpeckledBand.ttl --query query3.rq
----------------------------------------------------------
| s                                                      |
==========================================================
| <http://kgc.knowledge-graph.jp/data/SpeckledBand/279>  |
| <http://kgc.knowledge-graph.jp/data/SpeckledBand/7>    |
...
| <http://kgc.knowledge-graph.jp/data/SpeckledBand/T186> |
----------------------------------------------------------
```

---
# 2.3.2. KG上でジュリアが死んだ日に起きたシーンの一覧を得るには
```sparql
# query4.rq         
PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX kgc: <http://kgc.knowledge-graph.jp/ontology/kgc.owl#>
PREFIX sp:  <http://kgc.knowledge-graph.jp/data/SpeckledBand/>

SELECT ?s ?sc
WHERE{
  ?s rdf:type kgc:Situation ;
     kgc:when sp:death_day_of_Julia ;               # sp:death_day_of_Julia と同時刻に起きたシーンを選択
     kgc:source  ?sc.
  FILTER(lang(?sc)="ja")                            # 言語タグが日本語のものだけ選択
}
```

- 結果
```shell
sparql --data KnowledgeGraph/SpeckledBand.ttl --query query4.rq                                                                    
---------------------------------------------
| s      | sc                               |
=============================================
| sp:82  | "事件当夜，ヘレンはジュリアに行った"@ja           |
...
```

---
# 2.3.3. KG上で誰かが死んだ日に起きたシーンの一覧を得るには？
```
# query5.rq
PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX kgc: <http://kgc.knowledge-graph.jp/ontology/kgc.owl#>
PREFIX sp:  <http://kgc.knowledge-graph.jp/data/SpeckledBand/>

SELECT ?s ?time ?source
WHERE{
  ?s rdf:type kgc:Situation ;
     kgc:when ?time .
  FILTER( CONTAINS(STR(?time), "death_day_of_")   # ?timeに対応するURIに"death_day_of_"が含まれるもののみを選択 )

  ?s kgc:when ?time ;
     kgc:source ?source .
  FILTER(LANG(?source)='ja')
}
```
- 実行コマンド
```
$ sparql --data KnowledgeGraph/SpeckledBand.ttl --query query5.rq
```
\* 他の小説の*.ttlファイルに対して実行して，動作確認可能

---
# 2.4. どうやら，今年度はdeath_day_of_...はないらしい？(イベント開催当時)
> Option
- お気づきの点はこの[リポジトリ](https://github.com/KnowledgeGraphJapan/KGRC-RDF)などにissueを投げていただけると解決されるかもしれません．
  - ex) `今年度の追加されたデータには昨年度はあった「death_day_of_julia」のような情報はないのでしょうか ＞＜？`

##### データの拡張で対策
- 公式ページの「応募要領」に
___ナレッジグラフを独自に拡張することも可能___
とあるので，自らdeath_day_of_...を追加しても良いかもしれません．

\* 追加の際は，一定の基準を設けて客観的な判断のもと付与したほうが説得力が増すと思われます．

---
# 2.5. 他のアプローチの提案 
## `hasPredicate`が`die`や`kill`になっているシーンを探すことでも，誰かが亡くなったシーンを推論することができるかもしれません． 

> Note: 同一事件では誰も殺害されていないので，誰かが殺害された日が事件発生日であるという仮定が間違っています．

&copy; FUJITSU LABORATORIES LTD