import json
from rdflib.graph import Graph
from rdflib import URIRef, Literal, BNode
from rdflib import RDF, RDFS
import argparse

## 殺害方法の全サブクラスを取得
def getSubClassKilling(g, killing):
    return(g.query("""
SELECT distinct ?killing {
  ?killing rdfs:subClassOf* <"""+killing+"""> .
}
"""))

## 殺害方法の犯罪供用物クラスを取得
def getOffensiveWeaponClass(g, killing):
    return(g.query("""
SELECT distinct ?class {
  """+killing+""" rdfs:subClassOf ?hasOWRestriction .
  ?hasOWRestriction a owl:Restriction;
    owl:onProperty <http://kgchallenge.github.io/ontology/hasOffensiveWeapon> ;
    owl:someValuesFrom ?class .
}
"""))

## 殺害方法の犯罪供用物クラスの関連物を取得
def getRelatedObjectClass(g, owclass):
    return(g.query("""
SELECT distinct ?class {
  """+owclass+""" (^rdfs:subClassOf*)/rdfs:subClassOf ?hasOWRestriction .
  ?hasOWRestriction a owl:Restriction;
    owl:onProperty <http://kgchallenge.github.io/ontology/hasRelatedObject> ;
    owl:someValuesFrom ?class .
}
"""))

## そのオブジェクトを持つ人間の導出
def selectPerson_Reason(g, objectclass, rulelist):
    return(g.query(("""
SELECT distinct ?person ?reason ?situation {""" + " UNION ".join(rulelist) + """
}
""").replace("%%OBJCLASS%%",objectclass)))

## 犯罪供用物とその関連物リストの組から、その犯罪供用物を持つ人間のリストを導出
def getResultList(g, ow, rolist, rulelist):
    tmplist=[ [res,"weapon"] for res in selectPerson_Reason(g, ow, rulelist) ] + [ [res,"related"] for ro in rolist for res in selectPerson_Reason(g, ro, rulelist) ]
    return( [ [
        tmp[0][0].n3(),
        tmp[0][1].n3(),
        tmp[0][2].n3(),
        tmp[1]
    ] for tmp in tmplist ])

## 一つのResultに対するRDFを生成
def getResultGraph(result):
    result_graph=Graph()
    person_reason=BNode()
    method_uri=BNode()
    statement_node=BNode()
    has_method=URIRef("http://kgchallenge.github.io/ontology/has_method")
    has_reason=URIRef("http://kgchallenge.github.io/ontology/has_reason")
    related_reason=URIRef("http://kgchallenge.github.io/ontology/related_reason")
    object_reason=URIRef("http://kgchallenge.github.io/ontology/object_reason")
    reason_situ=URIRef("http://kgchallenge.github.io/ontology/reason_situ")
    result_graph.add((method_uri,RDF.type,URIRef(result["killing"][1:-1])))
    result_graph.add((URIRef(result["person"][1:-1]),has_method,method_uri))
    result_graph.add((statement_node,RDF.subject,URIRef(result["person"][1:-1])))
    result_graph.add((statement_node,RDF.predicate,has_method))
    result_graph.add((statement_node,RDF.object,method_uri))
    result_graph.add((statement_node,RDF.type,RDF.Statement))
    reason_node=BNode()
    result_graph.add((statement_node,has_reason,reason_node))
    result_graph.add((reason_node,related_reason,URIRef(result["related_reason"][1:-1])))
    result_graph.add((reason_node,reason_situ,URIRef(result["reason_situ"][1:-1])))
    return(result_graph)

## ファイルからの文字列読み込み
def getFileString(filename):
    with open(filename) as f:
        returntext=f.read()
    return(returntext)

## argparse
def getArgs():
    parser = argparse.ArgumentParser(
        prog='make_has_method_triple',
        epilog='end', 
        add_help=True, 
        )
    parser.add_argument("inputjson")
    parser.add_argument("outputfilename")
    parser.add_argument("configfile")
    
    args = parser.parse_args()
    return(args)

# main
def main():
    
    args=getArgs()
    inputjson=args.inputjson
    outputfilename=args.outputfilename
    configfile=args.configfile
    
    # RDFデータを読み込む
    with open(configfile) as f:
        confjson=json.load(f)
    g=Graph()
    for turtleloadinfo in confjson["graphfiles"]:
        tmpg=Graph()
        tmpg.parse(turtleloadinfo["filename"], format=turtleloadinfo["format"])
        g = g + tmpg
    
    # result1.jsonを読み込み
    with open(inputjson) as f:
        first_result = json.load(f)
    
    # 殺害方法のリストを作成
    killing_list=list(set([ result["killing"]["value"] for result in first_result["results"]["bindings"] ]))
    
    ### 殺害方法に対して、全ての殺害方法を取得
    all_killing_list = [ all_killing[0].n3() for killing in killing_list for all_killing in getSubClassKilling(g, killing) ]
    
    ### 全ての殺害方法に対して犯罪供用物と関連物を取得
    owclassList = [ 
        [
            killing, 
            [
                [
                    owclass[0].n3() ,
                    [ related[0].n3() for related in getRelatedObjectClass(g, owclass[0].n3()) ]
                ]
                for owclass in getOffensiveWeaponClass(g, killing)
            ] 
        ]
        for killing in all_killing_list
    ]
    ### selectPerson_Reasonのルール読み込み
    rulelist=[ getFileString(filename) for filename in confjson["selectPersonReasonRules"] ]
    
    ### 各殺害方法に対して結果の取得
    resultlist=[ [killing, getResultList(g, ow, rolist, rulelist)] for killing, owinfolist in owclassList for ow, rolist in owinfolist ]
    
    ### jsonに変換
    result_json=[ { "person": result[0], "killing": killing, result[3]+"_reason": result[1], "reason_situ": result[2] } 
                 for killing,results in resultlist for result in results ]
    
    ### RDFグラフに変換
    result_graph=Graph()
    for result in result_json:
        result_graph=result_graph+getResultGraph(result)
    
    # RDFグラフを出力
    with open(outputfilename,'w') as f:
        f.writelines(result_graph.serialize(format="turtle").decode())

if __name__=='__main__':
    main()
