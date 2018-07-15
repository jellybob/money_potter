// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "pot", "form", "query" ]

  initialize() {
    this.formTarget.classList.remove("d-none");
    this.resetFilter();
  }

  resetFilter() {
    this.queryTarget.value = "";
    for (let pot of this.potTargets) { pot.classList.remove("d-none"); }
  }

  applyFilter(query) {
    for (let pot of this.potTargets) {
      if (pot.getAttribute("data-name").includes(query.toLowerCase())) {
        pot.classList.remove("d-none");
      } else {
        pot.classList.add("d-none");
      }
    }
  }

  search() {
    let query = this.queryTarget.value;
    if (query === '') {
      this.resetFilter();
    } else {
      this.applyFilter(query);
    }
  }
}

