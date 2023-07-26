// app/javascript/controllers/daterangepicker_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    new DateRangePicker(this.element)
  }
}
