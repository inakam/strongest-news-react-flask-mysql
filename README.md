- Setting node_modules

```bash
cd docker-images-react && yarn install
```

- Build containers:

```bash
docker-compose build
```

- Run containers :

```bash
docker-compose up
```

You should be able to check it in your Docker container's URL, for example:

React(Frontend) : <a href="http://localhost" target="_blank">http://localhost</a>

Flask(Backend) : <a href="http://localhost:5000" target="_blank">http://localhost:5000</a>

You can check DB server, for example:

```bash
mysql -h 127.0.0.1 -u user -ppassword
```

# AWS 環境で ECS デプロイをする方法

1. strongest-news-terraform/variables.tf の内容を修正
   - name・artifacts_name・environment の 3 つの内容を書き換える
1. strongest-news-terraform フォルダの内容を実行
   1. terraform init で初期化
   1. terraform apply で環境を構築
1. 構築された AWSCodecommit にアプリケーションをデプロイ
   - この Github の内容をそのままプッシュすればいい
1. CodePipeline のパイプラインを実行
