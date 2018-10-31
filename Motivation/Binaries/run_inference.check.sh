DIR_PATH=`dirname $0`

# ls $DIR_PATH/../KnowledgeGraph/merged*.ttl | sed -e 's/\.ttl//g' | xargs -L 1 -I{} -t sh -c "sh $DIR_PATH/../../../binaries/shacl-1.1.0/bin/shaclinfer.sh -datafile {}.ttl -shapesfile $DIR_PATH/../shacl_rule/InferenceMotivation.ttl > {}.output.ttl"

for file in `ls $DIR_PATH/../KnowledgeGraph/merged*.ttl | xargs -L 1 -I{} basename {}`
do 
  echo "[RUN]: sh $DIR_PATH/shacl-1.1.0/bin/shaclinfer.sh -datafile $DIR_PATH/../KnowledgeGraph/$file -shapesfile $DIR_PATH/../KnowledgeGraph/InferenceMotivation.ttl > $DIR_PATH/output/${file%.ttl}.output.ttl"
  sh $DIR_PATH/shacl-1.1.0/bin/shaclinfer.sh -datafile $DIR_PATH/../KnowledgeGraph/$file -shapesfile $DIR_PATH/../KnowledgeGraph/InferenceMotivation.ttl > $DIR_PATH/../Output/${file%.ttl}.output.ttl
  echo ""
done
