東京 SHIRASAGI ハンズオン用 Vagrant
===

東京 SHIRASAGI ハンズオン用 Vagrantを公開します。

## 使用方法

適当なディレクトリを作成し、次のような内容を持つ  Vagrantfile  を作成してください。

```
$ mkdir tokyo-handson
$ cd tokyo-handson
$ cat Vagrantfile
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ss-vagrant"
  config.vm.box_url = "https://github.com/shirasagi/ss-vagrant/releases/download/v0.7.0-SNAPSHOT-20150406-1849/ss-vagrant-virtualbox.box"
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provider :virtualbox do |vb|
    # see: http://blog.shibayu36.org/entry/2013/08/12/090545
    # IPv6 と DNS でのネットワーク遅延対策で追記
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end
end
```

次のコマンドで起動できます。

```
$ vagrant up
```

5 分から 10 分ぐらいかかるので、コーヒーでも飲みながら待ってください。

起動したら ssh クライアントでログインしてください。
* host: localhost
* port: 2222
* user: vagrant
* password: vagrant

東京 SHIRASAGI ハンズオン用 Vagrant には、SHIRASAGI が `/vagrant/home` にインストールされています。

```
$ tree -L 2 /vagrant/home
/home/vagrant
`-- shirasagi
    |-- app
    |-- bin
    |-- config
    |-- config.ru
    |-- db
    |-- doc
    |-- Gemfile
    |-- Gemfile.lock
    |-- Guardfile
    |-- lib
    |-- MIT-LICENSE
    |-- private
    |-- public
    |-- Rakefile
    |-- README.md
    |-- spec
    `-- vendor
```

SHIRASAGI を起動してみましょう。

```
$ cd $HOME/shirasagi
$ bundle exec rake unicorn:start
bundle exec unicorn_rails -c /home/vagrant/shirasagi/config/unicorn.rb -E production -D
```

ブラウザで "http://localhost:3000/" にアクセスしてみましょう。 次のような画面が表示された成功です。

![SHIRASAGI TOP](images/top-min.png)


## Vagrant について

Vagrant Box を使用するには、別途 VirtualBox と Vagrant のインストールが必要です。
それぞれ以下の場所からダウンロードし、インストールしてください。

* VirtualBox: [VirtualBox Download](https://www.virtualbox.org/wiki/Downloads)
* Vagrant: [Vagrant Download](http://www.vagrantup.com/downloads.html)


## Vagrant Box の中身

* CentOS 6.6 (2015-04-06 時点での最新)
* MongoDB 2.6.9
* Ruby 2.2.1p85
* SHIRASAGI のソース一式 (2015-04-06 時点での最新)

