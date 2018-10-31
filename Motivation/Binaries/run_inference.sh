DIR_PATH=`dirname $0`

file="merged.ttl"
echo "sh $DIR_PATH/shacl-1.1.0/bin/shaclinfer.sh -datafile $DIR_PATH/../KnowledgeGraph/$file -shapesfile $DIR_PATH/../KnowledgeGraph/InferenceMotivation.ttl > $DIR_PATH/output/${file%.ttl}.output.ttl"
sh $DIR_PATH/shacl-1.1.0/bin/shaclinfer.sh -datafile $DIR_PATH/../KnowledgeGraph/$file -shapesfile $DIR_PATH/../KnowledgeGraph/InferenceMotivation.ttl  # > $DIR_PATH/output/${file%.ttl}.output.ttl
