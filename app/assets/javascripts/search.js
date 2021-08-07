/*global $*/
document.addEventListener("turbolinks:load", function(){
  $(function() {
      const searchResult = $('.result ul'); //検索候補表示位置のセレクタ

  　　　// データがあった場合に呼ばれる関数。jsでテンプレートリテラルを使用するには``内に${}で囲って記述する。letはブロック変数。
      function builtHTML(data){
        let html = `
        <li>
          <a href="/articles/search?utf8=✓&keyword=${data.title}" data-method="get">${data.title}</a>
        </li>
        `
        searchResult.append(html);
      }

      // 該当するデータがなかった時に呼ばれる関数
      function NoResult(message){
        let html = `
        <li>${message}</li>
        `
        searchResult.append(html);
      }

      $("#search-form").on("keyup", function() {  // .search-formをkeyup(キーボードから指あげた時)に
        let input = $("#search-form").val();      // 検索フォームに入力されている値をval()で取得し、inputに代入
        $.ajax({                                  // 非同期でサーバーに要求データ（リクエスト）を送る
          type: 'GET',                            // HTTPメソッドを指定
          url: '/articles/search',                // type(GET)でアクセスしたいurl
          data: { keyword: input },               // コントローラーに送るデータを指定 => キー(:keyword)と値(input)のペアをセット
          dataType: 'json'                        // 結果をjson形式で受け取る。他のデータ型にはtextなどがある。
          })
          .done(function(articles) {              // .doneはjbuilderから送られてきた情報を受け取る役割
            $(searchResult).empty();              // 検索候補表示は入力値が変わるたびにリセットさせたいので都度空にする
            if (articles.length > 0) {            // 1つでもあれば
              articles.forEach(function(article){ // 繰り返し処理を行い、
                builtHTML(article)                // そのレコードをhtmlに表示する
              });
            }
            else {
              NoResult("一致する投稿タイトルはありません");
            }
          })
          .fail(function(){
            alert('検索に失敗しました');
        })
      });
    });
  });