const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex", "../katas/**/*.html", "../katas/**/*.md"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
