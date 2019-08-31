# 宮崎津波防災 iOS

- assets: 開発やデータ収集関連のリソースやツール
- iosapp: iOSアプリ本体
- railsapp: Railsアプリ(push通知管理)

## 参考リンク

- [OpenHinata](https://kenzkenz.xsrv.jp/aaa)
- [気象庁防災情報XMLフォーマット形式電文の公開](http://xml.kishou.go.jp/xmlpull.html)
- https://www.glyphicons.com/
- http://icooon-mono.com/

### 経度緯度(lng,lat)の調べ方

1. パソコンで [GoogleMap](https://www.google.co.jp/maps) を開きます。
2. 地図上の目的の場所を右クリックします。
3. [この場所について] を選択します。
4. 画面下部のカードに座標が表示されます。
5. [スプレッドシート](https://docs.google.com/spreadsheets/d/1FdGLrjkuGBtYe4DSTrTFV861ukzReuXsBDEJsw8oS1M/edit?usp=sharing) に転記します。

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
