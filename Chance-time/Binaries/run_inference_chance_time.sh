#!/usr/bin/bash
DIR_PATH=`dirname $0`

# 犯行時刻の居場所の表示をする
# sparql コマンドと同じディレクトリに置くか、sparql コマンドの保存先に合わせて書き換えてから実行
# $1 に推論に使いたい KG (.ttl)を指定して実行

$DIR_PATH/apache-jena-3.9.0/bin/sparql --data=$1 --results=CSV --query $DIR_PATH/../KnowledgeGraph/chance_time_query
