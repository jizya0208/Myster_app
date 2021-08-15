// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery.raty.js
//= require jquery.jscroll.min.js
//= require infinite-scroll.pkgd.min
//= require_tree .
//= require Chart.bundle
//= require chartkick
//= require data-confirm-modal

/*global $*/
document.addEventListener("turbolinks:load", function(){
  $('.js-accordion-title').on('click', function () { /*クリックでコンテンツを開閉*/
    $(this).next().slideToggle(200);  
    $(this).toggleClass('open', 200); /*トグルに開いている際に限り、クラス名を追加*/
  });

  
  $(".js-accordion-title.accordion-title-#{parent_comment.id}").on('click', function () { /*クリックでコンテンツを開閉*/
    $(this).next().slideToggle(200);
  });
  
  var slider = "#slider"; // スライダー
  var thumbnailItem = "#thumbnail-list .thumbnail-item"; // サムネイル画像アイテム

  // サムネイル画像アイテムに data-index でindex番号を付与
  $(thumbnailItem).each(function(){
   var index = $(thumbnailItem).index(this);
   $(this).attr("data-index",index);
  });

  // スライダー初期化後、カレントのサムネイル画像にクラス「thumbnail-current」を付与
  $(slider).on('init',function(slick){
   var index = $(".slide-item .slick-slide .slick-current").attr("data-slick-index");
   $(thumbnailItem+'[data-index="'+index+'"]').addClass("thumbnail-current");
  });

  //slickスライダー初期化
  $(slider).slick({
    autoplay: true,
    arrows: false,
    fade: true,
    infinite: false
  });
  //サムネイル画像アイテムをクリックしたときにスライダー切り替え
  $(thumbnailItem).on('click',function(){
    var index = $(this).attr("data-index");
    $(slider).slick("slickGoTo",index,false);
  });

  //サムネイル画像のカレントを切り替え
  $(slider).on('beforeChange',function(event,slick, currentSlide,nextSlide){
    $(thumbnailItem).each(function(){
      $(this).removeClass("thumbnail-current");
    });
    $(thumbnailItem+'[data-index="'+nextSlide+'"]').addClass("thumbnail-current");
  });

  $('input[name="charge_option"]').change(function() {
    var val = $(this).val();         // 選択したvalue値を変数に格納
    if (val == 3) {                  // 金額入力のボタンを選択中は、テキストフォームへの入力可とする
        $("#textforscb3").prop('disabled', false);
    } else {
     $("#textforscb3").prop('disabled', true);
    }
  });

   // 画像選択時のプレビュー
  $('.question_article_image_field').on('change', function (e) {  //ユーザがフォーム(input要素)に変更を加えた時にイベント発火。eには、article_imageのデータが入っている状態
    if(e.target.files.length > 4){
        alert('一度に投稿できる画像は4枚までです。');
        $('.question_article_image_field').val = "";              // 4枚以上画像を選択された場合、ファイルをリセット。
        for( let i = 0; i < 4; i++) {
          $(`#prev_img_${i}`).attr('src', "");                    // ファイルリセットに伴いプレビュー初期化
        }
    } else {
      let reader = new Array(4);                                  //  4つまでデータ格納できる配列を生成。
        for( let i = 0; i < 4; i++) {
          $(`#prev_img_${i}`).attr('src', "");                    //  画像選択を上書きした時に、1回目より数が少なかったりすると画面上にプレビューが残るので初期化
        }
        for( let i = 0; i < e.target.files.length; i++) {         //  選択された画像の数だけ繰返し処理
          reader[i] = new FileReader();                           //  FileReaderオブジェクトを生成し、配列に追加。FileReaderは、BlobやFileが保有するバッファを非同期で読み取ることが出来る
          reader[i].onload = finisher(i,e);                       //  画像の読込が完了後、下記のfinisherイベント発火
          reader[i].readAsDataURL(e.target.files[i]);             //  readAsDataURLメソッドで、指定されたBlob又はFileのファイルの読込みとそのURL生成を行う。
          function finisher(i,e){                                 //  onloadは別関数で準備しないと繰返し処理内では使用できないので、関数を準備。
            return function(e){
            $(`#prev_img_${i}`).attr('src', e.target.result);     //  img要素のsrc属性の中身を置換する。e.target=イベントを発生させたオブジェクト。result属性=FileReaderの読取ったファイルが文字列として格納される
          };
        }
      }
    }
  });

  $('.share_article_image_field').on('change', function (e) { //ユーザがフォーム(input要素)に変更を加えた時にイベント発火。eには、article_imageのデータが入っている状態
    if(e.target.files.length > 4){
        alert('一度に投稿できる画像は4枚までです。');
        $('.share_article_image_field').val = "";                 // 4枚以上画像を選択された場合、ファイルをリセット。
        for( let i = 0; i < 4; i++) {
          $(`#prev_img_${i}`).attr('src', "");                    // ファイルリセットに伴いプレビュー初期化
        }
    } else {
      let reader = new Array(4);                                  //  4つまでデータ格納できる配列を生成。
        for( let i = 0; i < 4; i++) {
          $(`#prev_img_${i + 4}`).attr('src', "");                //  画像選択を上書きした時に、1回目より数が少なかったりすると画面上にプレビューが残るので初期化
        }

        for( let i = 0; i < e.target.files.length; i++) {         //  選択された画像の数だけ繰返し処理
          reader[i] = new FileReader();                           //  FileReaderオブジェクトを生成し、配列に追加。FileReaderは、BlobやFileが保有するバッファを非同期で読み取ることが出来る
          reader[i].onload = finisher(i,e);                       //  画像の読込が完了後、下記のfinisherイベント発火
          reader[i].readAsDataURL(e.target.files[i]);             //  readAsDataURLメソッドで、指定されたBlob又はFileのファイルの読込みとそのURL生成を行う。
          function finisher(i,e){                                 //  onloadは別関数で準備しないと繰返し処理内では使用できないので、関数を準備。
            return function(e){
            $(`#prev_img_${i + 4}`).attr('src', e.target.result); //  img要素のsrc属性の中身を置換する。e.target=イベントを発生させたオブジェクト。result属性=FileReaderの読取ったファイルが文字列として格納される。
          };
        }
      }
     }
  });

  // 無限スクロールの処理 => 切替タブを含む会員showページ用
  $(window).on('scroll', function() { //スクロールで発火
    var scrollHeight = $(document).height();                         // 画面全体の高さ
    var scrollPosition = $(window).height() + $(window).scrollTop(); // スクロールした位置
    if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {   // スクロールの位置が画面下部5%の範囲に該当するか
      $('.show > .jscroll').jscroll({                                // 選択されたtab-paneは."active show"クラスが付与されるので、これを利用し読み込んだ要素を追加する場所を特定する
        contentSelector: $('.show > .scroll-list').attr('tab'),      //  読み込む範囲を指定しつつ、 .show > .scroll-listにtabを追加(tabの中身はclass名）
        nextSelector: 'span.next:last a',                            // 次のページのリンクの場所
        loadingHtml: '読み込み中'
      });
    }
  });

  $('#scroll-list_articles').infiniteScroll({
    path: "nav.pagination  a[rel=next]",    // 次に読み込むページのURLの指定  kaminariのnext >のセレクタを指定
    append: ".infiniteScroll",              // 読み込んだ次ページの内容のうち、追加する要素の指定。
    hideNav: "nav.pagination",              // 非表示にするnavigationを指定する。
    history: false,                         // urlを変更し、履歴を残すか。 falseなら固定のurlになる
    scrollThreshold: false,                 // スクロールで自動で読み込むか。 falseなら読み込まない
    prefill: true,
    button: ".loadmore-btn",                // ページをロードするためのボタン要素の指定。
    status: ".page-load-status",            // 読み込み中や全部読み込んだ後に表示するもの指定。
  });
});



$(document).ajaxStop(function() {
  $('.js-accordion-title').on('click', function () { /*クリックでコンテンツを開閉*/
    $(this).next().slideToggle(200);  
    $(this).toggleClass('open', 200); /*トグルに開いている際に限り、クラス名を追加*/
  });
});



