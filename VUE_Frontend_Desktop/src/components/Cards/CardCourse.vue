<template>
  <div v-if="this.showDelete">
    <argon-alert color="info" icon="ni ni-like-2 ni-lg" dismissible>
      Teacher correctly deleted from {{ this.$route.query.nome }}
    </argon-alert>
  </div>
  <div @click="router(id,title)" class="mb-5 card course-background-image " :style="{ 'background-image': `url(${backgroundImage})` }">
    <div class="p-4 card-body d-flex" :style="`height:100%,`" :class="directionReverse ? reverseDirection : ''">
      <div>
        <!-- admin mode -->
        <div @click.stop="deleteCourse(id)"  v-if="this.$store.state.role == 0" class="text-center icon icon-shape" :class="`${'border-radius-2xl'}`" style="background-color:red;">
          <i class="text-lg opacity-10 fa fa-trash" aria-hidden="true" style="color:white"></i>
        </div>
      </div>   
      <div class="myCardCenter">
        <h5 class="font-weight-bolder my-text-title">
          {{ title }}
        </h5>
      </div>   
    </div>
  </div>  

</template>

<style>
  .course-background-image{
     background-size: cover;
      height:220px;
  }
  .my-text-title{
    color:rgb(255, 255, 255);/* rgb(41, 51, 122);/*#30cc8c;*/
    font-size: medium;
     /* Aggiungi un bordo nero alle lettere */
    text-shadow: -1px -1px 0 #636363, 1px -1px 0 #636363, -1px 1px 0 #636363, 1px 1px 0 #636363;

  }

  .myCardCenter {
    height:40%;
    width: 40%;

    background-color:rgba(203, 203, 203, 0.541);/* #30cc8c;/*rgba(0, 159, 119, 0.75);*/
    text-align: center;
    border-radius: 15px;
    border: 1px solid rgba(255, 255, 255, 0.61);

    /*per centrare contenitore*/
    margin: 0 auto;
    margin-top: auto;
    margin-bottom: auto;

    /* per centrare scritta nel contenitore*/
    display: flex;
    align-items: center;
    justify-content: center;
  }
</style>


<script>
import $ from 'jquery'
export default {
  name: "CardCourse",
  data() {
    return {
      servlets: {
          courses: 'http://localhost:8084/first_vue_implementation_war_exploded/courses',
        },
    
    };
  },
  methods:{
    async deleteCourse(id){
        //alert(idCorso + " " + idDocente)
        var self = this;
        await $.post(self.servlets.courses+';jsessionid='+self.$store.state.sessionId, 
        {
          id: id,
          action: "delete-course"
        },
        function (response) {
          self.$emit('aggiorna', response.status)
        });
      },
    router(id,title){
      this.$router.push({ path: '/course-teachers', query: { id: id, nome: title } });
    }
  },
  props: {
    title: {
      type: String,
      required: true,
    },
    titleColor: {
      type: String,
    },
    iconClass: {
      type: String,
      required: true,
    },
    iconBackground: {
      type: String,
      default: "bg-white",
    },
    backgroundImage: {
      type: String,
    },
    id:{
      type: Number,
      required: true
    }
  },
};
</script>
  