# lesson.md の要約

## はじめに

このレッスンの目標について記述。

## 状態管理

モバイルアプリにおける状態管理について説明。

Flutter における状態管理は、ローカルストレージや API から取得した情報などを UI に反映するために行う。UI に反映するためには、取得した情報をローカルにキャッシュしたり、ユーザーの操作に応じて更新処理を行うなどする必要がある。

状態管理はモバイル開発における重要なトピックの一つで、昔から様々な手法やフレームワークが考案されてきた。MVVM や MVC などのアーキテクチャパターンがその一例。

## Riverpod

Riverpod の使い方を、コード例を示しながら説明。
Riverpod Generator を使った方法を主に説明し、Generator を使わない方法については軽く触れるだけに留める。

class-based provider と functional provider についてそれぞれ説明する。Riverpod Generator を使わなくても Provider を生成できることについても軽く触れる。

ref.read/watch について説明する。ref.watch で取得している Provider の値が変更されたときは、その変更が即座に Widget に反映され、再描画されることを説明する。

Future/StreamProvider について説明する。@riverpod アノテーションをつけた Class やメソッドの戻り値を Future にするだけでこれが実現可能であることを説明する。値を取得するときに AsyncValue になることを説明し、その使い方を解説する。
