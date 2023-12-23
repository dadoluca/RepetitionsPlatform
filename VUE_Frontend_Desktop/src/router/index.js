import { createRouter, createWebHistory } from "vue-router";
import Signin from "../views/Signin.vue"; 

// [
import CoursesView from  "../views/CoursesView.vue";
import TeachersView from "../views/TeachersView.vue";
import CourseTeachersView from "../views/CourseTeachersView.vue";
import TeacherAvailability from "../views/TeacherAvailabilityView.vue";
import UserRepetitions from "../views/UserRepetitionsView.vue";
import AdminRepetitions from "../views/AdminRepetitionsView.vue";
// ]

const routes = [
  {
    path: "/",
    name: "/",
    redirect: "/courses",
  },
  // [
  {
    path: "/courses",
    name: "Courses",
    component: CoursesView,
  },
  {
    path: "/teachers",
    name: "Teachers",
    component: TeachersView,
  },
  {
    path: '/course-teachers',
    name: "Course Teachers",
    component: CourseTeachersView,
  },
  {
    path: '/teacher-availability',
    name: "Teacher Availability",
    component: TeacherAvailability,
  },
  {
    path: '/user-repetitions',
    name: "User Lessons",
    component: UserRepetitions,
  },
  {
    path: '/admin-repetitions',
    name: "Admin Lessons",
    component: AdminRepetitions,
  },
  // ]
  {
    path: "/signin",
    name: "Signin",
    component: Signin,
  },
  
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
  linkActiveClass: "active",
});

export default router;
