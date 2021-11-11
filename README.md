# Nginxの Serverヘッダを隠すための設定など

* headers-more-nginx-module を dynamic module として組み込んでビルドします
* 当該ファイルのダウンロード方法や、これを組み込んだビルド方法は Dockerfile を参照して下さい


* ビルド完了後、nginx.conf にて、上記でインストールした dynamic module を読み込むように設定します
* 具体的には、nginx.conf の一番上に、load_module ディレクティブを宣言します

* 最後に、Serverヘッダを隠すために、各種コンフィグファイル（ここではdefault.conf）のServerディレクティブにて、more_clear_headers Server; を宣言します


