
DIR_PATH=`dirname $0`

find $DIR_PATH/../KnowledgeGraph $DIR_PATH/../../KnowledgeGraph -name "*.ttl" | grep -v -E '368|288|merged|InferenceMotivation.ttl'
find $DIR_PATH/../KnowledgeGraph $DIR_PATH/../../KnowledgeGraph -name "*.ttl" | grep -v -E '368|288|merged|InferenceMotivation.ttl' | xargs -L 1  cat | grep '^@prefix'    | sort | uniq > $DIR_PATH/../KnowledgeGraph/merged.ttl
find $DIR_PATH/../KnowledgeGraph $DIR_PATH/../../KnowledgeGraph -name "*.ttl" | grep -v -E '368|288|merged|InferenceMotivation.ttl' | xargs -L 1  cat | grep -v '^@prefix' | uniq >> $DIR_PATH/../KnowledgeGraph/merged.ttl

echo ''
find $DIR_PATH/../KnowledgeGraph $DIR_PATH/../../KnowledgeGraph -name "*.ttl" | grep -v -E '288|SpeckledBand\.ttl|merged|InferenceMotivation.ttl'
find $DIR_PATH/../KnowledgeGraph $DIR_PATH/../../KnowledgeGraph -name "*.ttl" | grep -v -E '288|SpeckledBand\.ttl|merged|InferenceMotivation.ttl' | xargs -L 1  cat | grep '^@prefix'    | sort | uniq > $DIR_PATH/../KnowledgeGraph/merged-368.ttl
find $DIR_PATH/../KnowledgeGraph $DIR_PATH/../../KnowledgeGraph -name "*.ttl" | grep -v -E '288|SpeckledBand\.ttl|merged|InferenceMotivation.ttl' | xargs -L 1  cat | grep -v '^@prefix' | uniq >> $DIR_PATH/../KnowledgeGraph/merged-368.ttl

echo ''
find $DIR_PATH/../KnowledgeGraph $DIR_PATH/../../KnowledgeGraph -name "*.ttl" | grep -v -E '368|SpeckledBand\.ttl|merged|InferenceMotivation.ttl'
find $DIR_PATH/../KnowledgeGraph $DIR_PATH/../../KnowledgeGraph -name "*.ttl" | grep -v -E '368|SpeckledBand\.ttl|merged|InferenceMotivation.ttl' | xargs -L 1  cat | grep '^@prefix'    | sort | uniq > $DIR_PATH/../KnowledgeGraph/merged-288.ttl
find $DIR_PATH/../KnowledgeGraph $DIR_PATH/../../KnowledgeGraph -name "*.ttl" | grep -v -E '368|SpeckledBand\.ttl|merged|InferenceMotivation.ttl' | xargs -L 1  cat | grep -v '^@prefix' | uniq >> $DIR_PATH/../KnowledgeGraph/merged-288.ttl


