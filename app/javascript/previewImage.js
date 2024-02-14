// previewImage.js
// document.addEventListener("DOMContentLoaded", function () {
//   // ファイルフィールドから選択された画像をプレビューする関数
//   window.previewImage = function(input) {
//     const preview = document.getElementById("preview");
//     if (input.files && input.files[0]) {
//       const reader = new FileReader();
//       reader.onload = function (e) {
//         preview.src = e.target.result;
//       };
//       reader.readAsDataURL(input.files[0]);
//     }
//   }
// });



document.addEventListener("DOMContentLoaded", function () {
  // ファイルフィールドから選択された画像をプレビューする関数
  window.previewImage = function(input) {
    const preview = document.getElementById("preview");
    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = function (e) {
        if (input.files[0].type === 'image/heic') {
          // HEIC画像を表示する前に変換する
          convertHeicToWebp(e.target.result, function(convertedDataUrl) {
            preview.src = convertedDataUrl;
          });
        } else {
          // HEIC以外の画像はそのまま表示
          preview.src = e.target.result;
        }
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  // HEIC画像をWebPに変換する関数
function convertHeicToWebp(heicDataUrl, callback) {
  const img = new Image();
  img.onload = function() {
    console.log('Image loaded');
    // Canvasを使ってWebPに変換
    const canvas = document.createElement('canvas');
    canvas.width = img.width;
    canvas.height = img.height;
    const ctx = canvas.getContext('2d');
    ctx.drawImage(img, 0, 0, img.width, img.height);
    const webpDataUrl = canvas.toDataURL('image/webp');
    callback(webpDataUrl);
  };
  img.onerror = function(e) {
    console.error('Image failed to load:', e);
    console.error('Image source:', img.src);
  };
  img.src = heicDataUrl;
}
});

// モーダルウィンドウ実装後
document.addEventListener("DOMContentLoaded", function () {
  // ファイルフィールドから選択された画像をプレビューする関数
  window.previewImage2 = function(input, catId) {
    const preview = document.getElementById("preview-"+ catId);
    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = function (e) {
        if (input.files[0].type === 'image/heic') {
          // HEIC画像を表示する前に変換する
          convertHeicToWebp(e.target.result, function(convertedDataUrl) {
            preview.src = convertedDataUrl;
          });
        } else {
          // HEIC以外の画像はそのまま表示
          preview.src = e.target.result;
        }
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  // HEIC画像をWebPに変換する関数
function convertHeicToWebp(heicDataUrl, callback) {
  const img = new Image();
  img.onload = function() {
    console.log('Image loaded');
    // Canvasを使ってWebPに変換
    const canvas = document.createElement('canvas');
    canvas.width = img.width;
    canvas.height = img.height;
    const ctx = canvas.getContext('2d');
    ctx.drawImage(img, 0, 0, img.width, img.height);
    const webpDataUrl = canvas.toDataURL('image/webp');
    callback(webpDataUrl);
  };
  img.onerror = function(e) {
    console.error('Image failed to load:', e);
    console.error('Image source:', img.src);
  };
  img.src = heicDataUrl;
}
});