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
  }
}
