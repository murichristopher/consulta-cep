// app/javascript/controllers/cep_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "skeleton", "result"]

  format(event) {
    const input = event.target;
    let digits = input.value.replace(/\D/g, '');

    if (digits.length > 8) digits = digits.substring(0, 8);
    if (digits.length > 5) {
      input.value = `${digits.slice(0, 5)}-${digits.slice(5)}`;
    } else {
      input.value = digits;
    }
  }

  showLoading() {
    this.resultTargets.forEach(target => target.classList.add("hidden"));
    this.skeletonTarget.classList.remove("hidden");
  }
}