import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "body", "name", "budget", "submit" ]

  connect() {
    this.bodyTarget.classList.add("d-none")
    this.bodyTarget.classList.add("d-md-block");
    this.budgetTarget.value = '';
  }

  toggleForm() {
    this.bodyTarget.classList.toggle("d-none");
    this.nameTarget.focus();
    this.submitTarget.scrollIntoView();
  }

  submit() {
    let form = this.element.querySelector("form");
    let valid = form.checkValidity();
    if (!valid) {
      event.preventDefault();
      event.stopPropagation();

      for (let group of form.querySelectorAll(".form-group")) {
        let field = group.querySelector("input, select")
        if (field && field.validationMessage) {
          let target = group.querySelector(".invalid-feedback");
          group.classList.add("with-error");
          target.innerHTML = field.validationMessage;
        } else {
          group.classList.remove("with-error");
        }
      }

      form.classList.add("was-validated");
    }
  }
}
