import { Controller } from "@hotwired/stimulus"

// Shows or hides the anime hosts. Lives on <body> so it reaches every dialogue
// and the footer toggle. The choice is kept in a cookie the server also reads.
export default class extends Controller {
  static targets = [ "toggle" ]
  static classes = [ "off" ]

  close(event) {
    event.currentTarget.closest(".dialogue").classList.add("dialogue--hidden")
  }

  hideAll() {
    this.#setHidden(true)
  }

  toggle() {
    this.#setHidden(!this.element.classList.contains(this.offClass))
  }

  #setHidden(hidden) {
    this.element.classList.toggle(this.offClass, hidden)
    document.cookie = `hosts_off=${hidden ? "1" : ""}; path=/; max-age=${hidden ? 31536000 : 0}; samesite=lax`

    if (this.hasToggleTarget) {
      this.toggleTarget.textContent = hidden ? "Show hosts" : "Hide hosts"
      this.toggleTarget.setAttribute("aria-pressed", hidden)
    }
  }
}
