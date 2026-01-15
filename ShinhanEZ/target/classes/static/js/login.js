/**
 * ShinhanEZ Login Module
 * - FloatingInput: 플로팅 라벨 + X버튼 클리어
 * - LoginForm: 버튼 활성화 로직
 * - QRTimer: QR코드 타이머 + 만료 처리
 * - ToggleSwitch: IP보안 토글
 * 
 * 탭 전환은 CSS Only (radio:checked 기반)
 */

(function () {
  "use strict";

  /* ===== FloatingInput 클래스 ===== */
  class FloatingInput {
    constructor(container) {
      this.container = container;
      this.input = container.querySelector('input[type="text"], input[type="password"]');
      this.clearBtn = container.querySelector(".btn_clear");

      if (!this.input) return;
      this._init();
    }

    _init() {
      // 포커스 이벤트
      this.input.addEventListener("focus", () => {
        this.container.classList.add("is-focused");
        this._updateValue();
      });

      // 블러 이벤트
      this.input.addEventListener("blur", () => {
        this.container.classList.remove("is-focused");
        this._updateValue();
      });

      // 입력 이벤트
      this.input.addEventListener("input", () => {
        this._updateValue();
        this._triggerChange();
      });

      // X 버튼 클릭
      if (this.clearBtn) {
        this.clearBtn.addEventListener("click", (e) => {
          e.preventDefault();
          this.clear();
          this.input.focus();
        });
      }

      // 초기 상태 체크
      this._updateValue();
    }

    _updateValue() {
      if (this.input.value.length > 0) {
        this.container.classList.add("has-value");
      } else {
        this.container.classList.remove("has-value");
      }
    }

    _triggerChange() {
      // 커스텀 이벤트 발생 (폼 검증용)
      this.input.dispatchEvent(new CustomEvent("valueChange", { bubbles: true }));
    }

    clear() {
      this.input.value = "";
      this._updateValue();
      this._triggerChange();
    }

    getValue() {
      return this.input.value;
    }
  }

  /* ===== LoginForm 클래스 ===== */
  class LoginForm {
    constructor(form, options = {}) {
      this.form = form;
      this.submitBtn = form.querySelector(options.submitBtn || 'button[type="submit"]');
      this.requiredInputs = form.querySelectorAll(options.requiredInputs || ".input_item input");

      if (!this.submitBtn || !this.requiredInputs.length) return;
      this._init();
    }

    _init() {
      // valueChange 이벤트 리스닝
      this.form.addEventListener("valueChange", () => {
        this._validateForm();
      });

      // input 이벤트도 리스닝 (호환성)
      this.requiredInputs.forEach((input) => {
        input.addEventListener("input", () => {
          this._validateForm();
        });
      });

      // 폼 제출
      this.form.addEventListener("submit", (e) => {
        e.preventDefault();
        this._handleSubmit();
      });

      // 초기 검증
      this._validateForm();
    }

    _validateForm() {
      const allFilled = Array.from(this.requiredInputs).every(
        (input) => input.value.trim().length > 0
      );

      this.submitBtn.disabled = !allFilled;
    }

    _handleSubmit() {
      if (this.submitBtn.disabled) return;

      // 로그인 로직 (실제 구현 시 수정)
      const formData = {};
      this.requiredInputs.forEach((input) => {
        formData[input.name] = input.value;
      });

      console.log("로그인 시도:", formData);
      this.form.submit();
    }
  }

  /* ===== QRTimer 클래스 ===== */
  class QRTimer {
    constructor(options = {}) {
      this.duration = options.duration || 180; // 기본 3분 (180초)
      this.warningTime = options.warningTime || 30; // 30초 이하 경고
      this.remainingTime = this.duration;
      this.timerId = null;
      this.isExpired = false;

      // DOM 요소
      this.timerEl = document.getElementById("qrRemain");
      this.timerWrap = document.getElementById("qrTime");
      this.expiredEl = document.getElementById("qrExpired");
      this.qrBox = document.getElementById("qrBox");
      this.refreshBtn = document.getElementById("btnQrRefresh");

      // QR 탭 radio
      this.qrRadio = document.getElementById("chk_qr");

      if (!this.timerEl) return;
      this._init();
    }

    _init() {
      // 새로고침 버튼 클릭
      if (this.refreshBtn) {
        this.refreshBtn.addEventListener("click", () => {
          this.refresh();
        });
      }

      // QR 탭 선택 시 타이머 시작
      if (this.qrRadio) {
        this.qrRadio.addEventListener("change", () => {
          if (this.qrRadio.checked) {
            this.start();
          }
        });

        // 다른 탭 선택 시 타이머 정지
        document.querySelectorAll('.menu_chk').forEach(radio => {
          if (radio.id !== 'chk_qr') {
            radio.addEventListener("change", () => {
              if (radio.checked) {
                this.pause();
              }
            });
          }
        });
      }

      // 초기 표시
      this._updateDisplay();
    }

    start() {
      if (this.timerId) return; // 이미 실행 중이면 무시

      this.timerId = setInterval(() => {
        this.remainingTime--;
        this._updateDisplay();

        if (this.remainingTime <= 0) {
          this._expire();
        }
      }, 1000);
    }

    pause() {
      if (this.timerId) {
        clearInterval(this.timerId);
        this.timerId = null;
      }
    }

    stop() {
      this.pause();
      this.remainingTime = this.duration;
      this._updateDisplay();
    }

    refresh() {
      this.pause();
      this.remainingTime = this.duration;
      this.isExpired = false;

      // UI 초기화
      this._updateDisplay();
      this._hideExpired();

      // QR 이미지 복구
      if (this.qrBox) {
        this.qrBox.classList.remove("is-expired");
      }

      // 타이머 다시 시작
      this.start();

      console.log("QR 새로고침 완료");
      // TODO: 실제로는 서버에서 새 QR 코드 받아와야 함
    }

    _updateDisplay() {
      const minutes = Math.floor(this.remainingTime / 60);
      const seconds = this.remainingTime % 60;
      const timeStr = `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;

      if (this.timerEl) {
        this.timerEl.textContent = timeStr;
      }

      // 경고 상태 (30초 이하)
      if (this.timerWrap) {
        this.timerWrap.classList.remove("is-warning", "is-expired");

        if (this.remainingTime <= 0) {
          this.timerWrap.classList.add("is-expired");
        } else if (this.remainingTime <= this.warningTime) {
          this.timerWrap.classList.add("is-warning");
        }
      }
    }

    _expire() {
      this.pause();
      this.isExpired = true;

      // 만료 메시지 표시
      this._showExpired();

      // QR 이미지 흐리게
      if (this.qrBox) {
        this.qrBox.classList.add("is-expired");
      }

      console.log("QR 만료됨");
    }

    _showExpired() {
      if (this.expiredEl) {
        this.expiredEl.classList.add("is-show");
      }
    }

    _hideExpired() {
      if (this.expiredEl) {
        this.expiredEl.classList.remove("is-show");
      }
    }
  }

  /* ===== ToggleSwitch 클래스 ===== */
  class ToggleSwitch {
    constructor(element, options = {}) {
      this.element = element;
      this.input = element.querySelector('input[type="checkbox"]');
      this.onChange = options.onChange || null;

      if (!this.input) return;
      this._init();
    }

    _init() {
      this.input.addEventListener("change", () => {
        const isOn = this.input.checked;
        console.log("IP보안:", isOn ? "ON" : "OFF");

        if (this.onChange) {
          this.onChange(isOn);
        }
      });
    }

    isOn() {
      return this.input.checked;
    }

    setOn(value) {
      this.input.checked = value;
    }
  }

  /* ===== 초기화 ===== */
  function init() {
    // 플로팅 인풋 초기화
    document.querySelectorAll(".input_item").forEach((item) => {
      new FloatingInput(item);
    });

    // ID 로그인 폼 초기화
    const panelId = document.getElementById("panel_id");
    if (panelId) {
      new LoginForm(panelId, {
        submitBtn: "#btnLoginId",
        requiredInputs: "#id, #pw",
      });
    }

    // 일회용 번호 폼 초기화
    const panelNum = document.getElementById("panel_num");
    if (panelNum) {
      new LoginForm(panelNum, {
        submitBtn: "#btnLoginOnce",
        requiredInputs: "#once",
      });
    }

    // QR 타이머 초기화
    new QRTimer({
      duration: 180, // 3분
      warningTime: 30, // 30초 이하 경고
    });

    // IP보안 토글 초기화
    const ipToggle = document.querySelector(".toggle_switch");
    if (ipToggle) {
      new ToggleSwitch(ipToggle, {
        onChange: (isOn) => {
          // IP보안 상태 변경 시 처리
          // TODO: 실제 IP보안 API 호출
        },
      });
    }
  }

  // DOM 로드 후 실행
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
