# 実行
```
$ cd KnowledgeGraphChallenge/Submission/Motivation/

# すべてのナレッジを用いた推論
$ sh Binaries/run_inference.sh

# 一部のナレッジを除いた推論
$ sh Binaries/run_inference.check.sh # 結果はOutput配下
```

# 追加した知識

  - KnowledgeGraph/additional\_situation.ttl 
    - 小説をもとに追加したシチュエーション
  - KnowledgeGraph/close\_relation.ttl 
    - 家族・友人関係の定義
  - KnowledgeGraph/human\_environment.ttl 
    - 登場人物の人間関係
  - KnowledgeGraph/motivation.ttl 
    - モチベーションのオントロジ
