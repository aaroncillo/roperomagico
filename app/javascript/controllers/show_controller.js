// app/javascript/controllers/show_controller.js
import { Controller } from 'stimulus';
import debounce from "debounce";

export default class extends Controller {
  connect() {
      document.addEventListener('DOMContentLoaded', function() {
        const filterButtons = document.querySelectorAll('.filter-button');
        const filterInputs = document.querySelectorAll('.filter-input');

        filterButtons.forEach((button, index) => {
          button.addEventListener('click', function() {
            filterInputs.forEach((input, inputIndex) => {
              if (inputIndex === index) {
                input.classList.toggle('hidden');
              } else {
                input.classList.add('hidden');
              }
            });
          });
        });
      });
  }
  initialize() {
    this.submit = debounce(this.submit.bind(this), 300);
  }
  submit() {
    this.element.requestSubmit();
  }
}
