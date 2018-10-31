#!/usr/bin/bash

# 空間情報の推論
# 各場所から到達できる場所リストを表示
# 隣接地点に行けない条件を段階的に反映し、候補絞り込みの様子を表示
# 応募要項の3種類のグラフに適用

list_start_place=("<http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Helen>" "<http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Roylott>" "<http://kgc.knowledge-graph.jp/data/SpeckledBand/garden_of_Roylott>" "<http://kgc.knowledge-graph.jp/data/SpeckledBand/bedroom_of_Julia>")  #Helen, Roylott, Roma, Julia

list_graph_suffix=("" "-368" "-288")

workdir=$(cd $(dirname $0); pwd)
cd $workdir
# dir_kgsb="../../KnowledgeGraph/"
dir_kgadd="KnowledgeGraph/"
dir_query="KnowledgeGraph/"
dir_output="Output/"

sparql_path(){
    echo "select distinct ?t where {$1 <http://kgchallenge.github.io/data/#haveOpenHoleTo>+ ?t . filter(?t != $1)}"
}

run_search_path(){
    Binaries/apache-jena-3.9.0/bin/sparql --data=$1 --query $2 > $3
    for s in "${list_start_place[@]}"
    do
	echo "From ${s} man can go to:"
	Binaries/apache-jena-3.9.0/bin/sparql --data=$3 --results=CSV --query <(sparql_path $s) | sed '1d'
	echo
    done
}

run_on_a_kg(){  # option: graph name suffix
    # Merge KG
    merged_kg="${dir_output}merged${1}.ttl"
    cat ${dir_kgadd}SpeckledBand_mod${1}.ttl ${dir_kgadd}garden.ttl ${dir_kgadd}holeClass.ttl ${dir_kgadd}holeScene.ttl > ${merged_kg}
    echo "***GRAPH ${merged_kg}***"

    echo "0. No constraint"
    echo "----------------"
    run_search_path ${merged_kg} ${dir_query}query_constract_neighbor_noconst.txt ${dir_output}openhole_noconst${1}.ttl
    
    echo "1. With constraint 1"
    echo "--------------------"
    run_search_path ${merged_kg} ${dir_query}query_constract_neighbor_const1.txt ${dir_output}openhole_const1${1}.ttl

    echo "2. With constraints 1 and 2"
    echo "---------------------------"
    run_search_path ${merged_kg} ${dir_query}query_constract_neighbor_const1and2.txt ${dir_output}openhole_const1and2${1}.ttl
    
    echo "3. With all constraints"
    echo "------------------------"
    run_search_path ${merged_kg} ${dir_query}query_constract_neighbor.txt ${dir_output}openhole${1}.ttl
}

# =====
# Run
# =====

echo "Start places: "${list_start_place[@]}
echo

for suffix in "${list_graph_suffix[@]}"
do
    run_on_a_kg ${suffix}
done

