# 実行
```
$ cd KnowledgeGraphChallenge/Submission/Means/Binaries
$ python method_person.py [JSONresultOfQuery1] [outputfile] [rulefile]
```

JSONresultOfQuery1:   
Query1の実行結果。  
Query1は、KnowledgeGraphChallenge/Submission/Means/KnowledgeGraph/query1.txt  
実際の実行結果は、以下。  
  KnowledgeGraphChallenge/Submission/Means/Output/query1_288_result.json  
  KnowledgeGraphChallenge/Submission/Means/Output/query1_368_result.json  
  KnowledgeGraphChallenge/Submission/Means/Output/query1_all_result.json  
  
outputfile: 出力ファイル名  
  
rulefile: ルールファイル(後述)  
  
## 各バージョン
python: 3.5  
  
### pythonライブラリ
rdflib: 4.2.2  
  
## rulefileの書式
  
例  
```
{
  "graphfiles": [
    {
        "filename": "../KnowledgeGraph/merge-288.ttl",
        "format": "turtle"
    }
  ],
  "selectPersonReasonRules": [
    "rule/rule1",
    "rule/rule2"  
  ]
}
```
  
graphfiles:   
処理対象のナレッジグラフを指定する部分。  
複数のファイルをマージする必要がある場合は、このリストを増やす。  
formatの記述は、以下を参照。  
https://rdflib.readthedocs.io/en/stable/apidocs/rdflib.html#rdflib.graph.Graph.parse  
  
selectPersonReasonRules:   
Objectクラスと関係のあるナレッジグラフ中のPersonを示すルールを指定する部分。  
ここに書かれたファイルの内容をUNIONで連結したクエリを使用する。  
Objectのクラスを%%OBJCLASS%%、  
Personのインスタンスを?person、  
Objectのインスタンスを?reason、  
その関係が記述されたSituationを?situationとなるように記述。  

rule/rule1, rule/rule2を指定した状態では、以下のクエリとなる。  

```
SELECT distinct ?person ?reason ?situation {
 {
  ?situation kgc:hasPredicate kd:exist .
  ?situation kgc:where/kgc:ofWhole ?person .
  ?person a kgc:Person .
  ?situation kgc:subject ?reason .
  ?reason a/(rdfs:subClassOf*) %%OBJCLASS%% .
 }
   UNION
 {
  ?situation kgc:hasPredicate kd:have .
  ?situation kgc:subject ?person .
  ?person a kgc:Person .
  ?situation kgc:what ?reason .
  ?reason a/(rdfs:subClassOf*) %%OBJCLASS%% .
 }
}
```

