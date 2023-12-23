<template>
    <div v-if="this.showAlert">
      <argon-alert color="warning" icon="fa fa-meh-o">
        <strong>You are not logged in!</strong> This feature is reserved for registered users. You will be redirect to login page
      </argon-alert>    
    </div>
    <div v-if="this.showAlertTeacher">
      <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
        Teacher correctly added
      </argon-alert>
    </div>
    <div v-if="this.showDelete">
      <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
        Teacher correctly deleted
      </argon-alert>
    </div>
  <div class="py-4 container-fluid">
    <button v-if="this.$store.state.role === 0" @click="this.showForm = !this.showForm" class="btn btn-lg" style="background-color:#2dce89;border:2px solid white; color:white">Add teacher <i class="fa fa-plus-square" aria-hidden="true"></i></button>
    <form class="row col-lg-10 justify-content-center mx-auto" @submit.prevent="addTeacher"
    style="border:4px solid white; border-radius: 10px; padding: inherit; background-color: #2dce89; margin-bottom: 5%;n" v-if="this.showForm">
      <h3 style="color:white; text-align:center">Add Teacher</h3>
      <div class="mx-auto form-group col-md-12 row">
        <input class="form-control" required type="email" placeholder="Email" name="email" size="lg" v-model="new_teacher.email" style="height:50px;"/>
      </div>
      <div class="mx-auto form-group col-md-5 row">
        <input class="form-control" required type="text" placeholder="Name" name="name" size="lg" v-model="new_teacher.name" style="height:50px;"/>
      </div>
      <div class="mx-auto form-group col-md-5 row">
        <input class="form-control" required type="text" placeholder="Lastname" name="lastname" size="lg" v-model="new_teacher.lastname" style="height:50px;"/>
      </div>
      <div class="mx-auto form-group col-md-2 row">
        <input class="form-control" required type="number" placeholder="Age" name="age" size="lg" v-model="new_teacher.age" style="height:50px;"/>
      </div>
      
      <div class="mx-auto form-group col-md-8 row">
        <input class="form-control" required type="text" placeholder="Qualification" name="qualification" size="lg" v-model="new_teacher.qualification" style="height:50px;"/>
      </div>
      <div class="mx-auto form-group col-md-2 row">
        <select v-model="new_teacher.sesso" class="input text-secondary text-s font-weight-bolder">
            <option selected="selected" value="-" class="text-secondary text-xs font-weight-bolder opacity-7">--------</option>
            <option value="uomo" class="text-secondary text-xs font-weight-bolder opacity-7">Man</option>
            <option value="donna" class="text-secondary text-xs font-weight-bolder opacity-7">Woman</option>
        </select>
      </div>
      <div class="mx-auto form-group col-md-2 row">
        <input class="form-control" required type="number" placeholder="Cost per hour €/h" name="cost" size="lg" v-model="new_teacher.cost" style="height:50px;"/>
      </div>
      <div class="text-center">
        <argon-button class="mt-4" style="background-color:#2dce89;border:2px solid white; color:white" fullWidth size="lg">Add</argon-button>                        
      </div>
    </form>
      <div class="row">
        <div class="col-lg-12">
        <div class="row">
            <ul style="display: flex; flex-wrap: wrap;">
                <li v-for="item in teachers" :key="item.idDocente" style="flex: 0 0 47%; list-style: none; margin: 0 0% 3% 0%;display: flex; justify-content: center; ">
                        <CardTeacher
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
                          @aggiorna="aggiornaDati"
                          :courseTeacher = false
                        ></CardTeacher>                      
                </li>
            </ul>
        </div>
      </div>
    </div>
  </div>
</template>
  
  <script>
  import CardTeacher from "@/components/Cards/CardTeacher.vue";
  import $ from 'jquery';
  import ArgonAlert from "@/components/ArgonAlert.vue";
  import ArgonButton from "@/components/ArgonButton.vue";

  
  export default {
    name: "TeachersView",
    data() {
      return {
        showAlert:false,
        servlets: {
          teachers: 'http://localhost:8084/first_vue_implementation_war_exploded/teachers',
        },
        teachers: [
       /* { idDocente:null, email:null, nome:null, cognome:null, sesso:null, eta:null, formazione:null, prezzoH:null, imageUrl:null, imageUrlUniversity:null,}    */   
      ],
      showForm: false,
      showDelete: false,
      showAlertTeacher: false,
      new_teacher:{
        email:'',
        password:'',
        name:'',
        lastname:'',
        qualification:'',
        cost:'',
        age:'',
        imageUrl: '',
        sesso: '',
      }
      };
    },
    mounted() {
      var self = this;
      $.get(self.servlets.teachers+';jsessionid='+self.$store.state.sessionId, {}, function (result) {
        self.teachers = result;     
      });
      this.new_teacher.sesso = "-"
    },
    components: {
        CardTeacher,
        ArgonAlert,
        ArgonButton
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
    // getImage(){
    //   var self = this;
    //   $.ajax({
    //     url: 'https://randomuser.me/api/',
    //     dataType: 'json',
    //     success: function(data) {
    //       //console.log(data);
    //       //alert(data.results[0].picture.thumbnail)
    //       self.new_teacher.imageUrl = data.results[0].picture.thumbnail;
    //     }
    //   });
    //   },
      addTeacher(){
        var self = this;
        if(self.new_teacher.sesso == "uomo")
          this.new_teacher.imageUrl = "https://xsgames.co/randomusers/assets/avatars/male/" + Math.floor(Math.random() * (78 - 1) + 1) + ".jpg"
        else{
          this.new_teacher.imageUrl = "https://xsgames.co/randomusers/assets/avatars/female/" + Math.floor(Math.random() * (78 - 1) + 1) + ".jpg"
        }
        //this.getImage();
        $.post(this.servlets.teachers+';jsessionid='+this.$store.state.sessionId, 
        { email: self.new_teacher.email,
          nome: self.new_teacher.name,
          cognome: self.new_teacher.lastname,
          sesso: self.new_teacher.sesso,
          formazione: self.new_teacher.qualification,
          eta: self.new_teacher.age,
          prezzoH: self.new_teacher.cost,
          imageUrl: self.new_teacher.imageUrl,
          action: "insert"
        },
        function (response) {
          if(response.status == "OK"){
            self.showAlertTeacher=true;
            setTimeout(() => {
              self.showAlertTeacher=false;
            }, 6000);
            $.get(self.servlets.teachers+';jsessionid='+self.$store.state.sessionId, {}, function (result) {
              self.teachers = result;     
            });
          }else if(response.status=="AUTHENTICATION_REQUIRED")
            self.$router.push('/signin'); 
      });
      this.showForm = false;
      },
      aggiornaDati: function(){
        var self = this;
        $.get(self.servlets.teachers+';jsessionid='+self.$store.state.sessionId, {}, function (result) {
          self.teachers = result;     
        });
        self.showDelete = true;
        $('html, body').animate({ scrollTop: 0 }, 'fast');
        setTimeout(() => {
              self.showDelete=false;
            }, 6000);
      }
  }

  };
  </script>
  