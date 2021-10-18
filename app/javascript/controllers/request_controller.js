import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="form"
export default class extends Controller {
  static targets  = ["error", "form"];
  static values   = { 
    target: String,
    action: { type: String, default: "replace" } 
  };

  connect() {
    this.target   = this.hasTargetValue && document.querySelector(this.targetValue);
    this.action   = this.hasActionValue && this.actionValue;
    this.actions  = [
      "afterbegin",
      "afterend",
      "beforebegin",
      "beforeend",
      "remove",
      "replace",
      "update",
    ];
    this.element.addEventListener("ajax:error", (event) =>
      this.handleError(event)
    );
    this.element.addEventListener("ajax:success", (event) =>
      this.handleSuccess(event)
    );
  }

  actionIsPermitted(action) {
    if (this.actions.indexOf(action) == -1) {
      throw `data-request-action-value="${action}" is not one of ${this.actions.join(", ")}`;
    } else {
      return true;
    }
  }

  clearForm() {
    this.hasFormTarget && this.formTarget.reset();
  }

  clearErrors() {
    this.hasErrorTarget && (this.errorTarget.innerHTML = "");
  }

  handleError(event) {
    const { response } = event.detail[2];

    this.errorTarget.innerHTML = response;
  }

  handleSuccess(event) {
    const { response } = event.detail[2];

    this.clearErrors();
    this.clearForm();
    this.actionIsPermitted(this.action) && this.updateTarget(this.action, response);
  }

  updateTarget(action, response) {
    switch(action) {
      case "remove":
        this.target.remove();
        break;
      case "replace":
        const parser = new DOMParser();
        const doc = parser.parseFromString(response, "text/html");
        this.target.replaceWith(doc.body.firstChild);
        break;        
      case "update":
        this.target.innerHTML = response;
        break;
      default:
        this.target.insertAdjacentHTML(this.action, response);
    }
  }
}