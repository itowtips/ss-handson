��� SHIRASAGI �n���Y�I���p Vagrant
===

��� SHIRASAGI �n���Y�I���p Vagrant�����J���܂��B

## �g�p���@

�K���ȃf�B���N�g�����쐬���A���̂悤�ȓ��e������  Vagrantfile  ���쐬���Ă��������B

```
$ mkdir osaka-handson
$ cd osaka-handson
$ cat Vagrantfile
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ss-vagrant"
  config.vm.box_url = "https://github.com/shirasagi/ss-vagrant/releases/download/20150212/ss-vagrant.box"
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provider :virtualbox do |vb|
    # see: http://blog.shibayu36.org/entry/2013/08/12/090545
    # IPv6 �� DNS �ł̃l�b�g���[�N�x���΍�ŒǋL
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end
end
```

���̃R�}���h�ŋN���ł��܂��B

```
$ vagrant up
```

5 ������ 10 �����炢������̂ŁA�R�[�q�[�ł����݂Ȃ���҂��Ă��������B

�N�������� ssh �N���C�A���g�Ń��O�C�����Ă��������B
* host: localhost
* port: 2222
* user: vagrant
* password: vagrant

��� SHIRASAGI �n���Y�I���p Vagrant �ɂ́ASHIRASAGI �� `/vagrant/home` �ɃC���X�g�[������Ă��܂��B

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

SHIRASAGI ���N�����Ă݂܂��傤�B

```
$ cd $HOME/shirasagi
$ bundle exec rake unicorn:start
bundle exec unicorn_rails -c /home/vagrant/shirasagi/config/unicorn.rb -E production -D
```

�u���E�U�� "http://localhost:3000/" �ɃA�N�Z�X���Ă݂܂��傤�B ���̂悤�ȉ�ʂ��\�����ꂽ�����ł��B

![SHIRASAGI TOP](images/top-min.png)


## Vagrant �ɂ���

Vagrant Box ���g�p����ɂ́A�ʓr VirtualBox �� Vagrant �̃C���X�g�[�����K�v�ł��B
���ꂼ��ȉ��̏ꏊ����_�E�����[�h���A�C���X�g�[�����Ă��������B

* VirtualBox: [VirtualBox Download](https://www.virtualbox.org/wiki/Downloads)
* Vagrant: [Vagrant Download](http://www.vagrantup.com/downloads.html)


## Vagrant Box �̒��g

* CentOS 6.6 (2015-02-12 ���_�ł̍ŐV)
* MongoDB 2.6.7
* Ruby 2.1.2p95
* SHIRASAGI �̃\�[�X�ꎮ (2015-02-12 ���_�ł̍ŐV)

