function clear_email_signup_field(field) {
  const old_value = field.value;
  field.value = "";

  function blur_handler(evt) {
    field.value = field.value || old_value;
    field.removeEventListener("blur", blur_handler);
  }

  field.addEventListener("blur", blur_handler);
}

const get_toolbar = () => document.getElementById("toolbar");

const max_scroll_height = () => document.body.scrollHeight;

const reveal_bottom_nav = function () {
  const toolbar = get_toolbar();
  if (!toolbar) return;
  const y_remaining = max_scroll_height() - (window.scrollY + window.innerHeight);
  const invisible_threshold = body.clientWidth * .35;
  const visible_threshold = body.clientWidth * .100;
  const new_opacity =
    y_remaining >= invisible_threshold ? 0
      : y_remaining <= visible_threshold ? 1
        : Math.pow(((invisible_threshold - y_remaining)
          / (invisible_threshold - visible_threshold)), 2);
  toolbar.style.opacity = new_opacity;
  toolbar.classList[new_opacity > 0 ? "add" : "remove"]("visible");
};

window.addEventListener("load", event => {
  document.getElementById("content").addEventListener("copy", (event) => {
    event.preventDefault();
    const selectedText = window.getSelection().toString();
    event.clipboardData.setData("text/plain", selectedText.replace(/\u00AD/g, ""));
  });
});

window.addEventListener("resize", reveal_bottom_nav);
window.addEventListener("scroll", reveal_bottom_nav);
window.addEventListener("load", reveal_bottom_nav);
