# rspec_sample

簡単なsinatraアプリを例としたテスト駆動開発の紹介をします。今回作成するsinatraアプリの完成コードは以下です。

```
require 'sinatra'

get '/' do
  'Hello'
end
```

完成後のすべてのコードは、https://github.com/ppworks/rspec_sample にあります。

それでは、まずはレポジトリをcloneします。

```
git clone git://github.com/ppworks/rspec_sample.git
```

ディレクトリを移動して、必要なgemファイルをインストールします。

```
cd rspec_sample
bundle install --path .bundle
```

テストが通ることを確認します。

```
bundle exec rspec
```

```
App
  レスポンスの精査
    /へのアクセス
      正常なレスポンスが返ること
      Helloと出力されること

Finished in 0.04865 seconds
2 examples, 0 failures
```

無事にテストが通りましたね。ではここまでに至る作業を見ていきます。各ステップはtagを作成してあるので以下のコマンドでtagが存在を確認して下さい。

```
git tag -n
```
```
tdd_001         テスト駆動開発例テストから書く
tdd_002         テスト駆動開発例テストに沿った実装を書く
tdd_003         テスト駆動開発例テストから書くその2
tdd_004         テスト駆動開発例テストに沿った実装を書くその2
tdd_005         specのリファクタリング
```

各tagに切り替えた際にコードを確認して見ることが大切です。実際にコードを見るようにして下さい。


# テストから書く
まずは最初のtagをcheckoutします。

```
git checkout tdd_001
```

次にテストを実行します。

```
bundle exec rspec
```

以下のように、テストが失敗します。```1 example, 1 failure```は全部で1つのサンプルが存在し、1つが失敗したことを表しています。

```
App
  レスポンスの精査
    /へのアクセス
      正常なレスポンスが返ること (FAILED - 1)

Failures:

  1) App レスポンスの精査 /へのアクセス 正常なレスポンスが返ること
     Failure/Error: last_response.should be_ok
       expected ok? to return true, got false
     # ./spec/app_spec.rb:14:in `block (4 levels) in <top (required)>'

Finished in 0.09747 seconds
1 example, 1 failure

Failed examples:

rspec ./spec/app_spec.rb:13 # App レスポンスの精査 /へのアクセス 正常なレスポンスが返ること
```

このとき、```app.rb```を見てみると何も書いて有りませんね。このようにテスト駆動開発では、このように動いて欲しいという期待を先に記述します。ではこのテストコードを見てみましょう。```git diff tdd_001..tdd_002```の実行結果です。

```spec/app.rb
# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "App" do
  include Rack::Test::Methods
  def app
    @app ||= Sinatra::Application
  end

  describe "レスポンスの精査" do
    describe "/へのアクセス" do
      before { get '/' }
      it "正常なレスポンスが返ること" do
        last_response.should be_ok
      end
    end
  end
end
```

次はこのテストが期待するコードを実装していきます。

# テストに沿った実装を書く
次のtagをcheckoutしましょう。

```
git checkout tdd_002
```

この状態でテストを実行すると

```
bundle exec rspec
```

今度は成功しましたね。

```
App
  レスポンスの精査
    /へのアクセス
      正常なレスポンスが返ること

Finished in 0.10743 seconds
1 example, 0 failures
```

どのような処理を書いたのか見てみましょう。

```diff
diff --git a/app.rb b/app.rb
index e69de29..920ebe6 100644
--- a/app.rb
+++ b/app.rb
@@ -0,0 +1,4 @@
+require 'sinatra'
+
+get '/' do
+end
```

実にシンプルですね。このようにテスト駆動開発では、実装から書きたくなりがちなところをテストから書いていきます。

# テストから書くその2

もう少しテストを足してみましょう。

```
git checkout tdd_003
```

今回足したテストは以下です。```git diff tdd_002..tdd_003```の実行結果です。

```diff
diff --git a/spec/app_spec.rb b/spec/app_spec.rb
index d849e1e..076f412 100644
--- a/spec/app_spec.rb
+++ b/spec/app_spec.rb
@@ -13,6 +13,9 @@ describe "App" do
       it "正常なレスポンスが返ること" do
         last_response.should be_ok
       end
