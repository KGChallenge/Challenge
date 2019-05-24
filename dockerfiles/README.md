## とりあえず動かす
  - Dockcerは既にインストールされていることが前提
  - [Dockerのインストール](http://docs.docker.jp/engine/installation/toc.html)
```
$ git clone https://github.com/KGChallenge/Challenge.git
$ cd Challenge/dockerfiles 
$ docker build -t image_name:tag .
$ docker run -itd --name container_name image_name:tag
$ cd ../..
$ docker cp Challenge container_name:/root/
$ docker exec -it container_name /bin/bash       # container_name に入る
# cd /root/Challenge/Motivation/Binaries         # 以下のコマンドは container_name の中で実行されている
# sh ./run_inference.sh                          # 殺人動機を推論
```


## docker コマンドについて
### docker image の作成
```
$ docker build -t image_name:tag .        # Dockerfile から docker image を作成
```

### docker container の作成
```
$ docker run -itd --name container_name image_name:tag  # container\_name という名前で docker container を作成
```

### docker container の起動と停止
```
$ docker start container_name                # container_name という名前の docker container を起動
$ docker stop container_name                 # container_name という名前の docker container を停止
```

### docker container を使ったコマンドの実行
```
$ docker exec -it container_name /bin/bash   # /bin/bash を実行 (container_name 内でCUI操作．詳しくは docker exec のオプション参照．) 
$ docker exec container_name arq -h          # arq -h を実行 
```

### docker container \<-\> host 間のファイル/ディレクトリのコピー
```
# local     -> container
$ docker cp file/or/dir/path container_name:/file/or/dir/path

# container -> local 
$ docker cp container_name:/file/or/dir/path file/or/dir/path
```

### コンテナの削除
```
$ docker rm container_name
```


### 参考
  - ドキュメント
    - https://docs.docker.com/ (本家)
    - http://docs.docker.jp/index.html (日本語化プロジェクト版)
  - チートシート
    - http://exrecord.net/how-to-use-docker-command

