<template>
  <div class="message">
    <div class="message-header" style="font-size: 0.95em">
      {{ moment(date).locale("fr").format("dddd ll").toUpperCase() }}
    </div>
    <div class="message-body agenda-day">
      <div v-for="(course, index) in courses" v-bind:key="index"
           class="course"
           :style="{'grid-row': position(course.debut, course.fin)}">
        <div>
          <span>{{ course.debut }}-{{course.fin }}</span>
          <span class="tag" v-if="!course.salle.startsWith('SALLE') && !course.salle.startsWith('NS')">{{ course.salle }}</span>
          <span class="tag" v-else> Visio</span>
        </div>
        <span class="has-text-weight-bold is-block is-full">{{
            course.matiere.length > 30 ? course.matiere.substring(0, 30) + "..." : course.matiere
          }}</span>
        <span class="is-block is-full has-text-right">{{ course.prof }}</span>
      </div>
      <div class="repas has-background-success" style="grid-row: 5 / 5">
        Repas
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
    // console.log(this.courses);
  },
  methods: {
    moment,
    position(start, end) {
      const startTime = start.split(':')[0]
      const endTime = end.split(':')[0]

      return (startTime - 7).toString() + ' / ' + (endTime - 7).toString()
    }
  },
};
</script>

<style scoped></style>