+      it "Helloと出力されること" do
+        last_response.body.should == "Hello"
+      end
     end
   end
 end
```

```
bundle exec rspec
```

```
App
  レスポンスの精査
    /へのアクセス
      正常なレスポンスが返ること
      Helloと出力されること (FAILED - 1)

Failures:

  1) App レスポンスの精査 /へのアクセス Helloと出力されること
     Failure/Error: last_response.body.should == "Hello"
       expected: "Hello"
            got: "" (using ==)
     # ./spec/app_spec.rb:17:in `block (4 levels) in <top (required)>'

Finished in 0.11694 seconds
2 examples, 1 failure

Failed examples:

rspec ./spec/app_spec.rb:16 # App レスポンスの精査 /へのアクセス Helloと出力されること
```

テストは通りませんね。では次はこのテストが通る実装をみてみましょう。

# テストに沿った実装を書くその2

```
git checkout tdd_004
```

今回の差分は以下です。```git diff tdd_003..tdd_004```の実行結果です。"Hello"という文字列を返しています。

```diff
diff --git a/app.rb b/app.rb
index 920ebe6..0520e2e 100644
--- a/app.rb
+++ b/app.rb
@@ -1,4 +1,5 @@
 require 'sinatra'

 get '/' do
+  'Hello'
 end
```

ではテストを実行しています。

```
bundle exec rpec
```

```
App
  レスポンスの精査
    /へのアクセス
      正常なレスポンスが返ること
      Helloと出力されること

Finished in 0.04242 seconds
2 examples, 0 failures
```

無事に通りましたね。次はテストコードのリファクタリングをしてみます。


# specのリファクタリング

今回は振る舞いは同じまま、コードの修正を行なってみました。```app.rb```のコードが単純なため```spec/app_spec```をリファクタリングしています。```git diff tdd_004..tdd_005```の実行結果です。

```diff
diff --git a/spec/app_spec.rb b/spec/app_spec.rb
index 076f412..1347ef9 100644
--- a/spec/app_spec.rb
+++ b/spec/app_spec.rb
@@ -10,11 +10,12 @@ describe "App" do
   describe "レスポンスの精査" do
     describe "/へのアクセス" do
       before { get '/' }
+      subject { last_response }
       it "正常なレスポンスが返ること" do
-        last_response.should be_ok
+        should be_ok
       end
       it "Helloと出力されること" do
-        last_response.body.should == "Hello"
+        subject.body.should == "Hello"
       end
     end
   end
```

現在テストしている主題(subject)を明確にしてみました。同じくテストを実行すると

```
bundle exec rpec
```

```
App
  レスポンスの精査
    /へのアクセス
      正常なレスポンスが返ること
      Helloと出力されること

Finished in 0.04653 seconds
2 examples, 0 failures
````

同じ結果が得られましたね。以上で、sinatraとrspecを使ったテスト駆動開発の体験が出来たと思います。どうでしたでしょうか？


# specのリファクタリング2

10年の月日が流れ、RSpecの構文が変わっていたので以下のように記述を更新してみました。

```diff
diff --git a/spec/app_spec.rb b/spec/app_spec.rb
index 1347ef9..5b3906c 100644
--- a/spec/app_spec.rb
+++ b/spec/app_spec.rb
@@ -12,10 +12,10 @@ describe "App" do
       before { get '/' }
       subject { last_response }
       it "正常なレスポンスが返ること" do
-        should be_ok
+        is_expected.to be_ok
       end
       it "Helloと出力されること" do
-        subject.body.should == "Hello"
+        expect(subject.body).to eq "Hello"
       end
     end
   end
```
