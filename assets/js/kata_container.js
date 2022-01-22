import domtoimage from "dom-to-image"
import { EditorState, EditorView, basicSetup } from "@codemirror/basic-setup"
import { html } from "@codemirror/lang-html"
import confetti from "canvas-confetti"

let build = (initial_html, design) => ({
  error: false,
  status: "pending",
  html: initial_html,
  design: design,
  init() {
    this.$watch("html", (value) => {
      this.$refs.solution_preview.contentWindow.document.body.innerHTML = value
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
  resetError() {
    this.error = false
  },
  setEditorValue(string) {
    window.editor_view.dispatch({
      changes: {
        from: 0,
        to: window.editor_view.state.doc.length,
        insert: string
      }
    })
  },
  resetSolution() {
    this.setEditorValue(initial_html)
  },
  reset() {
    this.resetError()
    this.resetSolution()
  },
  displayError() {
    this.error = true

    if (this.timeout) {
      clearTimeout(this.timeout)
    }
    this.timeout = setTimeout(() => this.resetError(), 3000)
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
    var target = this.$refs.design_preview.contentWindow.document.body
    var work = this.$refs.solution_preview.contentWindow.document.body
    this.diff(
      target,
      work,
      () => {
        this.status = "passed"
        confetti()
      },
      () => {
        this.status = "pending"
        this.displayError()
      }
    )
  },
})

export default { build }
