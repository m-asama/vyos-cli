vyos-cli: VyOS CLIs for Ubuntu Server LTS
=========================================

## これはなに？

Ubuntu Server LTS を VyOS っぽく設定するためのパッケージ群です。

以下のポリシーでメンテしてます。

- VyOS 1.1.x の CLI が基本的にほぼそのまま使える
- 可能な限り Ubuntu Server LTS のパッケージをそのまま使いセキュリティアップデートは Ubuntu Server LTS にのっかる
- 安定第一

現時点で Ubuntu 20.04 LTS (Focal Fossa) 向けにメンテしてます。

VyOS 1.1.x の CLI を全て移植するのは時間的に厳しいため、
とりあえず自分が必要としているもの(サイト間 IPsec VPN 周り)しかテストしていません。
もし必要とする機能が動かない時はつつくと動くようになるかも(末尾の『何かあったら』参照)。

## 使い方

Raspberry Pi で試してみたいという方は [こちら](README.raspi.md) を参照してください。

AWS で試してみたいという方は [こちら](README.aws.md) を参照してください。

+ 最小構成 + SSH サーバで Ubuntu 20.04 LTS をインストールする
+ root で以下のコマンドを実行
  + echo deb http://www.ginzado.ne.jp/~m-asama/vyos-cli helium-focal main > /etc/apt/sources.list.d/vyos-cli.list
  + curl http://www.ginzado.ne.jp/~m-asama/vyos-cli/vyos-cli.gpg.key | apt-key add -
  + apt-get update
  + apt-get install vyos-cli
    + いくつかのパッケージで設定を確認されますが適当に OK で進んで大丈夫です
  + vyos-cli-setup
  + vyos-cli-ethadd 52:54:00:54:00:ad eth1
  + vyos-cli-ethadd 52:54:00:54:00:be eth2
  + vyos-cli-useradd vyos
  + passwd vyos
  + reboot

`vyos-cli-setup` は VyOS CLI を使うためのセットアップスクリプトです。
VyOS CLI で制御するデーモン群の無効化や VyOS CLI を動かすユーザのための権限の設定などを行います。
apt-get upgrade を実行した際に `vyos-cli-setup` が変更した内容が差し戻る可能性があるため、
`vyos-cli-setup` は後から何度でも実行できるような作りにしているつもりです。
もしおかしかったら教えていただけると助かります。

`vyos-cli-ethadd` はイーサネットインターフェースの MAC アドレスと名前(ethX)の対応づけをするためのスクリプトです。
一つ目の引数に対象イーサネットインターフェースの MAC アドレスを、
二つ目の引数にその名前(ethX)を指定します。
VyOS CLI ではイーサネットインターフェースの名前は必ず ethX のようになっていなければならないため、
二つ目の引数は必ず ethX のようになっていなければなりません。
このスクリプトは `/etc/udev/rules.d/` に udev のルールを書き出すだけです。
コマンド実行後に再起動する必要があります。

`vyos-cli-useradd` は VyOS CLI を使うためのユーザを登録するためのスクリプトです。
VyOS CLI を使うためのグループを指定したりログインシェルを vbash にしたりしているだけです。
通常の Ubuntu ユーザと VyOS CLI ユーザが混在しても大丈夫なように、
VyOS CLI では `set system login user` によるアカウント登録をサポートしません。

Ubuntu パッケージの更新があった際は再度 `vyos-cli-setup` を実行します。
念のため再起動した方が良いかもしれません。

再起動後、 `vyos-cli-useradd` で作ったユーザでログインすると VyOS のコマンド群が使えるはずです。
ちなみに root から `su - vyos` でユーザを切り替える方法だとダメなのでご注意ください。
pam_cap.so でアカウントに権限を付与しているのですが `su - vyos` だとそれが有効にならないためです。
root からユーザを切り替える場合は `sudo -i -u vyos` のようにしてください。

## ビルド方法

VyOS CLI のリポジトリは以下の通りです。

- https://github.com/m-asama/vyatta-bash
- https://github.com/m-asama/vyatta-biosdevname
- https://github.com/m-asama/vyatta-cfg
- https://github.com/m-asama/vyatta-cfg-dhcp-relay
- https://github.com/m-asama/vyatta-cfg-dhcp-server
- https://github.com/m-asama/vyatta-cfg-firewall
- https://github.com/m-asama/vyatta-cfg-op-pppoe
- https://github.com/m-asama/vyatta-cfg-qos
- https://github.com/m-asama/vyatta-cfg-quagga
- https://github.com/m-asama/vyatta-cfg-system
- https://github.com/m-asama/vyatta-cfg-vpn
- https://github.com/m-asama/vyatta-cluster
- https://github.com/m-asama/vyatta-config-mgmt
- https://github.com/m-asama/vyatta-config-migrate
- https://github.com/m-asama/vyatta-conntrack
- https://github.com/m-asama/vyatta-cron
- https://github.com/m-asama/vyatta-ipv6-rtradv
- https://github.com/m-asama/vyatta-nat
- https://github.com/m-asama/vyatta-op
- https://github.com/m-asama/vyatta-op-dhcp-server
- https://github.com/m-asama/vyatta-op-firewall
- https://github.com/m-asama/vyatta-op-qos
- https://github.com/m-asama/vyatta-op-quagga
- https://github.com/m-asama/vyatta-op-vpn
- https://github.com/m-asama/vyatta-openvpn
- https://github.com/m-asama/vyatta-ravpn
- https://github.com/m-asama/vyatta-util
- https://github.com/m-asama/vyatta-vrrp
- https://github.com/m-asama/vyatta-webproxy
- https://github.com/m-asama/vyatta-wireless
- https://github.com/m-asama/vyatta-wirelessmodem
- https://github.com/m-asama/vyatta-zone
- https://github.com/m-asama/vyos-nhrp
- https://github.com/m-asama/vyos-opennhrp

以下の手順でビルドできると思います(以下は vyatta-cfg-system の例)。

+ git clone https://github.com/m-asama/vyatta-cfg-system
+ cd vyatta-cfg-system
+ DEB_BUILD_OPTIONS=nocheck debuild --no-tgz-check

ビルドに必要なパッケージはすみません、各自でインストールしてください。

## 何かあったら

もし何か不具合等ありましたら [ここ](https://github.com/m-asama/vyos-cli/issues) にイシューを立ててください。

それか [私の Twitter アカウント](https://twitter.com/m_asama) にメンションを飛ばしてください。

余裕があったら対応するかもです。

## 現時点でとりあえず動くはずな機能

- サイト間 IPsec VPN 周り
- ファイアウォール周りもなんとなく動きそう
- ルーティングプロトコル周りも動くかも

## 既知の問題

- VyOS CLI 以外のコマンド補完がうまくいかない
  - たぶんとりあえずエラーにならないように修正したこの辺が原因なんだと思いますが、どなたか bash-completion に詳しい方なおす方法をご存知でしたら教えていただけると助かります。
  - https://github.com/m-asama/vyatta-cfg/commit/7973c3db10853246e9a0d3f024b62e3e180f9d18#diff-35c0eab855ac848e067f6b5a38a37391R137
  - https://github.com/m-asama/vyatta-op/commit/dd4845d638242b456d60dbbfdf88264ff2f19eb2#diff-f2deeec45c525d994f94dc541e1af42cR112
