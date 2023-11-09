// previewImage.js
document.addEventListener("DOMContentLoaded", function () {
  // ファイルフィールドから選択された画像をプレビューする関数
  window.previewImage = function(input) {
    const preview = document.getElementById("avatar-preview");
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = function (e) {
        preview.src = e.target.result;
      };
      reader.readAsDataURL(input.files[0]);
    }
  }
});