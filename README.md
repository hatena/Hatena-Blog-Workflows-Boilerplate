# HatenaBlog Workflows Boilerplate(β)
- このBoilerplateは、企業がはてなブログで技術ブログを運営する際のレビューや公開作業など、運営ワークフローを支援する目的で作成しています
- GitHub 上で、はてなブログとの記事の同期、下書きの作成・編集・公開、公開記事の編集などを行うことができます。下書きの作成時にプルリクエストが作成されるため、記事のレビューなどの業務のワークフローに組み込むことが容易になります
- 本機能はベータ版です。正常に動作しない可能性がありますが、予めご了承下さい


# セットアップ
1. 本リポジトリトップに表示されている、「Use this template ボタンクリック > Create a new repository」から、新規にリポジトリを作成する
    - ![Use this templateボタンの位置](https://cdn-ak.f.st-hatena.com/images/fotolife/h/hatenablog/20231107/20231107164142.png)
2. `blogsync.yaml`の各種項目を記述してください
    - `<BLOG DOMAIN>` にはブログのブログ取得時に設定したドメインを指定してください(独自ドメインではありません)
    - `<BLOG OWNER HATENA ID>` にはブログのオーナー(ブログ作成者)のはてなIDを指定してください
    - 上記のどちらの項目もブログの「詳細設定 > AtomPub > ルートエンドポイント」から確認できます。ルートエンドポイントは以下のように構成されています
        - `https://blog.hatena.ne.jp/<BLOG OWNER HATENA ID>/<BLOG DOMAIN>/atom`
```yaml
<BLOG DOMAIN>:
  username: <BLOG OWNER HATENA ID>
default:
  local_root: entries
```
3. GitHub リポジトリの設定 「`Secrets and variables` > `actions` > `Repository variables`」 から以下のVariableを登録する
    - Name: `BLOG_DOMAIN`
    - Value: ブログのドメインを指定してください 例) staff.hatenablog.com
4. GitHub リポジトリの設定 「`Secrets and variables` > `actions` > `Repository Secrets`」 から以下のSecretを登録する
    - Name: `OWNER_API_KEY`
    - Secret: ブログのオーナーはてなアカウントの APIキーを指定してください
        - APIキーは、ブログオーナーアカウントでログイン後、[アカウント設定](https://blog.hatena.ne.jp/-/config) よりご確認いただけます
5. GitHub リポジトリの設定 「`Actions` > `General`」 の `Workflow permissions` の設定を以下の通り変更する
    - `Read and write permissions` を選択する
    - `Allow GitHub Actions to create and approve pull requests` にチェックを入れる
6. GitHub リポジトリの設定 「`Branches`」 の`Add branch protection rule`ボタンから、ルールを作成する
    - `Branch name pattern` に `main` を指定する
7. GiHub リポジトリの設定 「`General`」 の `Pull Requests` 項の `Allow auto merge` にチェックを入れる
8. リポジトリにはてなブログの記事を同期させる
    - Actions タブを開き `initialize` workflow を選択する
    - Run workflow をクリック
    - `Branch: main` が指定されていることを確認し、`Run workflow`ボタンをクリック
    - 全記事が含まれたプルリクエストが作成されます。これをマージしてはてなブログとリポジトリの状況を同期させてください
    - ![Actionsタブ、workflowリスト、Run workflowボタン](https://cdn-ak.f.st-hatena.com/images/fotolife/h/hatenablog/20231107/20231107163433.png)

# 想定ワークフロー

このツールで想定している下書き作成から記事公開までのワークフローは以下のとおりです。

1. 下書きを作成する
2. 下書き記事をプルリクエスト上で編集する
3. 適宜レビューなどを行い、通れば次の公開手順に進む
4. 下書き記事を公開する


# 手順の詳細

## 下書きの作成
下書きの作成方法は以下の2通りの方法があります。

- ブログメンバーが個人のアカウントで投稿する(記事の署名は個人のアカウントになります)
- ブログオーナーのアカウントで投稿する(記事の署名はブログオーナーアカウントになります)

それぞれ、下書き作成の手順が異なります。ブログの運営方針や記事の内容に沿った方法を選択してください。

### ブログメンバーが個人のアカウントで投稿する場合

1. 投稿したいブログの編集画面を開く
2. 下書き記事の記事タイトルを `{{username}}-{{日付}}` 等、ユニークな記事タイトルに設定し、クリップボードにコピーしておく
3. 下書きを投稿する
4. Actions から `pull draft from hatenablog`を選択し、`Draft Entry Title`に先程コピーしたタイトルを設定、`Branch: main`に対して実行する
5. 投稿した下書きを含むプルリクエストが作成される

### ブログオーナーのアカウントで投稿する場合

1. Actions から  `create draft` を選択し、`Title`に記事タイトルを設定、`Branch: main`に対して実行する
2. 作成した下書きを含むプルリクエストが作成される

## 下書き記事の編集
- 手順「下書きの作成」で作成したプルリクエスト上で記事を編集してください
- はてなブログでプレビューできるようにするため、下書き記事に限りプッシュされた時点ではてなブログに同期されます
- 記事の編集画面の URL は、プルリクエストに記載されています。編集画面に遷移した後、下書きプレビューの URL を発行し、プルリクエストの概要に記載しておくとプレビューが容易になります

## 下書き記事の公開
- 下書き記事の `Draft: true` 行を削除し、プルリクエストを main ブランチにマージすると記事がはてなブログで公開されます
- 記事を公開すると、下書き記事は 下書き記事用ディレクトリ `draft_entries` から 公開記事用`entries` ディレクトリに移管されます

## 既存記事を修正する場合
- 修正ブランチを作成し、main ブランチにマージすると修正がはてなブログに反映されます


# トラブルシューティング
## はてなブログ側のデータとリポジトリのデータとで差分が発生した場合
はてなブログのWebの編集画面から記事を更新するなど、はてなブログ側のデータとリポジトリのデータに差異が発生してしまう場合があります。
この場合、 Actions の `pull from hatenablog` を選択、`Branch: main`に対して実行してください。
実行すると、リポジトリの更新日時以降に更新された公開記事のデータを更新するプルリクエストが作成されます。
これをマージすることで、最新のデータに更新することができます。




# workflow に関する詳細

- 各 workflow では下記で提供されている Reusable workflows を利用しています
  - https://github.com/hatena/hatenablog-workflows
