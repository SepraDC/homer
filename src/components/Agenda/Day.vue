<template>
  <div class="message">
    <div class="message-header" style="font-size: 0.95em;">
      {{ moment(date).locale("fr").format("dddd ll").toUpperCase() }}
    </div>
    <div class="message-body">
      <div v-for="(course, index) in courses" v-bind:key="index">
        <div class="course" v-if="course === null">
          Pas de cours ce jour
        </div>
        <div v-else class="course">
          <div>
            <span>{{ course.debut }}-{{ course.fin }}</span>
            <span class="tag" v-if="!course.salle.startsWith('SALLE')">
              {{ course.salle }}
            </span>
            <span class="tag" v-else> Visio</span>
          </div>
          {{ course.matiere }}
        </div>
        <div
          v-if="
            parseInt(course.fin.split(':')[0]) === 13 && courses[index + 1]
          "
          class="repas has-background-success"
        >
          Repas
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from "moment";
export default {
  name: "Day",
  props: {
    date: null,
    courses: null,
  },
  created() {
    console.log(this.courses);
  },
  methods: {
    moment,
  },
};
</script>

<style scoped></style>
