module.exports = {
  plugins: [require("daisyui")],
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  variants: {
    visibility: ['responsive', 'hover', 'focus', 'group-hover']
  },
  theme: {
    extend: {
      backgroundImage: theme => ({
        'custom': `url("${theme('image-url', 'cat-5830643_1920.jpg')}")`, // 画像のパスを指定
        'custom-mobile': `url("${theme('image-url', 'cat-5830643_1920のコピー.jpg')}")`,
      }),
    },
  },
}
