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
    this.setHidden(false, this.formTarget);
    this.resetFilter();
  }

  resetFilter() {
    this.queryTarget.value = "";
    for (let pot of this.potTargets) { this.setHidden(false, pot); }
  }

  applyFilter(query) {
    let nameMatcher = query.toLowerCase();

    for (let pot of this.potTargets) {
      let name = pot.getAttribute("data-name");
      let match = name.includes(nameMatcher);

      this.setHidden(!match, pot);
    }
  }

  search() {
    let query = this.queryTarget.value.trim();
    if (query.length == 0) {
      this.resetFilter();
    } else {
      this.applyFilter(query);
    }
  }

  setHidden(hidden, element) {
    let classes = element.classList;
    hidden ? classes.add("d-none") : classes.remove("d-none");
  }
}

