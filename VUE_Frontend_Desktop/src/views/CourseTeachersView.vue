<template>
    <div class="py-4 container-fluid">
      <div class="row">
        <div class="col-lg-12">
          <!-- my course teachers title-->
          <h2 style=" margin: 0% 0% 3% 1.7%; color: azure;">{{ this.$route.query.nome }}</h2>
          <!-- my not logged title -->
          <div v-if="this.showAlert" style="margin:20 px;">
            <argon-alert color="warning" icon="fa fa-meh-o">
              <strong>You are not logged in!</strong> This feature is reserved for registered users. You will be redirect to login page
            </argon-alert>
          </div>
          <div v-if="this.showDelete">
            <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
              Teacher correctly deleted from {{ this.$route.query.nome }}
            </argon-alert>
          </div>
          <div v-if="this.showInsert">
            <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
              Teacher correctly added to {{ this.$route.query.nome }}
            </argon-alert>
          </div>
          <div v-if="this.showError">
            <argon-alert color="warning" icon="fa fa-meh-o" dismissible>
              Please, select a Teacher from the list
            </argon-alert>
          </div>
          <!-- my btn back-->
          <div style="position: absolute; top: 100px; right: 50px;">
            <router-link to="/courses" >
              <div class="text-center icon icon-shape">
                <i class="fa fa-arrow-circle-left fa-3x" aria-hidden="true"></i>
              </div>
            </router-link>
          </div>

      <div class="py-4 container-fluid">
        <button v-if="this.$store.state.role === 0 && !this.showForm" @click="this.showForm = !this.showForm" class="btn btn-lg" style="background-color:#2dce89;border:2px solid white; color:white">Add teacher to {{ this.$route.query.nome }} <i class="fa fa-plus-square" aria-hidden="true"></i></button>
        <button v-if="this.$store.state.role === 0 && this.showForm" @click="this.showForm = !this.showForm" class="btn btn-lg" style="background-color:#2dce89;border:2px solid white; color:white">Close form <i class="fa fa-minus-square" aria-hidden="true"></i></button>
        <form class="row col-lg-10 justify-content-center mx-auto" @submit.prevent="createCourseTeacher(this.$route.query.id,selectedTeacher)"
        style="border:4px solid white; border-radius: 10px; padding: inherit; background-color: #2dce89; margin-bottom: 5%;n" v-if="this.showForm">
          <h3 style="color:white; text-align:center">Add a teacher to {{ this.$route.query.nome }}</h3>
          <div class="col-md-8">
            <div class="row">
                <select id="selectTeacher" v-model="selectedTeacher" class="input text-secondary text-l font-weight-bolder text-center" style="font-size: 20px;">
                    <option style="font-size: 16px"  v-for="p in filteredTeachers" :key="p.idDocente" :value="p.idDocente" >{{ p.cognome }} {{ p.nome }}</option>
                </select>
            
              <div class="text-center">
                <argon-button class="mt-4" style="background-color:#2dce89;border:2px solid white; color:white" fullWidth size="lg">Add</argon-button>                        
              </div>
            </div>
          </div>
        </form>
        </div>

        <div class="row"> 
            <ul style="display: flex; flex-wrap: wrap;">
                <li  v-for="item in teachers" :key="item.idDocente"  style="flex: 0 0 47%; list-style: none; margin: 0 0% 3% 0%;display: flex; justify-content: center;">
                        <CardTeacher
                          :courseId="this.$route.query.id"
                          :id="item.idDocente"
                          :email="item.email"
                          :nome="item.nome"
                          :cognome="item.cognome"
                          :sesso="item.sesso"
                          :eta="item.eta"
                          :formazione="item.formazione"
                          :prezzoH="item.prezzoH"
                          :avatarImage="item.imageUrl"
                          :placeholderImage="item.imageUrlUniversity"
                          directionReverse
                          :courseTeacher = true
                          @aggiorna="aggiornaDati"
                        ></CardTeacher>                      
                </li>
            </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<style> 
