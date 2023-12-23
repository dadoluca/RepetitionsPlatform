<template>
  <div class="container top-0 position-sticky z-index-sticky">
    <div class="row">
      <div class="col-12">
        <!-- <navbar
          isBlur="blur  border-radius-lg my-3 py-2 start-0 end-0 mx-4 shadow"
          v-bind:darkMode="true"
          isBtn="bg-gradient-success"
        /> -->
      </div>
    </div>
  </div>
  <main class="mt-0 main-content">
    <section>
      <div class="page-header min-vh-100">
        <div class="container" >
          <div class="row">
            <div class="mx-auto col-xl-4 col-lg-5 col-md-7 d-flex flex-column mx-lg-0">
              <div v-if="this.showAlert" style="margin:20 px;">
                <argon-alert color="warning" icon="fa fa-meh-o">
                  Wrong email or password 
                </argon-alert>
              </div>

              <div style="height:100%;width:100%; border:2 px slid black;" v-if="this.isLoading">
                <ArgonProgress :color="progressbar.color" :variant="progressbar.variant" :percentage="progressbar.percentage" />
            </div>               

              <div v-if="this.$store.state.isAuth && !this.isLoading">
                <h2 class="font-weight-bolder" >You are already logged in !!</h2>
                <argon-button class="mt-4" variant="gradient" color="success" fullWidth size="lg" @click="logout">Logout</argon-button>                        
              </div>
              
              <div  v-if="!this.$store.state.isAuth  && !this.isLoading" class="card card-plain">
                <div class="pb-0 card-header text-start">
                  <h2 class="font-weight-bolder">Sign In</h2>
                  <p class="mb-0">Enter your email and password to sign in</p>
                </div>
                <div  class="card-body">

                  <form @submit.prevent="login">
                    <div class="mb-3 form-group">
                     <input class="form-control" type="email" placeholder="Email" name="email" size="lg" v-model="email" style="height:50px;"/>
                    </div>
                    <div class="mb-3 form-group">
                    <!-- <argon-input type="password" placeholder="Password" name="password" size="lg"/>-->
                     <input class="form-control" type="password" placeholder="Password" name="password" size="lg" v-model="pwd" style="height:50px;"/>
                    </div>
                    <!--  <argon-switch id="rememberMe">Remember me</argon-switch> -->
                    <div class="text-center">
                      <argon-button class="mt-4" variant="gradient" color="success" fullWidth size="lg">Sign in</argon-button>                        
                    </div>
                  </form>
                </div>
                <div class="px-1 pt-0 text-center card-footer px-lg-2">
                  <p class="mx-auto mb-4 text-sm">
                    Don't have an account?
                  <router-link  to="/signup">
                    <a
                      href="javascript:;"
                      class="text-success text-gradient font-weight-bold"
                    >Sign up</a>
                  </router-link>
                   or 
                   <router-link  to="/Courses">
                    <a
                      href="javascript:;"
                      class="text-success text-gradient font-weight-bold"
                    >Enter as a guest</a>
                  </router-link>
                  </p>
                </div>
              </div>
            </div>
            <div
              class="top-0 my-auto text-center col-6 d-lg-flex d-none h-100 pe-0 position-absolute end-0 justify-content-center flex-column"
            >
              <div
                class="position-relative bg-gradient-primary h-100 m-3 px-7 border-radius-lg d-flex flex-column justify-content-center overflow-hidden"
                style="background-image: url('https://raw.githubusercontent.com/creativetimofficial/public-assets/master/argon-dashboard-pro/assets/img/signin-ill.jpg');
          background-size: cover;"              >
                <span class="mask bg-gradient-success opacity-6"></span>
                <h1
                  class="mt-5 text-white font-weight-bolder position-relative"
                >Tutoring Service</h1>
                <p
                  class="text-white position-relative"
                >Improve your knowledge with us</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>



<script>
// import Navbar from "@/examples/PageLayout/Navbar.vue";
import ArgonButton from "@/components/ArgonButton.vue";
const body = document.getElementsByTagName("body")[0];
import { activateDarkMode, deactivateDarkMode } from "@/assets/js/dark-mode";
//import CircularProgressIndicator from "./components/CircularProgrssIndicator.vue";
import ArgonProgress  from "../components/ArgonProgress.vue";
import ArgonAlert from "@/components/ArgonAlert.vue";
import $ from 'jquery';


