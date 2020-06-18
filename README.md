# gui-docker
DockerでGUIを使えるようにしたDockerfileです．

使うためには[Nvidia-dockerの導入](https://github.com/FirstSS-Sub/Docker-Mnist)の通りに環境を構築してあることが前提です．

なお，このDockerfileには，opencv,tensorflowなどが最初から入っています．

Dockerfileを自分の使用したい環境にいじって使ってください．
## 概略
Dockerを使って，sshできるサーバーをローカルに立てて，そのサーバーにsshでログインする．
## 使い方
上記のサイトを元に環境を構築したあと，このレポジトリをクローンしてください．

クローンしたら，

 ```
cd ./gui-docker
 ```

でディレクトリを移動してください．次に

 ```
sudo docker image build . -t gui-docker
 ```

でイメージを作成し，

 ```
sudo docker run --gpus all  -v $(pwd):/user/local -d -p {$PORT}:22 gui-docker
 ```

で，コンテナの実行をしてください.{$PORT}は適当な空いてるポートを入れてください．

次に，別の端末からsshコマンドでサーバーにアクセスしてください．

 ```
ssh -X root@localhost -p {$PORT}
 ```

このとき，パスワードは**screencast**です．(必要であれば適宜Dockerfileをいじって変更してください．)

ログインすることができたら，

 ```
cd /user/local

python3 test.py
 ```

を実行してみてください．簡単なグラフが出てこれば成功です．お疲れ様でした．
## vscodeについて
vscodeの仕様でrootでの起動ができないようになっています．vscodeを起動したい場合は別ユーザーでコンテナの中に入る必要があるようです．
```
ssh -X yaegasi@localhost -p {$PORT}
```
でログインし，入ることができたら
```
code
```
でvscodeが起動できるはずです．
ユーザー名を変更したい場合はDockerfileをいじってください．
## 使い終わったら
コンテナを停止もしくは削除しないと使用したポートが使われたままになります．
#### 停止
```
sudo docker ps
```
でコンテナのIDを確認し
```
sudo docker stop [コンテナのID]
```
もしくは
```
sudo docker stop gui-docker
```
#### 削除
```
sudo docker rm [コンテナのID]
```
もしくは
```
sudo docker rm gui-docker
```
#### エラー
コンテナを消したはずなのに新しいコンテナを立ち上げ，sshしようとした時に
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.......
```
みたいなエラーが出た場合

[SSH接続エラー回避方法：.ssh/known_hostsから特定のホストを削除する/削除しないで対処する3つの方法](https://qiita.com/grgrjnjn/items/8ca33b64ea0406e12938)

[SSH接続で WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! って言われて接続を拒否られるとき](https://qiita.com/wnoguchi/items/690f3f4651f8f11e4ed3)

この辺を参照してみてください．
エラーが出る理由も書かれています．
## 参考サイト
[Docker 初心者 — ssh で接続できるサーバーを立てる](https://qiita.com/YumaInaura/items/adb20c8083fce2da86e1)

[SSHで接続したリモートホストのGUIアプリケーションを使用する方法](https://users.miraclelinux.com/support/?q=node/374)

[一般ユーザー権限で入れるsshd専用コンテナをdockerで動かした](https://blog.n-z.jp/blog/2018-07-31-user-sshd-in-docker.html)

[dockerfileでpython/opencv環境を構築する。](https://kinacon.hatenablog.com/entry/2018/10/23/152944)
