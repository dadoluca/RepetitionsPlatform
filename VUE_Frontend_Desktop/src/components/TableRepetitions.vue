<template>
    <div class="card">
      <div class="card-header pb-0">
        <h6>Reservations table</h6>
      </div>
      <div class="card-body px-0 pt-0 pb-2">
        <div class="table-responsive p-0">
          <table class="table align-items-center mb-0 table-striped">
            <thead>
              <tr>
                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Professor</th>
                <th
                  class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                >Course</th>
                <th
                  class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                >Day</th>
                <th
                  class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                >Start</th>
                <th
                  class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                >End</th>
                <th
                  class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                >Status</th>
                <th
                  class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                >Action</th>
                
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in ripetizioni" :key="item.id">
                <td class="align-middle text-center text-sm">
                  <div class="d-flex px-2 py-1">
                    <div>
                      <img
                        :src=item.imageUrlDocente
                        class="avatar avatar-sm me-3"
                        alt="user1"
                      />
                    </div>
                    <div class="d-flex flex-column justify-content-center">
                      <h6 class="mb-0 text-sm">{{ item.cognomeDocente }} {{ item.nomeDocente }}</h6>
                      <p class="text-xs text-secondary mb-0">john@creative-tim.com</p>
                    </div>
                  </div>
                </td>
                <td class="align-middle text-center text-sm">
                  <p class="text-xs font-weight-bold mb-0">{{ item.nomeCorso }}</p>
                </td>
                <td class="align-middle text-center text-sm">
                  <p class="text-xs font-weight-bold mb-0">{{ item.dataInizio.slice(0,10) }}</p>
                </td>
                <td class="align-middle text-center text-sm">
                  <p class="text-xs font-weight-bold mb-0">{{ item.dataInizio.slice(11, 16) }}</p>
                </td>
                <td class="align-middle text-center text-sm">
                  <p class="text-xs font-weight-bold mb-0">{{ item.dataFine.slice(11, 16) }}</p>
                </td>
                <td class="align-middle text-center text-sm text-uppercase">
                    <p v-if="item.stato === 1" class="text-xs font-weight-bold mb-0" style="color: green;">confirmed</p>
                    <p v-if="item.stato === 0" class="text-xs font-weight-bold mb-0" style="color: black;">active</p>
                    <p v-if="item.stato === 2" class="text-xs font-weight-bold mb-0" style="color: red;">deleted</p>
                </td>
                <td class="align-middle text-center text-sm" >
                  <button v-if="item.stato == 0" class="btn btn-success btn-sm my-auto" @click="confirmRepetition(item.idRipetizione)" style="margin-right: 5px;">Confirm
                      <i class="fa fa-check-circle-o fa-2x" aria-hidden="true" style="margin-right:0.4rem;margin-top:0.5rem;font-size: medium;"></i>
                    </button>
                    <button v-if="item.stato == 0" class="btn btn-warning btn-sm my-auto" @click="deleteRepetition(item.idRipetizione)">Delete
                      <i class="fa fa-trash-o fa-2x" aria-hidden="true" style="margin-right:0.4rem;margin-top:0.5rem;font-size: medium;"></i>
                    </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import $ from 'jquery'
  export default {
    name: "repetitions-table",
    props: ['ripetizioni'],
    data() {
      return {
        servlets: {
          unavailabilty: 'http://localhost:8084/first_vue_implementation_war_exploded/repetitions'
        },
        showAlert:false,
      };
    },
    methods: {
      confirmRepetition(idRipetizione){
        var self = this;
        $.post(this.servlets.unavailabilty+';jsessionid='+this.$store.state.sessionId, 
        {idRipetizione:idRipetizione, action:"confirm"},
        function (response) {
          if(response.status == "OK"){
            self.$emit('aggiorna','confermed');
            //self.getUserRepetitions();
          }else if(response.status=="AUTHENTICATION_REQUIRED")
            self.$router.push('/signin');
      });
      },
      deleteRepetition(idRipetizione){
          var self = this;
          $.post(this.servlets.unavailabilty+';jsessionid='+this.$store.state.sessionId, 
          {idRipetizione:idRipetizione, action:"delete"},
          function (response) {
            if(response.status == "OK"){
              self.$emit('aggiorna','cancelled');
              //self.getUserRepetitions();
            }else if(response.status=="AUTHENTICATION_REQUIRED")
              self.$router.push('/signin');
        });
      }
    },
  };
  </script>
  