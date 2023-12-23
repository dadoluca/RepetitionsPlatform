<template>
    <div class="card card-profile" :style="`background-size: cover; width:405px;  max-width: 100%;`">
      <img :src="placeholderImage" :style="`background-size: cover; height:170px;`"
      class="card-img-top" />
      <div class="row justify-content-center">
        <div class="col-4 col-lg-4 order-lg-2">
          <div class="mt-n4 mt-lg-n6 mb-4 mb-lg-0" >
            <a href="javascript:;">
                <div
                :style="{
                    'background-image': 'url(' + avatarImage + ')',
                    'background-size': 'cover',
                    'background-position': 'center',    
                    height: '112px',            
                    width: '112px',     
                    }"
                class="rounded-circle border border-3 border-white"
                ></div>
            </a>
          </div>
        </div>
      </div>
      <div class="card-header text-center border-0 pt-0 pt-lg-2 pb-4 pb-lg-3">
        <div class="d-flex justify-content-between">
        <router-link v-if="isAuth && this.$store.state.role !== 0" v-bind:to="{ path: '/teacher-availability', query: { teacherId: id, teacherName: nome, teacherSurname:cognome, teacherUrl:avatarImage, courseId:courseId } }">
          <a href="javascript:;" class="btn btn-sm btn-info mb-0 d-none d-lg-block">Book a Lesson!</a>
        </router-link>
        <router-link v-else-if="this.$store.state.role === 0" v-bind:to="{ path: '/teacher-availability', query: { teacherId: id, teacherName: nome, teacherSurname:cognome, teacherUrl:avatarImage, courseId:courseId}}">
            <a href="javascript:;" class="btn btn-sm btn-info mb-0 d-none d-lg-block">View Availability</a>
        </router-link>
        <router-link  v-else v-bind:to="{ path: '/signin', query: { bookRequest: true } }">
          <a href="javascript:;" class="btn btn-sm btn-info mb-0 d-none d-lg-block">Book a Lesson!</a>
        </router-link>
          <a href="javascript:;" class="btn btn-sm btn-info mb-0 d-block d-lg-none">
            <i class="ni ni-collection"></i>
          </a>
          <a
            :href="`mailto:${email}`"
            class="btn btn-sm btn-dark float-right mb-0 d-none d-lg-block"
          >Send a Message</a>
          <a  class="btn btn-sm btn-dark float-right mb-0 d-block d-lg-none">
            <i class="ni ni-email-83"></i>
          </a>
        </div>
      </div>
      <div class="card-body pt-0">
        <div class="text-center mt-4">
          <h5>
            {{nome}} {{cognome}}
            <span class="font-weight-light"><br> {{eta}} years old</span>
          </h5>

          <div class="h6 mt-4">
            {{formazione}}
          </div>
          <div style="display: flex; justify-content: center;">
            <div style="border: 1px solid #30cc8c;; border-radius: 10%; width: 25%;">
                Price:<p style="color: green;font-weight: bold;"> {{prezzoH}} €/h</p>            
            </div>
          </div>
                
        </div>
        <!-- questo lo vedo se sono admin e sto visualizzando tutti i docenti -->
        <div v-if="this.$store.state.role === 0 && !courseTeacher" class="text-center mt-4">
          <button  class="btn btn-warning btn-sm my-auto" @click="deleteTeacher(id)">Delete Teacher
            <i class="fa fa-trash-o fa-2x" aria-hidden="true" style="margin-right:0.4rem;margin-top:0.5rem;font-size: medium;"></i>
          </button> 
        </div>
        <!-- questo lo vedo se sono admin e sto visualizzando i docenti di uno specifico corso-->
        <div v-if="this.$store.state.role === 0 && courseTeacher" class="text-center mt-4">
          <button  class="btn btn-warning btn-sm my-auto" @click="deleteCourseTeacher(courseId, id)">Delete from {{ this.$route.query.nome }}
            <i class="fa fa-trash-o fa-2x" aria-hidden="true" style="margin-right:0.4rem;margin-top:0.5rem;font-size: medium;"></i>
          </button> 
        </div>
      </div>
    </div>
  </template>



<script>
import $ from 'jquery'
export default {
  name: "CardTeacher",
  data() {
    return {
      reverseDirection: "flex-row-reverse justify-content-between",
      servlets: {
          teachers: 'http://localhost:8084/first_vue_implementation_war_exploded/teachers',
          courses: 'http://localhost:8084/first_vue_implementation_war_exploded/courses',
        },
    };
  },
  methods:{
    deleteTeacher(idTeacher){
      var self = this;
      //alert(idTeacher);
      $.post(self.servlets.teachers+';jsessionid='+self.$store.state.sessionId, 
      {
        idDocente: idTeacher,
        action: "delete"
      },
      function (response) {
        if(response.status == "OK"){
          //alert("operazione avvenuta con successo")
          self.$emit('aggiorna');
        }
          
      });
    },
    deleteCourseTeacher(courseId, teacherId){
      //alert(idCorso + " " + idDocente)
      var self = this;
      //alert(courseId)
      //alert(idTeacher);
      $.post(self.servlets.courses+';jsessionid='+self.$store.state.sessionId, 
      {
        idDocente: teacherId,
        idCorso: courseId,
        action: "delete-course-teacher"
      },
      function (response) {
        if(response.status == "OK"){
          //alert("operazione avvenuta con successo")
          self.$emit('aggiorna',"delete");  
        }
          
      });
    }
  },
  computed: {
    isAuth() {
      return this.$store.state.isAuth;
    },
  },
  props: {
    directionReverse: Boolean,
    courseId: {
      type: String,
      required: true,
    },
    id: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    nome: {
      type: String,
      required: true,
    },
    cognome: {
      type: String,
    },
    sesso: {
      type: String,
    },
    eta: {
      type: String,
    },
    formazione: {
      type: String,
    },
    prezzoH: {
      type: String,
      default: "not specified",
    },
    avatarImage: {
      type: String,
    },
    placeholderImage: {
      type: String,
    },
    courseTeacher:{
      type: Boolean
    }
  },
};
</script>