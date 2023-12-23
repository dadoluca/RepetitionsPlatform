<template>
    <div>
        <div class="row">
            <!-- my not booking success alert -->
            <div v-if="this.showAlert" style="margin-top:2rem">
            <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
                <strong>{{this.alert}}</strong>
            </argon-alert>   
            </div>
        </div>
        <AdminTableRepetitions :ripetizioni=this.fromServer.booked @aggiorna="aggiornaDati"></AdminTableRepetitions>
    </div>
</template>

<script>
import $ from 'jquery'
import ArgonAlert from "@/components/ArgonAlert.vue";
import AdminTableRepetitions from '../components/AdminTableRepetitions.vue';
    export default {
     name: "AdminRepetitionsView",
     data() {
       return {
            servlets: {
            unavailabilty: 'http://localhost:8084/first_vue_implementation_war_exploded/repetitions'
            },
            fromServer:
            {booked:[//idDisponibilita prenotate ovvero presenti in ripetizionedisponibilita
            ],
            status:null
            },
            showAlert: false,
            alert: ''
            };
        },
     async mounted() {
        await this.getRepetitions();
     },
     methods: {
       async getRepetitions() {
        var self = this
           try {
            await $.get(self.servlets.unavailabilty+';jsessionid='+self.$store.state.sessionId,
                   {
                       action:"admin"
                   }, function(response){
                        if (response.status === "OK") {
                            self.fromServer.booked = JSON.parse(response.repetitions);
                            self.fromServer.booked.sort(function(a, b){
                                let dateA = new Date(a.dataInizio);
                                let dateB = new Date(b.dataInizio);
                                return dateA - dateB;
                                });
                                self.fromServer.status = response.status;
                        } else if (response.status === "AUTHENTICATION_REQUIRED") {
                            self.$router.push('/signin');
                        }
               });
               
           } catch (error) {
               console.error(error);
           }
       },
       aggiornaDati: function(value){
          this.getRepetitions();
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
        AdminTableRepetitions,
        ArgonAlert
     },
   }
</script>

<style lang="scss" scoped>

</style>