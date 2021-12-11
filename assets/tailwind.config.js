const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web/**/*.*ex",
    "../tracks/**/*.html",
    "../tracks/**/*.md"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
