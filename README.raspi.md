Raspberry Pi での使い方
=======================

Raspberry Pi 用の Ubuntu 20.04 LTS のイメージが公式サイトで配布されており、
このイメージを使うことで Raspberry Pi に vyos-cli を入れて使うことができます。

+ https://ubuntu.com/download/raspberry-pi

一応 vyos-cli は 32bit 版と 64bit 版の両方に対応しているはず、、です。

## 使い方

+ 上記のサイトから Ubuntu 20.04 LTS のイメージを入手しインストールする
+ アカウント ubuntu でログインする
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
+ アカウント ubuntu でログインする
+ root で以下のコマンドを実行
  + /etc/netplan/50-cloud-init.yaml の内容を全てコメントアウト
  + sudo -i -u vyos
  + configure
  + set interfaces ethernet eth0 address dhcp
    + 固定 IP アドレスを設定する時は `dhcp` の部分を `IP アドレス/プレフィクス長` に置き換えてください
  + commit
  + save
  + run reboot
