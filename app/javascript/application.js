import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()

application.debug = false

lazyLoadControllersFrom("controllers", application)
