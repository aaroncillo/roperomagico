import { Controller } from 'stimulus';
import debounce from "debounce";

export default class extends Controller {
  static targets = ['filterButton', 'filterInput', 'phoneFilterInput', 'phoneFilterButton', 'RutFilterInput', 'RutFilterButton'];

  initialize() {
    this.submit = debounce(this.submit.bind(this), 300);
  }

  toggleFilterInput(event) {
    const index = this.filterButtonTargets.indexOf(event.target);
    this.filterInputTargets[index].classList.toggle('hidden');
  }

  togglePhoneFilterInput(event) {
    const index = this.phoneFilterButtonTargets.indexOf(event.target);
    this.phoneFilterInputTargets[index].classList.toggle('hidden');
  }

  toggleRutFilterInput(event) {
    const index = this.RutFilterButtonTargets.indexOf(event.target);
    this.RutFilterInputTargets[index].classList.toggle('hidden');
  }

  submit() {
    this.element.requestSubmit();
  }
}
