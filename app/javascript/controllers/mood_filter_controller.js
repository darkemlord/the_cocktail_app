import { Controller } from "@hotwired/stimulus"

// Lives on the cocktails <turbo-frame>. If the clicked station still has focus when
// Turbo swaps the frame, Chrome loses it mid-render and the page jumps up.
// Drop focus before the swap and hand it to the new active station afterwards.
export default class extends Controller {
  static targets = [ "stations" ]

  connect() {
    this.#centerActiveStation()
  }

  releaseFocus() {
    this.hadFocus = this.element.contains(document.activeElement)
    if (this.hadFocus) document.activeElement.blur()
  }

  restoreFocus() {
    this.#centerActiveStation()
    if (!this.hadFocus) return

    this.#activeStation?.focus({ preventScroll: true })
    this.hadFocus = false
  }

  get #activeStation() {
    return this.element.querySelector('.mood-tuner__station[aria-current="page"]')
  }

  // Scrolls only the dial sideways. scrollIntoView would also scroll the page
  // to bring the dial into view, which is the kind of jump this controller avoids.
  #centerActiveStation() {
    const station = this.#activeStation
    if (!station || !this.hasStationsTarget) return

    const dial = this.stationsTarget.getBoundingClientRect()
    const active = station.getBoundingClientRect()
    this.stationsTarget.scrollLeft += (active.left + active.width / 2) - (dial.left + dial.width / 2)
  }
}
