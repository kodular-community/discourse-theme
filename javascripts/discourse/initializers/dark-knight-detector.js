import { withPluginApi } from "discourse/lib/plugin-api";


export default {
    name: "kodular-dark-knight-detector",
    initialize() {
      withPluginApi("0.10.1", () => {
        let themeColor = document.querySelector('meta[name="theme-color"]').content
        if(themeColor === "#111111") {
            document.body.classList.add("dark-knight")
        }
      });
    },
  };