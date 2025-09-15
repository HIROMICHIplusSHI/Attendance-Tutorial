import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    // モーダルが表示された時に背景を追加（少し遅延させる）
    setTimeout(() => {
      this.addBackdrop();
    }, 50);
  }

  disconnect() {
    // モーダルが削除された時に背景も削除
    this.removeBackdrop();
  }

  // 背景（オーバーレイ）を追加
  addBackdrop() {
    // 既存のbackdropがないかチェック
    if (document.getElementById('modal-backdrop')) {
      console.log('Backdrop already exists');
      return;
    }
    
    const backdrop = document.createElement('div');
    backdrop.className = 'modal-backdrop';
    backdrop.id = 'modal-backdrop';
    document.body.appendChild(backdrop);
    console.log('Backdrop added:', backdrop);
  }

  // 背景を削除
  removeBackdrop() {
    const backdrop = document.getElementById('modal-backdrop');
    if (backdrop) {
      backdrop.remove();
    }
  }

  // フォームが送信されたときに呼ばれるメソッド
  submit(event) {
    const flashContainer = document.getElementById('flash');
    if (flashContainer) {
      flashContainer.innerHTML = '';
      flashContainer.className = '';
    }
    this.close();
  }

  // モーダルを閉じるメソッド
  close() {
    this.removeBackdrop(); // 背景も削除
    this.element.remove();
  }
}
