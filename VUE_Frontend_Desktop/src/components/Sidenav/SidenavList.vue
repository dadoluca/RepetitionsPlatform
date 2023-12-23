<template>
  <div
    class="collapse navbar-collapse w-auto h-auto h-100"
    id="sidenav-collapse-main"
  >
    <ul class="navbar-nav">
      <!-- <li class="nav-item">
        <sidenav-item
          url="/dashboard-default"
          :class="getRoute() === 'dashboard-default' ? 'active' : ''"
          :navText="this.$store.state.isRTL ? 'لوحة القيادة' : 'Dashboard'"
        >
          <template v-slot:icon>
            <i class="ni ni-tv-2 text-primary text-sm opacity-10"></i>
          </template>
        </sidenav-item>
      </li> -->
      <!-- <li class="nav-item">
        <sidenav-item
          url="/tables"
          :class="getRoute() === 'tables' ? 'active' : ''"
          :navText="this.$store.state.isRTL ? 'الجداول' : 'Tables'"
        >
          <template v-slot:icon>
            <i
              class="ni ni-calendar-grid-58 text-warning text-sm opacity-10"
            ></i>
          </template>
        </sidenav-item>
      </li> -->
      <!-- [ -->
      <li class="nav-item">
        <sidenav-item
          url="/Courses"
          :class="getRoute() === 'courses' ? 'active' : ''"
          :navText="'Courses'"
        >
          <template v-slot:icon>
            <i
              class="ni ni-book-bookmark text-warning text-sm opacity-10"
            ></i>
          </template>
        </sidenav-item>
      </li>
      <li class="nav-item">
        <sidenav-item
          url="/Teachers"
          :class="getRoute() === 'teachers' ? 'active' : ''"
          :navText="'Teachers'"
        >
          <template v-slot:icon>
            <i
              class="ni ni-hat-3 text-info text-sm opacity-10"
            ></i>
          </template>
        </sidenav-item>
      </li>
      <li class="nav-item" v-if="this.$store.state.role == 1">
        <sidenav-item
          url="/user-repetitions"
          :class="getRoute() === 'user-repetitions' ? 'active' : ''"
          :navText="'My Lessons'"
        >
          <template v-slot:icon>
            <i
              class="ni ni-calendar-grid-58 text-warning text-sm opacity-10"
            ></i>
          </template>
        </sidenav-item>
      </li>
      <li class="nav-item" v-else-if="this.$store.state.role == 0">
        <sidenav-item
          url="/admin-repetitions"
          :class="getRoute() === 'admin-repetitions' ? 'active' : ''"
          :navText="'Total Lessons'"
        >
          <template v-slot:icon>
            <i
              class="ni ni-calendar-grid-58 text-warning text-sm opacity-10"
            ></i>
          </template>
        </sidenav-item>
      </li>
      <!-- ] -->
      
      
      <li class="mt-3 nav-item">
        <h6
          v-if="this.$store.state.isRTL"
          class="text-xs ps-4 text-uppercase font-weight-bolder opacity-6"
          :class="this.$store.state.isRTL ? 'me-4' : 'ms-2'"
        >
          صفحات المرافق
        </h6>
        <h6
          v-else
          class="text-xs ps-4 text-uppercase font-weight-bolder opacity-6"
          :class="this.$store.state.isRTL ? 'me-4' : 'ms-2'"
        >
          ACCOUNT PAGES
        </h6>
      </li>
      <!-- <li class="nav-item">
        <sidenav-item
          url="/profile"
          :class="getRoute() === 'profile' ? 'active' : ''"
          :navText="this.$store.state.isRTL ? 'حساب تعريفي' : 'Profile'"
        >
          <template v-slot:icon>
            <i class="ni ni-single-02 text-dark text-sm opacity-10"></i>
          </template>
        </sidenav-item>
      </li> -->
      <li class="nav-item" v-if="this.$store.state.username == ''">
        <sidenav-item 
          url="/signin"
          
          :navText="this.$store.state.isRTL ? 'تسجيل الدخول' : 'Sign In'"
        >
          <template v-slot:icon>
            <i class="ni ni-single-copy-04 text-danger text-sm opacity-10"></i>
          </template>
        </sidenav-item>
      </li>
      <li v-else class="nav-item" @click="logout">
        <sidenav-item 
          
          url="/signin"
          :class="getRoute() === 'signin' ? 'active' : ''"
          :navText="this.$store.state.isRTL ? 'تسجيل الدخول' : 'Log Out'"
        >
          <template v-slot:icon>
            <i class="fa fa-sign-out text-danger text-sm opacity-10"></i>
          </template>
        </sidenav-item>
      </li>
      <!-- <li class="nav-item" style="font-size: xx-small;">
        <sidenav-item
          url="/signup"
          :class="getRoute() === 'signup' ? 'active' : ''"
          :navText="this.$store.state.isRTL ? 'اشتراك' : 'Sign Up'"
        >
          <template v-slot:icon>
            <i class="ni ni-collection text-info text-sm opacity-10"></i>
          </template>
        </sidenav-item>
      </li> -->
    </ul>
  </div>
  <!-- <div class="pt-3 mx-3 mt-3 sidenav-footer">
    <sidenav-card
      :class="cardBg"
      textPrimary="Need Help?"
      textSecondary="Please check our docs"
    />
  </div> -->
</template>
<script>
import SidenavItem from "./SidenavItem.vue";
//import SidenavCard from "./SidenavCard.vue";

import $ from "jquery";

export default {
  name: "SidenavList",
  // props: {
  //   cardBg: String
  // },
  data() {
    return {
      title: "Argon Dashboard 2",
      controls: "dashboardsExamples",
      isActive: "active",
      servlets: {
          autentication: 'http://localhost:8084/first_vue_implementation_war_exploded/autentication',
        },
    };
  },
  components: {
    SidenavItem,
    //SidenavCard
  },
  methods: {
    getRoute() {
      const routeArr = this.$route.path.split("/");
      return routeArr[1];
    },
    async logout () {
      var self = this;
      $.ajax({
        url: this.servlets.autentication+';jsessionid='+self.$store.state.sessionId,
        type: 'POST',
        data: {action:"logout"},
        success: function() {
          self.$store.state.isAuth=false;
          self.$store.state.sessionId='';
          self.isAuth=false;
          self.$store.state.name = '';
          self.$store.state.username = '';
          self.$store.state.role = '';
        }
      });
      
     },
  }
};
</script>
