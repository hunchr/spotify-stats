import { Controller } from "@hotwired/stimulus"

export default class InfiniteScrollController extends Controller {
  static observer = new IntersectionObserver(([entry], observer) => {
    if (entry.isIntersecting) {
      const url = new URL(window.location)
      const { target } = entry

      observer.unobserve(target)
      url.searchParams.set("page", Number(target.dataset.page) + 1)

      fetch(url)
        .then((res) => res.text())
        .then((html) => {
          const table = document.createElement("div")

          table.innerHTML = html
          target.parentElement.append(...table.querySelectorAll("tbody tr"))
        })
    }
  })

  connect = () => {
    InfiniteScrollController.observer.observe(this.element)
  }
}
