  document.addEventListener('DOMContentLoaded', function () {
    const button = document.querySelector('.relative button');
    const menu = document.querySelector('.relative .absolute');

    button.addEventListener('click', function () {
      menu.classList.toggle('hidden');
    });

    // メニュー外をクリックしたら非表示にする
    document.addEventListener('click', function (event) {
      if (!button.contains(event.target) && !menu.contains(event.target)) {
        menu.classList.add('hidden');
      }
    });
  });