export default {
  name: "signin",
  data(){ 
      return {      
        isLoading:false,  
        progressbar:{
          color: 'primary',
          variant: 'fill',
          percentage: 0,
        },
        
        
        servlets: {
          autentication: 'http://localhost:8084/first_vue_implementation_war_exploded/autentication',
        },
        email: 'luca.dadone01@gmail.com',
        pwd: '123456',       
        isAuth: false,
        fromServer: null,
        showAlert: false,
                  //{     username:null
                  //     ruolo:null, 
                  //     errorMsg:null,    },  
           // session:{
                //     sessionId:null,
                //     utente:{
                //         username:'',
                //         password: '',
                //         id:'',
                //         ruolo:'',                    
                //     },  
                //     errorMsg:null,
                // }           
     };
  },
  components: {
    // Navbar,
    ArgonButton,
    ArgonProgress,
    ArgonAlert
  },
  methods: {
    setDarkMode: function() {
      if (this.$store.state.darkMode) {
        this.$store.state.darkMode = false;
        this.$store.state.sidebarType = "bg-white";
        deactivateDarkMode();
        return;
      } else {
        this.$store.state.darkMode = true;
        this.$store.state.sidebarType = "bg-default";
        activateDarkMode();
      }
    },/*
    async login() {
      //alert(this.email + " "+ this.pwd)
      var self = this;
      if (!self.isAuth || !self.$store.state.isAuth) {
        $.post(this.servlets.autentication, {
          sessionId: this.$store.state.isAuth==false ?  '' :this.fromServer.sessionId,
          username: this.email,
          password: this.pwd,
          action:"login",
        }, function (data) {//callback
          self.fromServer = data;
          if (self.fromServer.errorMsg == null && self.fromServer.username == self.email) {
            self.isAuth = true;
            
            self.isLoading=true;
            for(var i=0;i<9;i++){
              setTimeout(() => {
                self.progressbar.percentage = i*10;             
              }, 110);
            }
            setTimeout(() => {
              self.$router.push('/courses');
                self.isLoading=false;
              }, 1000);
            
            //self.setDarkMode();
            self.$store.state.isAuth=true;
            self.$store.state.sessionId = self.fromServer.sessionId;
          }
          else 
            alert("Autenticazione fallita "+ self.fromServer.errorMsg);
            //self.pwd='';
        },
        'json', {
          xhrFields: {
            withCredentials: true
          }
        
         });
      }
     },*/
     getCookieValue: function(name) {
      const value = `; ${document.cookie}`;
      const parts = value.split(`; ${name}=`);
      if (parts.length === 2) return parts.pop().split(";").shift();
    },
     async login() {
      var self = this;
      //self.setDarkMode();
      if (!self.$store.state.isAuth) {
        $.post(this.servlets.autentication+';jsessionid='+self.$store.state.sessionId, {
          username: this.email,
          password: this.pwd,
          action:"login",
        },
        function (data) {//callback
          self.fromServer = data;
          if (self.fromServer.errorMsg == null && self.fromServer.username == self.email) {
  
            //alert("sessionId: "+self.fromServer.sessionId);
            // in the callback of your ajax call
            
            //const jsessionid = self.getCookieValue("JSESSIONID");
            //alert("cookie JSESSIONID: " +jsessionid);
            self.$store.state.sessionId = self.fromServer.sessionId;

            
            self.isLoading=true;
            for(var i=0;i<9;i++){
              setTimeout(() => {
                self.progressbar.percentage = i*10;             
              }, 110);
            }
            setTimeout(() => {
              self.$router.push('/courses');
                self.isLoading=false;
              }, 1000);
            
            //self.setDarkMode();
            self.$store.state.isAuth=true;
            self.isAuth = true;
            // alert(self.fromServer.username.split(".")[0]);
            //prendo il nome dalla mail
            var name = self.fromServer.username.split(".")[0];
            var firstLetter = name.charAt(0).toUpperCase();
            var restOfName = name.substring(1);
            name = firstLetter + restOfName
            self.$store.state.user = name;
            self.$store.state.role = self.fromServer.ruolo;
            //alert(self.fromServer.username);
            self.$store.state.username = self.fromServer.username;
          }
          else 
          {
            self.showAlert = true
            setTimeout(() => {
              self.showAlert = false;
            }, 6000);
          }
            // alert("Autenticazione fallita "+ self.fromServer.errorMsg);
            
            //self.pwd='';
        },
        'json', {
          xhrFields: {
            withCredentials: true
          }
        
         });
      }
     },

     async logout () {
      //alert("provo il logout");
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
  },
  created() {
    this.$store.state.hideConfigButton = true;
    this.$store.state.showNavbar = false;
    this.$store.state.showSidenav = false;
    this.$store.state.showFooter = false;
    body.classList.remove("bg-gray-100");
  },
  beforeUnmount() {
    this.$store.state.hideConfigButton = false;
    this.$store.state.showNavbar = true;
    this.$store.state.showSidenav = true;
    this.$store.state.showFooter = true;
    body.classList.add("bg-gray-100");
  },
}
</script>
