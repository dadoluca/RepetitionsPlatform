import { createApp } from "vue";
import App from "./App.vue";
import store from "./store";
import router from "./router";
import "./assets/css/nucleo-icons.css";
import "./assets/css/nucleo-svg.css";
import ArgonDashboard from "./argon-dashboard";
import VueCookies from 'vue-cookies';
// import VuejsDialog from 'vuejs-dialog';
// import 'vuejs-dialog/dist/vuejs-dialog.min.css';
 

const appInstance = createApp(App);
appInstance.use(store);
appInstance.use(router);
appInstance.use(ArgonDashboard);
appInstance.use(VueCookies);
// appInstance.use(VuejsDialog);
appInstance.mount("#app");