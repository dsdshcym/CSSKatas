// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

import Alpine from "alpinejs"

window.Alpine = Alpine

import domtoimage from "dom-to-image"

customElements.define(
  "preview-container",
  class extends HTMLElement {
    set previewHTML(html) {
      this.shadowRoot.getElementById("preview").innerHTML = html
    }
    constructor() {
      super()

      const shadowRoot = this.attachShadow({ mode: "open" })
      shadowRoot.innerHTML = `<link href="https://unpkg.com/tailwindcss@^1.0/dist/tailwind.min.css" rel="stylesheet"> <div id="preview"></div>`
    }
  }
)

window.questionGenerator = function (initial_html, design) {
  let default_flash = ""
  return {
    flash: default_flash,
    html: initial_html,
    design: design,
    init() {
      return () => {
        this.$refs.design_preview.previewHTML = this.design
        this.$refs.solution_preview.previewHTML = this.html

        this.$watch("html", (value) => {
          this.$refs.solution_preview.previewHTML = this.html
        })
      }
    },
    resetFlash() {
      this.flash = default_flash
    },
    reset() {
      this.resetFlash()
      this.html = initial_html
    },
    toPixelData(dom) {
      var scale = 2
      return domtoimage.toPixelData(dom, {
        width: dom.clientWidth * scale,
        height: dom.clientHeight * scale,
        style: {
          transform: `scale(${scale})`,
          transformOrigin: "top left",
        },
      })
    },
    diff(dom1, dom2, successFn, failureFn) {
      let $this = this
      $this.toPixelData(dom1).then(function (domPixels1) {
        $this.toPixelData(dom2).then(function (domPixels2) {
          if (JSON.stringify(domPixels1) == JSON.stringify(domPixels2)) {
            successFn()
          } else {
            failureFn()
          }
        })
      })
    },
    check(dispatchFn) {
      var target = this.$refs.design_preview
      var work = this.$refs.solution_preview
      this.diff(
        target,
        work,
        () => {
          this.flash = "success"
        },
        () => {
          this.flash = "Oops, Preview doesn't match the Design."
        }
      )
    },
  }
}

Alpine.start()

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"

// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to)
      }
    },
  },
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", (info) => topbar.show())
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
