import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ ]

  connect() {
    this.element.classList.remove("was-validated");
    this.element.querySelector("#pot_id").focus();
  }

  submit(event) {
    let valid = this.element.checkValidity();
    if (!valid) {
      event.preventDefault();
      event.stopPropagation();

      for (let group of this.element.querySelectorAll(".form-group")) {
        let field = group.querySelector("input, select")
        if (field && field.validationMessage) {
          let target = group.querySelector(".invalid-feedback");
          group.classList.add("with-error");
          console.log({ target, message: field.validationMessage });
          target.innerHTML = field.validationMessage;
        } else {
          group.classList.remove("with-error");
        }
      }
    }

    this.element.classList.add("was-validated");
  }
}

