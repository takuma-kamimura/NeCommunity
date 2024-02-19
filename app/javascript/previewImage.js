import heic2any from "heic2any";

document.addEventListener("DOMContentLoaded", function () {
  // ファイルフィールドから選択された画像をプレビューする関数
  window.previewImage = async function (input) {
    const preview = document.getElementById("preview");
    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = async function (e) {
        if (input.files[0].type === "image/heic") {
          // HEIC画像を表示する前にjpegへ変換する
          const heicBlob = input.files[0]; // HEIC形式のBlobデータ
          // awaitキーワードを使用し、heic2any関数の実行結果をjpegBlobに取得
          const jpegBlob = await heic2any({ blob: heicBlob, toType: "image/jpeg" });
          preview.src = URL.createObjectURL(jpegBlob);
        } else {
          // HEIC以外の画像はそのまま表示
          preview.src = e.target.result;
        }
      };
      reader.readAsDataURL(input.files[0]);
    }
  };
});

// モーダルウィンドウ実装後
document.addEventListener("DOMContentLoaded", function () {
  // ファイルフィールドから選択された画像をプレビューする関数
  window.previewImage2 = async function (input, catId) {
    const preview = document.getElementById("preview-" + catId);
    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = async function (e) {
        if (input.files[0].type === "image/heic") {
         // HEIC画像を表示する前にjpegへ変換する
         const heicBlob = input.files[0]; // HEIC形式のBlobデータ
         // awaitキーワードを使用し、heic2any関数の実行結果をjpegBlobに取得
         const jpegBlob = await heic2any({ blob: heicBlob, toType: "image/jpeg" });
         preview.src = URL.createObjectURL(jpegBlob);
        } else {
          // HEIC以外の画像はそのまま表示
          preview.src = e.target.result;
        }
      };

      reader.readAsDataURL(input.files[0]);
    }
  };
});
