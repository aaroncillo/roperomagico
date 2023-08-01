import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["opens"]

  mostrar(){
    this.opensTarget.classList.remove("hidden")
    // Obtener el formulario
    const form = this.element.closest("form");
    // Enviar el formulario como Turbo Stream
    Turbo.visit(form.action, { action: form.method, body: new FormData(form) });
  }

}
