<template>
    <div class="py-4 container-fluid">
      <div v-if="this.showInsert">
          <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
            Course correctly added
          </argon-alert>
      </div>
      <div v-if="this.showError">
          <argon-alert color="warning" icon="fa fa-meh-o" dismissible>
            Server error
          </argon-alert>
      </div>
      <div v-if="this.showError2">
          <argon-alert color="warning" icon="fa fa-meh-o" dismissible>
            Course already present
          </argon-alert>
      </div>
      <div v-if="this.showDelete">
          <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
            Course correctly deleted
          </argon-alert>
      </div>
      <button v-if="this.$store.state.role === 0 && !this.showForm" @click="this.showForm = !this.showForm" class="btn btn-lg" style="background-color:#2dce89;border:2px solid white; color:white">Add Course <i class="fa fa-plus-square" aria-hidden="true"></i></button>
      <button v-if="this.$store.state.role === 0 && this.showForm" @click="this.showForm = !this.showForm" class="btn btn-lg" style="background-color:#2dce89;border:2px solid white; color:white">Close form <i class="fa fa-minus-square" aria-hidden="true"></i></button>
    <form class="row col-lg-10 justify-content-center mx-auto" @submit.prevent="createCourse"
    style="border:4px solid white; border-radius: 10px; padding: inherit; background-color: #2dce89; margin-bottom: 5%;n" v-if="this.showForm">
      <h3 style="color:white; text-align:center">Add Course</h3>
      <div class="mx-auto form-group col-md-6 row">
        <input class="form-control" required type="text" placeholder="Course name" name="course" size="lg" v-model="new_course" style="height:50px;"/>
      </div>
      <div class="text-center">
        <argon-button class="mt-4" style="background-color:#2dce89;border:2px solid white; color:white" fullWidth size="lg">Add</argon-button>                        
      </div>
    </form>
      <div class="row">
        <div class="col-lg-12">
            <ul style="display: flex; flex-wrap: wrap;">
                <li v-for="item in courses" :key="item.id" style="flex: 0 0 45%; list-style: none; margin: 0 20px;">
                    <div>  
                      <!-- <router-link v-bind:to="{ path: '/course-teachers', query: { id: item.id, nome: item.nome } }"> -->
                        <CardCourse
                          :id = "item.id"
                          :title="item.nome"
                          :iconClass=" 'ni ni-book-bookmark'"
                          :iconBackground= "'bg-gradient-primary'"
                          :backgroundImage="item.imageUrl"
                          directionReverse
                          @aggiorna = "manageDelete"
                        ></CardCourse>
                      <!-- </router-link> -->
                    </div>
                </li>
            </ul>
      </div>
    </div>
  </div>
  </template>

  <script>
  import CardCourse from "@/components/Cards/CardCourse.vue";
  import $ from 'jquery';
  import ArgonButton from "@/components/ArgonButton.vue";
  import ArgonAlert from "@/components/ArgonAlert.vue";
  // import DialogMessage from "./components/DialogMessage.vue";
  //import Cookies from 'js-cookie'
  export default {
    name: "CoursesView",
    data() {
      return {
        servlets: {
          courses: 'http://localhost:8084/first_vue_implementation_war_exploded/courses',
        },
        courses: [
        /* { id:null, nome:null, imageUrl:null, }    */   
      ],
      showForm: false,
      new_course: '',
      showDelete: false,
      showError: false,
      showError2: false,
      showInsert: false,
      };
    },
     
    mounted() {
      var self = this;
      //Cookies.set('JSESSIONID', self.$store.state.sessionId, { expires: 7 });
      //alert(self.$store.state.sessionId);
      $.get(self.servlets.courses+';jsessionid='+self.$store.state.sessionId, {}, function (result) {
        self.courses = result;           
      });
    },
    methods:{
      async createCourse(){
        //alert(idCorso + " " + idDocente)
        var self = this;
        await $.post(self.servlets.courses+';jsessionid='+self.$store.state.sessionId, 
        {
          nome: self.new_course,
          action: "insert-course"
        },
        function (response) {
          if(response.status == "OK"){
            self.aggiornaDati();
            self.showForm = false;
            self.showInsert = true
            setTimeout(() => {
                self.showInsert = false
              }, 4000);
          }else if(response.status == "INVALID_PARAMETERS")
            {
              self.showError = true,
              setTimeout(() => {
                self.showError = false
              }, 4000);
            }else if(response.status == "AUTHENTICATION_REQUIRED")
            {
              self.$router.push('/signin')
            }else if(response.status == "FAILED"){
              self.showError2 = true,
              setTimeout(() => {
                self.showError2 = false
              }, 4000);
            }
        });
      },
      aggiornaDati: function(){
        var self = this;
        $.get(self.servlets.courses+';jsessionid='+self.$store.state.sessionId, {}, function (result) {
        self.courses = result;           
      });
      $('html, body').animate({ scrollTop: 0 }, 'fast');
      },
      manageDelete: function(response){
        var self = this
        if(response == "OK"){
          self.aggiornaDati();
          self.showDelete = true
          setTimeout(() => {
              self.showDelete = false
            }, 4000);
          }else if(response == "INVALID_PARAMETERS" || response == "FAILED")
            {
              self.showError = true,
              setTimeout(() => {
                self.showError = false
              }, 4000);
            }else if(response == "AUTHENTICATION_REQUIRED")
            {
              self.$router.push('/signin')
            }
      }
    },
    components: {
      CardCourse,
      // DialogMessage
      ArgonButton,
      ArgonAlert
    },
  };
  </script>
  