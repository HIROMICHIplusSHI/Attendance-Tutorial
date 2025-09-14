// app/javascript/controllers/dropdown_controller.js
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['menu'];

  toggle(event) {
    event.preventDefault();
    this.menuTarget.classList.toggle('show');
  }

  // クリック外で閉じる
  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove('show');
    }
  }

  connect() {
    // ドロップダウン外クリックで閉じる
    document.addEventListener('click', this.hide.bind(this));
  }

  disconnect() {
    document.removeEventListener('click', this.hide.bind(this));
  }
}
