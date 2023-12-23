<template>
    <div class="py-4 container-fluid">
      <div class="row">
        <!-- my not booking success alert -->
        <div v-if="this.showAlert" style="margin-top:2rem">
          <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
            <strong>{{this.alert}}</strong>
          </argon-alert>   
        </div>
      </div>
 
    <div id="head" style="margin-bottom:2%">    
      <div class="container">
        <TableRepetitions @aggiorna="aggiornaDati" :ripetizioni="fromServer.bookedFromUser"></TableRepetitions>
      </div>
    </div>
 
  </div>
 
 
   
 </template>
 
 
 <script>
  import $ from 'jquery';
  //  import ArgonAvatar from "../components/ArgonAvatar.vue";
  import ArgonAlert from "@/components/ArgonAlert.vue";
  import TableRepetitions from '../components/TableRepetitions.vue';
 
   
   export default {
     name: "UserRepetitionsView",
     data() {
       return {
         servlets: {
           unavailabilty: 'http://localhost:8084/first_vue_implementation_war_exploded/repetitions'
         },
         fromServer:
           {bookedFromUser:[//idDisponibilita prenotate ovvero presenti in ripetizionedisponibilita
             //88, 90, 91, 94
           ],
           status:null
         },
         showAlert: false,
         alert: ''
       };
     },
     async mounted() {
        await this.getUserRepetitions();
     },
     methods: {
       async getUserRepetitions() {
        var self = this
           try {
            await $.get(self.servlets.unavailabilty+';jsessionid='+self.$store.state.sessionId,
                   {
                       userId:self.$store.state.username
                   }, function(response){
                      if (response.status === "OK") {
                          self.fromServer.bookedFromUser = JSON.parse(response.repetitions);
                          self.fromServer.bookedFromUser.sort(function(a, b){
                              let dateA = new Date(a.dataInizio);
                              let dateB = new Date(b.dataInizio);
                              return dateA - dateB;
                            });
                      } else if (response.status === "AUTHENTICATION_REQUIRED") {
                          self.$router.push('/signin');
                      }
               });
               
           } catch (error) {
               console.error(error);
           }
       },
       aggiornaDati: function(value){
          this.getUserRepetitions();
          if(value === 'cancelled')
            this.alert = 'Repetitions successfully deleted'
          else if(value === 'confermed')
            this.alert = 'Repetitions successfully confirmed'
          this.showAlert=true;
            setTimeout(() => {
              this.showAlert=false;
            }, 6000);
            $('html, body').animate({ scrollTop: 0 }, 'fast');
       }
     },
 
     components: {
      TableRepetitions,
      //  ArgonAvatar,
      ArgonAlert,
     },
   };
   </script>
   