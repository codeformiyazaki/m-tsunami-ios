# 宮崎津波防災 iOS

![](https://github.com/codeformiyazaki/m-tsunami-ios/workflows/CI/badge.svg)

宮崎市の津波防災に必要な情報を発信する[iOSアプリ](https://apps.apple.com/us/app/%E5%AE%AE%E5%B4%8E%E6%B4%A5%E6%B3%A2%E9%98%B2%E7%81%BD/id1462576599?ls=1)です。
メインのマップには以下の情報が表示されています。

- 津波避難ビル
- 災害時に稼働するマンホールトイレ
- [海岸線を監視するウェブカメラ](https://www.ii-nami.com/)
- [指定避難所](https://www.geospatial.jp/ckan/dataset/hinanbasho/resource/b2b56005-9c68-432c-8fa8-6cb312459a08)

避難ビルや避難所・トイレのマーカーをクリックすると、現在位置からの経路を表示します。あくまで目安としてお使いください。
災害時にも通行できることを保証するものではありません。
本アプリケーションは Code for Miyazaki の有志によって作成され、MITライセンスでコードが公開されています。
防災を考えるきっかけを目指して開発しておりますが、我々だけで全てのデータの正しさを確認することはできません。
間違いを発見された場合、GitHubのIssueやPull requestを活用してご報告頂ければ幸いです。

今後、実装予定の機能についても、Issueをご確認ください。

## ディレクトリ
- assets: 開発やデータ収集関連のリソースやツール
- iosapp: iOSアプリ本体
- railsapp: Railsアプリ(push通知管理)

## 参考リンク

- [OpenHinata](https://kenzkenz.xsrv.jp/aaa)
- [気象庁防災情報XMLフォーマット形式電文の公開](http://xml.kishou.go.jp/xmlpull.html)
- [国土数値情報ダウンロードサービス](http://nlftp.mlit.go.jp/ksj/)
- https://www.glyphicons.com/
- http://icooon-mono.com/
- https://material.io/resources/icons/?style=baseline
- [G空間情報センター](https://www.geospatial.jp/gp_front/)

### 経度緯度(lng,lat)の調べ方

1. パソコンで [GoogleMap](https://www.google.co.jp/maps) を開きます。
2. 地図上の目的の場所を右クリックします。
3. [この場所について] を選択します。
4. 画面下部のカードに座標が表示されます。
5. assetsフォルダ内のgeojsonに要素を追加します。[スプレッドシート](https://docs.google.com/spreadsheets/d/1FdGLrjkuGBtYe4DSTrTFV861ukzReuXsBDEJsw8oS1M/edit?usp=sharing)は今後使わない予定です。

- [Google Map Help](https://support.google.com/maps/answer/18539?co=GENIE.Platform%3DDesktop&hl=ja)


## 環境
### development
```
export BASIC_AUTH_PASS=secret
export APN_CERT=$(cat << EOS
-----BEGIN PRIVATE KEY-----
:
-----END PRIVATE KEY-----
EOS
)
```

### staging
https://desolate-headland-83158.herokuapp.com/

```
sudo snap install heroku --classic
heroku login

heroku create --remote staging
git subtree push --prefix railsapp staging master
git config heroku.remote staging
heroku config:set BASIC_AUTH_PASS=secret
# private key for APN is managed by LumberMill's repo now (ad hoc)
heroku run rake db:migrate
```
- [Heroku - Getting started with ruby](https://devcenter.heroku.com/articles/getting-started-with-ruby)

### production
https://m-tsunami.herokuapp.com/

```
heroku create m-tsunami --remote production
# key’s are managed in LM’s repo (ad hoc)
heroku config --app m-tsunami
heroku run rake db:migrate --app m-tsunami
```

```
git subtree push --prefix railsapp production master
```