</style>
  
  <script>
  import CardTeacher from "@/components/Cards/CardTeacher.vue";
  import $ from 'jquery';
  import ArgonAlert from "@/components/ArgonAlert.vue";
  import ArgonButton from "@/components/ArgonButton.vue";


  export default {
    name: "CourseTeachersView",
    data() {
      return {
        showAlert:false,
        showDelete: false,
        showForm: false,
        showInsert: false,
        showError: false,
        // selectedTeacher:
        servlets: {
          teachers: 'http://localhost:8084/first_vue_implementation_war_exploded/teachers',
          courses: 'http://localhost:8084/first_vue_implementation_war_exploded/courses',
        },
        teachers: [
       /* { idDocente:null, email:null, nome:null, cognome:null, sesso:null, eta:null, formazione:null, prezzoH:null, imageUrl:null, imageUrlUniversity:null,}    */   
      ],
      filteredTeachers:[],
      allTeachers:[]
      };
    },
    async mounted() {
      var self = this;
      await $.get(self.servlets.teachers+';jsessionid='+self.$store.state.sessionId,
       {courseId:this.$route.query.id}, function (result) {
        self.teachers = result;
      });
      await $.get(self.servlets.teachers+';jsessionid='+self.$store.state.sessionId, {}, function (result) {
        self.allTeachers = result;
      });
      this.filteredTeachers = self.allTeachers.filter( x => !this.teachers.filter( y => y.idDocente === x.idDocente).length);
      this.filteredTeachers.sort(function(a, b){
        var cognomeA = a.cognome.toLowerCase();
        var cognomeB = b.cognome.toLowerCase();
        if(cognomeA < cognomeB) return -1;
        if(cognomeA > cognomeB) return 1;
        return 0;
        });
        $('#selectTeacher option:odd').css({'background-color': '#f2f2f2'})
    },
    beforeRouteLeave(to, from, next) {
    if (to.path == '/signin' && !this.$store.state.isAuth==true && to.query.bookRequest) {
      this.showAlert=true;

      // aspetto un secondo prima di chiamare next()
      setTimeout(() => {
        next();
      }, 4000);
    }
    else{
      next();
    }
  },
  methods:{
    aggiornaDati: function(action){
        var self = this;
        $.get(self.servlets.teachers+';jsessionid='+self.$store.state.sessionId,
        {courseId:this.$route.query.id}, function (result) {
          self.teachers = result;
          self.$nextTick(function () {
              self.filteredTeachers = self.allTeachers.filter( x => !this.teachers.filter( y => y.idDocente === x.idDocente).length);    
              self.filteredTeachers.sort(function(a, b){
                var cognomeA = a.cognome.toLowerCase();
                var cognomeB = b.cognome.toLowerCase();
                if(cognomeA < cognomeB) return -1;
                if(cognomeA > cognomeB) return 1;
                return 0;
                });
              });
        });
        if(action == "delete")
          self.showDelete=true;
        else if (action == "insert")
        {
          self.showInsert = true;
          self.selectedTeacher = '';
        }
          
        setTimeout(() => {
              self.showInsert = false;
              self.showDelete = false;
            }, 6000);
        $('html, body').animate({ scrollTop: 0 }, 'fast');
      },
      async createCourseTeacher(courseId, teacherId){
        //alert(idCorso + " " + idDocente)
        var self = this;
        await $.post(self.servlets.courses+';jsessionid='+self.$store.state.sessionId, 
        {
          idDocente: teacherId,
          idCorso: courseId,
          action: "insert-course-teacher"
        },
        function (response) {
          if(response.status == "OK"){
            self.aggiornaDati("insert")
          }else if(response.status == "INVALID_PARAMETERS")
            {
              self.showError = true,
              setTimeout(() => {
                self.showError = false
              }, 4000);
            }
        });
      }
  },
    components: {
        CardTeacher,
        ArgonAlert,
        ArgonButton
    },
  };
  </script>

