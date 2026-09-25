/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#903f00",
        "primary-container": "#b45309", // Terracotta #B45309
        "on-primary": "#ffffff",
        "on-primary-container": "#fff1eb",
        "primary-fixed": "#ffdbca",
        "primary-fixed-dim": "#ffb68e",
        "on-primary-fixed": "#331200",

        secondary: "#ac3400",
        "secondary-container": "#c2410c", // Rust-red #C2410C
        "on-secondary": "#ffffff",
        "on-secondary-container": "#5d1900",
        "secondary-fixed": "#ffdbd0",
        "secondary-fixed-dim": "#ffb59d",

        tertiary: "#396200",
        "tertiary-container": "#4d7c0f", // Olive green #4D7C0F
        "on-tertiary": "#ffffff",
        "on-tertiary-container": "#dfffb7",
        "tertiary-fixed": "#bbf37c",
        "tertiary-fixed-dim": "#a0d663",

        background: "#fdf9f3", // Warm cream neutral #FAF6F0
        surface: "#fdf9f3",
        "surface-bright": "#fdf9f3",
        "surface-dim": "#dddad4",
        "surface-container-lowest": "#ffffff",
        "surface-container-low": "#f7f3ed",
        "surface-container": "#f1ede7",
        "surface-container-high": "#ebe8e2",
        "surface-container-highest": "#e6e2dc",
        "surface-variant": "#e6e2dc",

        "on-background": "#1c1c18",
        "on-surface": "#1c1c18",
        "on-surface-variant": "#564338",

        outline: "#897267",
        "outline-variant": "#ddc1b3",
        "line-hairline": "#e5ddd0",
        "line-focused": "#d6c7b2",

        error: "#ba1a1a",
        "on-error": "#ffffff",
        "error-container": "#ffdad6",
        "on-error-container": "#93000a",
      },
      fontFamily: {
        headline: ["Literata", "serif"],
        body: ["Karla", "sans-serif"],
        serif: ["Literata", "serif"],
        sans: ["Karla", "sans-serif"],
      },
      borderRadius: {
        DEFAULT: "0.5rem",
        sm: "0.25rem",
        md: "0.5rem",
        lg: "0.75rem",
        xl: "1rem",
        "2xl": "1.25rem",
        "3xl": "1.5rem",
        full: "9999px",
      },
    },
  },
  plugins: [],
}
