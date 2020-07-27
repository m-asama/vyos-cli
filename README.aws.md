AWS など cloud-init が動く環境で試してみる際の注意点
====================================================

AWS などコンソールへ直接アクセスができず SSH によるリモートアクセス手段しかないような環境では、
cloud-init でリモートアクセスできるようにセットアップが行われることが多いようです。

そのような時は若干注意が必要です。

## 使い方

+ Ubuntu 20.04 LTS のインスタンスを起動する
  + 以下は ubuntu-focal-20.04-amd64-server で検索して出てきた Canonical が提供するコミュニティ AMI を例に試しています
+ アカウント ubuntu で SSH ログインする
+ root で以下のコマンドを実行
  + echo deb http://www.ginzado.ne.jp/~m-asama/vyos-cli helium-focal main > /etc/apt/sources.list.d/vyos-cli.list
  + curl http://www.ginzado.ne.jp/~m-asama/vyos-cli/vyos-cli.gpg.key | apt-key add -
  + apt-get update
  + apt-get install vyos-cli
    + いくつかのパッケージで設定を確認されますが適当に OK で進んで大丈夫です
  + vyos-cli-setup
    + ここまでは通常の方法と一緒ですが vyos-cli-ethadd は実行しません
  + vyos-cli-useradd vyos
  + passwd vyos
  + reboot
+ アカウント ubuntu で SSH ログインする
+ root で以下のコマンドを実行
  + /etc/netplan/50-cloud-init.yaml の内容を全てコメントアウト
  + vyos-cli-ethadd 52:54:00:54:00:ad eth0
    + 52:54:00:54:00:ad の部分は実際の eth0 の MAC アドレスに置き換えてください
  + sudo -i -u vyos
  + configure
  + set interfaces ethernet eth0 address dhcp
  + commit
  + save
  + run reboot

AWS の Ubuntu 20.04 LTS の AMI は cloud-init が用意した netplan の設定で NIC が eth0 にリネームされ、
IP アドレスが DHCP で設定されるようになっているようです。

上記の手順で cloud-init でこれらの設定を行う方法をやめ、
VyOS CLI の方法で NIC のリネームと DHCP の設定がされるようになります。
