# gui-docker
dockerでGUIを使えるようにしたDockerfileです．

使うためには[Nvidia-docker](https://github.com/FirstSS-Sub/Docker-Mnist)の通りに環境を構築してあることが前提です．

なお，このDockerfileには，opencv,tensorflowなどが最初から入っています．

Dockerfileを自分の使用したい環境にいじって使ってください．
## 概略
Dockerを使って，sshできるサーバーをローカルに立てて，そのサーバーにsshでログインする．
## 使い方
上記のサイトを元に環境を構築したあと，このレポジトリをクローンしてください．

クローンしたら，

'''
cd ./gui-docker
'''

でディレクトリを移動してください．次に

'''
sudo docker image build . -t gui-docker
'''

でイメージを作成し，

'''
sudo docker run --gpus all  -v $(pwd):/user/local -d -p {$PORT}:22 gui-docker
'''

で，コンテナの実行をしてください.{$PORT}は適当な空いてるポートを入れてください．

次に，別の端末からsshコマンドでサーバーにアクセスしてください．

'''
ssh -X root@localhost -p {$PORT}
'''

このとき，パスワードは*screencast*です．(必要であれば適宜Dockerfileをいじって変更してください．)

ログインすることができたら，

'''
cd /user/local

python3 test.py
'''

を実行してみてください．簡単なグラフが出てこれば成功です．お疲れ様でした．
## 参考サイト
[Docker 初心者 — ssh で接続できるサーバーを立てる](https://qiita.com/YumaInaura/items/adb20c8083fce2da86e1)

[SSHで接続したリモートホストのGUIアプリケーションを使用する方法](https://users.miraclelinux.com/support/?q=node/374)

[一般ユーザー権限で入れるsshd専用コンテナをdockerで動かした](https://blog.n-z.jp/blog/2018-07-31-user-sshd-in-docker.html)
