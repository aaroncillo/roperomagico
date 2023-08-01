// app/javascript/controllers/show_controller.js
import { Controller } from 'stimulus';
import debounce from "debounce";

export default class extends Controller {
  initialize() {
    this.submit = debounce(this.submit.bind(this), 300);
  }
  submit() {
    this.element.requestSubmit();
  }
}
