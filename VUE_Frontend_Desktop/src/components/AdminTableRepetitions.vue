<template>
    <div class="card">
      <div class="card-header pb-0">
        <h4>Reservations table</h4>
      </div>
    <div class="container">
        <select style="font-size:18px" id="selectTeacher" v-model="selectedProf" class="input text-secondary font-weight-bolder">
            <option style="font-size:14px" selected="selected" value="all" class="text-secondary ">All professors</option>
            <option style="text-decoration: none;font-size:14px" v-for="p in professors" :key="p.id" :value="p.id">{{ p.cognome }} {{ p.nome }}</option>
        </select>
    </div>
      <div class="float-rigth" style="margin-right:2%">
            <ul class="pagination ml-auto" style="float:right">
                <li class="page-item" v-if="currentPage > 1" @click="currentPage--">
                <a class="page-link">Prev</a>
                </li>
                <li class="page-item" :key="index"  v-for="(page, index) in pages"  :class="{ 'active': page === currentPage }"  @click="currentPage = page">
                <a class="page-link" :style="[page === currentPage ? {'color':'white','background-color':'#2dce89','border':'none'} : '']">{{ page }}</a>
                </li>
                <li class="page-item" v-if="currentPage < pages.length" @click="currentPage++">
                <a class="page-link">Next</a>
                </li>
            </ul>
        </div>
      <div class="card-body px-0 pt-0 pb-2">
        <div class="table-responsive p-0">
          <table class="table align-items-center mb-0 table-striped">
            <thead>
              <tr>
                <th class="text-uppercase text-xs font-weight-bolder opacity-7">Professor</th>
                <th class="text-center text-uppercase text-xs font-weight-bolder opacity-7">Student</th>
                <th
                  class="text-center text-uppercase text-xs font-weight-bolder opacity-7"
                >Course</th>
                <th
                  class="text-center text-uppercase text-xs font-weight-bolder opacity-7"
                >Day</th>
                <th
                  class="text-center text-uppercase text-xs font-weight-bolder opacity-7"
                >Start</th>
                <th
                  class="text-center text-uppercase text-xs font-weight-bolder opacity-7"
                >End</th>
                <th
                  class="text-center text-uppercase text-xs font-weight-bolder opacity-7"
                >Status</th>
                <th
                  class="text-center text-uppercase text-xs font-weight-bolder opacity-7"
                >Action</th>
                
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in paginatedRows" :key="item.id">
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
                      <!-- <p class="text-xs text-secondary mb-0">john@creative-tim.com</p> -->
                    </div>
                  </div>
                </td>
                <td class="align-middle text-center text-sm">
                  <p class="text-xs font-weight-bold mb-0">{{ item.username }}</p>
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
                    <button v-if="item.stato == 0" class="btn btn-warning btn-sm my-auto" @click="deleteRepetition(item.idRipetizione)">Delete
                      <i class="fa fa-trash-o fa-2x" aria-hidden="true" style="margin-right:0.4rem;margin-top:0.5rem;font-size: medium;"></i>
                    </button>
                </td>
              </tr>
            </tbody>
          </table>
          
          <div class="float-rigth" style="margin-right:2%; margin-top: 2%;">
            <ul class="pagination ml-auto" style="float:right">
                <li class="page-item" v-if="currentPage > 1" @click="currentPage--">
                <a class="page-link">Prev</a>
                </li>
                <li class="page-item" :key="index"  v-for="(page, index) in pages"  :class="{ 'active': page === currentPage }"  @click="currentPage = page">
                <a class="page-link" :style="[page === currentPage ? {'color':'white','background-color':'#2dce89','border':'none'} : '']">{{ page }}</a>
                </li>
                <li class="page-item" v-if="currentPage < pages.length" @click="currentPage++">
                <a class="page-link">Next</a>
                </li>
            </ul>
        </div>
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
        currentPage: 1,
        perPage: 15,
        selectedProf: '',
        filteredData:'',
      };
    },
    mounted(){
        this.selectedProf = 'all';
        // this.filteredData = this.ripetizioni
        $('#selectTeacher option:odd').css({'background-color': '#f2f2f2'})
    },
    watch: {
    selectedProf: function (val) {
        this.currentPage = 1;
        if(val == "all")
            this.filteredData = this.ripetizioni;
        else
            this.filteredData = this.ripetizioni.filter(item => item.idDocente === val);
        //this.$emit("filtra",val);
        },
    ripetizioni: function(){
        this.filteredData = this.ripetizioni.filter(item => item.idDocente === this.selectedProf)
    }
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
    computed: {
    paginatedRows() {
        const start = (this.currentPage - 1) * this.perPage;
        const end = start + this.perPage;
        if(this.filteredData == '')
            return this.ripetizioni.slice(start, end);
        else
            return this.filteredData.slice(start, end);
    },
    pages() {
        if(this.filteredData == '')
            return Array.from(Array(Math.ceil(this.ripetizioni.length / this.perPage)).keys()).map(i => i + 1);
        else
            return Array.from(Array(Math.ceil(this.filteredData.length / this.perPage)).keys()).map(i => i + 1);
    },
    professors() {
        let professors = []
        for (let i = 0; i < this.ripetizioni.length; i++) {
            let duplicate = false;
            for (let j = 0; j < professors.length; j++) {
                if (professors[j].cognome === this.ripetizioni[i].cognomeDocente && professors[j].id === this.ripetizioni[i].idDocente) {
                    duplicate = true;
                    break;
                }
            }
            if (!duplicate) {
                professors.push({
                    id: this.ripetizioni[i].idDocente,
                    cognome: this.ripetizioni[i].cognomeDocente,
                    nome: this.ripetizioni[i].nomeDocente
                });
            }
        }
        return professors;
    }
  },
  
  };
  </script>
<style>
.attivo {
    /* i tuoi stili per la pagina corrente */
    background-color: #2dce89;
    color: white;
    border: 2px solid #2dce89;
}
.input{
    border-radius: 10px;
}
</style>