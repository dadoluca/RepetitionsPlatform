<template>
   <div class="py-4 container-fluid">

  <div id="head" style="margin-bottom:2%">    
    <div class="container">
      <div class="row">
        <div class="col">
          <!-- my teacher avatar-->
          <argon-avatar :img=this.$route.query.teacherUrl alt="Avatar" size="xl" circular />
        </div>
        <div class="col-10">
           <!-- my teacher title-->
           <h3 style="color: azure;  justify-content: center; ">
            {{ this.$route.query.teacherName }} {{ this.$route.query.teacherSurname }}</h3>
            <h5>Book a Repetition!</h5>
        </div>
        <div class="col-sm">
          <!-- my btn back-->
          <div style="position: absolute; top: 100px; right: 50px;">
            <router-link v-bind:to="{ path: '/course-teachers', query: { id: this.$route.query.courseId, nome: this.$route.query.nome } }" >
              <div class="text-center icon icon-shape">
                <i class="fa fa-arrow-circle-left fa-3x" aria-hidden="true"></i>
              </div>
            </router-link>
          </div>
        </div>
      </div>
      <div class="row">
        <!-- my not booking success alert -->
        <div v-if="this.showAlert" style="margin-top:2rem">
          <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
            <strong>Repetition booked!</strong> Now you can consult your reservation
          </argon-alert>   
        </div>
        <div v-if="this.showAlertCourse" style="margin-top:2rem">
          <argon-alert color="warning" icon="fa fa-meh-o" dismissible>
            <strong>Please, select a course</strong>
          </argon-alert>   
        </div>
      </div>
      <div class="col-md-6" v-if="courses.length > 0">
            <div class="row">
                <select id="selectcourse" v-model="selectcourse" class="input text-secondary text-l font-weight-bolder text-center" style="font-size: 20px;">
                    <option style="font-size: 16px; color:black"  v-for="c in courses" :key="c.id" :value="c.id" >{{ c.nome }}</option>
                </select>
            </div>
          </div>
    </div>
  </div>


  <!-- my avaiability calendar
  <AvailabilityCalendar />
  <br><br>-->


  <!-- Availability Table-->
  <div class="card">
    <div class="card-header pb-0">
      <h6>Availability Calendar<p  class="mb-0 text-sm p font-weight-bold" style="color:gray">This week</p></h6>
    </div>
    <div class="card-body px-0 pt-0 pb-2">
      <div class="table-responsive p-0">

        <table class="table align-items-center mb-0">
          <thead>
            <tr>
              <th v-for="day in days" :key="day" class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">{{day}}</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td v-for="n in [0, 1, 2, 3, 4, 5, 6]" :key="n" class="align-middle text-center text-sm">
                <div v-for="item in filteredAvailability(n)" :key="item.idDisponibilita" sytle="">
                  <!-- my badge prenotabile-->
                  <span v-if="isAlreadyBookedFromUser(item.idDisponibilita)"
                       class="badge badge-sm bg-gradient-white" style="font-size:xx-small;margin-bottom:0.5rem;color: #2dcea4;border:2px solid">
                   <div style="font-size: small; font-weight:normal;margin-bottom:0.5rem;margin-right: 0.3rem;">
                      <i class="fa fa-calendar-check fa-2x" aria-hidden="true" style="margin-right:0.4rem;margin-top:0.5rem;font-size: medium;"></i> 
                     {{ item.dataInizio.slice(11, 16) }} - {{ item.dataFine.slice(11, 16) }}</div>
                  </span>
                  <span v-else-if="!isAlreadyBooked(item.idDisponibilita)"
                        @click="bookRepetition(item.idDisponibilita)"
                       class="badge badge-sm bg-gradient-success" style="font-size:xx-small;margin-bottom:0.5rem;">
                   <div style="font-size: small; font-weight:normal;margin-bottom:0.5rem;margin-right: 0.3rem;">
                      <i class="fa fa-calendar-plus-o fa-2x" aria-hidden="true" style="margin-right:0.4rem;margin-top:0.5rem;font-size: medium;"></i> 
                     {{ item.dataInizio.slice(11, 16) }} - {{ item.dataFine.slice(11, 16) }} </div>
                  </span>
                  
                  <!-- my badge NON prenotabile-->
                  <span v-else class="badge badge-sm bg-gradient-secondary" style="font-size:xx-small;margin-bottom:0.5rem;"> 
                    <div style="font-size: small; font-weight:normal;margin-bottom:0.5rem;margin-right: 0.3rem;">
                      <i class="fa fa-times-circle fa-2x" aria-hidden="true" style="margin-right:0.4rem;margin-top:0.5rem;font-size: medium;"></i> 
                      {{ item.dataInizio.slice(11, 16) }} - {{ item.dataFine.slice(11, 16) }}
                    </div>
                  </span>

                </div>          
              </td>
            </tr>
        </tbody>
      </table>
      </div>
    </div>
  </div>
  <div>
  </div>

   </div>


  
</template>


