import { Controller } from "@hotwired/stimulus"

const intro = "Get started with Stimulus. Click Get next quote."
const quotes = [
  "Mrs. Pecock was a man?! [slap]",
  "It's called a cruel irony, Kronk.",
  "Give him a sedagive!",
  "Ray, when someone asks if you're a god, you say YES!",
  "You like me because I'm a scoundrel. There aren't enough scoundrels in your life.",
  "Double the taxes! Triple the taxes! Squeeze every last drop out of those insolent, musical peasants."
]

export default class extends Controller {
  static targets = ["content", "remaining", "nextButton", "resetButton"]
  connect() {
    this.reset()
  }

  nextQuote() {
    this.contentTarget.textContent = this.currentQuotes.shift()
    this.processContent()
  }

  reset() {
    this.currentQuotes = Array.from(quotes)
    this.contentTarget.textContent = intro
    this.processContent()
  }

  processContent() {
    this.remainingTarget.textContent = this.setRemainingText()
    this.resetButtonTarget.disabled = this.currentQuotes.length === quotes.length
    this.nextButtonTarget.disabled = this.currentQuotes.length === 0
  }

  setRemainingText() {
    const quoteLength = this.currentQuotes.length
    const quotesPluralized = quoteLength === 1 ? "quote" : "quotes"
    const toBe = quoteLength === 1 ? "is" : "are"
    const clickReset = quoteLength === 0 ? ' Click reset to try again.' : ''
    return `There ${toBe} ${this.currentQuotes.length} ${quotesPluralized} remaining.${clickReset}`
  }
}
