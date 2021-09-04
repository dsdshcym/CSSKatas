import domtoimage from "dom-to-image"
import { EditorState, EditorView, basicSetup } from "@codemirror/basic-setup"
import { html } from "@codemirror/lang-html"
import confetti from "canvas-confetti"

let preflight = () => {
  customElements.define(
    "preview-container",
    class extends HTMLElement {
      set previewHTML(html) {
        this.shadowRoot.getElementById("preview").innerHTML = html
      }
      constructor() {
        super()

        const shadowRoot = this.attachShadow({ mode: "open" })
        shadowRoot.innerHTML = `<link href="https://unpkg.com/tailwindcss@^2.0/dist/tailwind.min.css" rel="stylesheet"> <div id="preview"></div>`
      }
    }
  )
}

let build = (initial_html, design) => ({
  flash: "",
  status: "pending",
  congrat: false,
  html: initial_html,
  design: design,
  init() {
    this.$refs.design_preview.previewHTML = this.design
    this.$refs.solution_preview.previewHTML = this.html

    this.$watch("html", (value) => {
      this.$refs.solution_preview.previewHTML = value
    })

    window.editor_view = new EditorView({
      state: EditorState.create({
        doc: initial_html,
        extensions: [
          basicSetup,
          html(),
          EditorView.updateListener.of((update) => {
            if (update.docChanged) {
              this.html = update.state.doc.toString()
            }
          }),
        ],
      }),
      parent: document.querySelector("#editor"),
    })
  },
  resetFlash() {
    this.flash = ""
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
    $this.toPixelData(dom1).then(function(domPixels1) {
      $this.toPixelData(dom2).then(function(domPixels2) {
        if (JSON.stringify(domPixels1) == JSON.stringify(domPixels2)) {
          successFn()
        } else {
          failureFn()
        }
      })
    })
  },
  check() {
    this.status = "checking"
    var target = this.$refs.design_preview
    var work = this.$refs.solution_preview
    this.diff(
      target,
      work,
      () => {
        this.status = "passed"
        this.congrat = true
        confetti()
      },
      () => {
        this.status = "pending"
        this.flash = "Oops, Preview doesn't match the Design."
      }
    )
  },
})

export default { preflight, build }