<script>
  import $ from 'jquery';
  import ArgonAvatar from "../components/ArgonAvatar.vue";
  import ArgonAlert from "@/components/ArgonAlert.vue";

  
  export default {
    name: "TeacherAvailabilityView",
    data() {
      return {
        servlets: {
          availability: 'http://localhost:8084/first_vue_implementation_war_exploded/availability',
          unavailabilty: 'http://localhost:8084/first_vue_implementation_war_exploded/repetitions',
          courses: 'http://localhost:8084/first_vue_implementation_war_exploded/courses',
        },
        fromServer:
          {availability:[
            //{"idDisponibilita":88,"dataInizio":"2023-02-13 14:00:00.0","dataFine":"2023-02-13 15:00:00.0","idDocente":0},
            //{"idDisponibilita":89,"dataInizio":"2023-02-13 15:00:00.0","dataFine":"2023-02-13 16:00:00.0","idDocente":0},
          ],
          booked:[//idDisponibilita prenotate ovvero presenti in ripetizionedisponibilita
            //88, 90, 91, 94
          ],
          status:null,
          
        },   
        days:['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'],
        showAlert:false,
        courses:[],
        selectcourse: '',
        showAlertCourse: false,
      };
    },
    async mounted() {
      var self = this
      if(this.$route.query.courseId == null)
      {
        await $.get(self.servlets.courses+';jsessionid='+self.$store.state.sessionId, 
        {idDocente: self.$route.query.teacherId, action:"teacher" }, function (result) {
        self.courses = JSON.parse(result.corsi); 
      });
      this.selectcourse = this.courses[0].id
      }
        //alert("ciao")


      await this.getRepetitions();
      await this.getAvailability();
      await this.getUserRepetitions();
    },
    methods: {
      filteredAvailability(day) {
        return this.fromServer.availability.filter(item => (new Date(item.dataInizio)).getDay() - 1 === day);
      },
      isAlreadyBooked(id){
        let matchingRepetitions = this.fromServer.booked.filter(item => item.idDisponibilita === id);
        return matchingRepetitions.some(r => r.idDisponibilita === id);
      },
      isAlreadyBookedFromUser(id){
        let matchingRepetitions = this.fromServer.bookedFromUser.filter(item => item.idDisponibilita === id);
        return matchingRepetitions.some(r => r.idDisponibilita === id);
      },
      bookRepetition(idDisponibilita){
        if(this.$route.query.courseId != null)
          this.selectcourse = this.$route.query.courseId;
        var self = this;
        //alert(this.selectcourse)
        if(!isNaN(this.selectcourse)){
          if(this.$store.state.role !== 0){
            console.log(idDisponibilita);//chimata al server per prenotare
            
            $.post(self.servlets.unavailabilty+';jsessionid='+self.$store.state.sessionId, 
            {idCorso:self.selectcourse, idUtente:self.$store.state.username, idDisponibilita:idDisponibilita, action:"insert"},
            function (response) {
              if(response.status == "OK"){
                self.showAlert=true;
                setTimeout(() => {
                  self.showAlert=false;
                }, 6000);
                //self.getRepetitions();
                self.getUserRepetitions();
              }else if(response.status=="AUTHENTICATION_REQUIRED")
                self.$router.push('/signin');
            });
            }
        }else{
          this.showAlertCourse = true;
          setTimeout(() => {
                self.showAlertCourse=false;
              }, 6000);
        }
      },
      async getAvailability() {
        var self = this;
          try {
            await $.get(self.servlets.availability+';jsessionid='+self.$store.state.sessionId,
                  {
                      teacherId: self.$route.query.teacherId
                  }, function(response){
                    if (response.status === "OK") {
                        self.fromServer.availability = JSON.parse(response.availability);
                    } else if (response.status === "AUTHENTICATION_REQUIRED") {
                        self.$router.push('/signin');
                    }
                  });
              
          } catch (error) {
              console.error(error);
          }
      },
      async getRepetitions() {
        var self = this;
          try {
            await $.get(self.servlets.unavailabilty+';jsessionid='+self.$store.state.sessionId,
                  {
                      teacherId: this.$route.query.teacherId
                  }, function(response){
                    if (response.status === "OK") {
                      self.fromServer.booked = JSON.parse(response.repetitions);
                  } else if (response.status === "AUTHENTICATION_REQUIRED") {
                      self.$router.push('/signin');
                  }
              });
              
          } catch (error) {
              console.error(error);
          }
      },
      async getUserRepetitions() {
        var self = this
          try {
            await $.get(self.servlets.unavailabilty+';jsessionid='+self.$store.state.sessionId,
                  {
                      userId:this.$store.state.username
                      // action: "user"
                  }, function(response){
                    if (response.status === "OK") {
                        self.fromServer.bookedFromUser = JSON.parse(response.repetitions);
                        self.fromServer.bookedFromUser = self.fromServer.bookedFromUser.filter(item => item.stato !== 2)
                    } else if (response.status === "AUTHENTICATION_REQUIRED") {
                        self.$router.push('/signin');
                    }
              });
              
          } catch (error) {
              console.error(error);
          }
      }
    },

    components: {
      ArgonAvatar,
      ArgonAlert,
    },
  };
  </script>
  