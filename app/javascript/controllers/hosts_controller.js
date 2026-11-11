import { Controller } from "@hotwired/stimulus"

// Shows or hides the anime hosts. Lives on <body> so it reaches every dialogue
// and the footer toggle. The choice is kept in a cookie the server also reads.
export default class extends Controller {
  static targets = [ "toggle" ]
  static classes = [ "off" ]

  // Turbo swaps in a cached <body> on Back, which may predate the last toggle.
  // The cookie is the source of truth, so re-apply it whenever the body connects.
  connect() {
    this.#render(document.cookie.split("; ").includes("hosts_off=1"))
  }

  close(event) {
    event.currentTarget.closest(".dialogue").classList.add("dialogue--hidden")
  }

  // Closing with × only lasts for this visit. Runs before Turbo caches the page,
  // so going Back doesn't restore a snapshot with the dialogue still closed.
  reopenDialogues() {
    this.element.querySelectorAll(".dialogue--hidden").forEach((dialogue) => {
      dialogue.classList.remove("dialogue--hidden")
    })
  }

  hideAll() {
    this.#setHidden(true)
  }

  toggle() {
    this.#setHidden(!this.element.classList.contains(this.offClass))
  }

  #setHidden(hidden) {
    if (!hidden) this.reopenDialogues()
    document.cookie = `hosts_off=${hidden ? "1" : ""}; path=/; max-age=${hidden ? 31536000 : 0}; samesite=lax`
    this.#render(hidden)
  }

  #render(hidden) {
    this.element.classList.toggle(this.offClass, hidden)

    if (this.hasToggleTarget) {
      this.toggleTarget.textContent = hidden ? "Show hosts" : "Hide hosts"
      this.toggleTarget.setAttribute("aria-pressed", hidden)
    }
  }
}
