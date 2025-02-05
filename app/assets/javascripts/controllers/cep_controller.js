import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

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

  validate() {
    const input = this.inputTarget;
    const cepPattern = /^\d{5}-?\d{3}$/;

    if (!cepPattern.test(input.value)) {
      input.classList.add("input-error");
    } else {
      input.classList.remove("input-error");
    }
  }
}