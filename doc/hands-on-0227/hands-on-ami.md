大阪 SHIRASAGI ハンズオン用 AMI
===

大阪 SHIRASAGI ハンズオン用 AMIを公開します。

    Id: ami-09846209
    Name: webtips-shirasagi-ami-for-matsue-handson-20150227
    Region: Tokyo

## 使用方法

1. AWS Management Console にログインし、Instance を作成します。
2. 「Choose AMI」が表示されたら、左側の Community AMI をクリックします。
3. "ami-09846209" を検索すると、webtips-shirasagi-ami-for-matsue-handson-20150227 が表示されます。

![Launch AMI](./images/AMI-Launch-min.png)

表示された AMI の "Select" をクリックし、画面の指示にしたがって Instance を作成してください。

## ログイン

ログイン ユーザ Id は `ec2-user` です。
プライベート・キーを使用してログインしてください。

## 補足

* 本 AMI は、`amzn-ami-hvm-2014.09.2.x86_64-ebs (ami-18869819)` を元にして作成しています。
* RVM を /usr/local/rvm にインストールした後で、Ruby 2.1.2p95 をインストールしています。
* MongoDB 2.7.6 をインストールしています。
* ハンズオン終了後 AMI は削除します。
