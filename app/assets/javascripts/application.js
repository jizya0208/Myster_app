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
//= require_tree .
//= require Chart.bundle
//= require chartkick
//= require data-confirm-modal

/*global $*/
document.addEventListener("turbolinks:load", function(){
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

  // 無限スクロールの処理 　上はindexページ用、下は切替タブを含む会員showページ用。
  $(window).on('scroll', function() {
    var scrollHeight = $(document).height();
    var scrollPosition = $(window).height() + $(window).scrollTop();
    if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
      $('#scroll-list_articles').jscroll({
        contentSelector: '.scroll-list',
        nextSelector: 'span.next:last a',
        loadingHtml: '読み込み中'
      });
    }
  });
  $(window).on('scroll', function() { //スクロールで発火
    var scrollHeight = $(document).height();                         // 画面全体の高さ
    var scrollPosition = $(window).height() + $(window).scrollTop(); // スクロールした位置
    if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {   // スクロールの位置が画面下部5%の範囲に該当するか
      $('.show > .jscroll').jscroll({                                // 選択されたtab-paneは."active show"クラスが付与されるので、それで特定する
        contentSelector: $('.show > .scroll-list').attr('tab'),      // 読み込んだ要素を追加する場所 = .show > .scroll-listにtabを追加(tabの中身はclass名）
        nextSelector: 'span.next:last a',                            // 次のページのリンクの場所
        loadingHtml: '読み込み中'
      });
    }
  });
});