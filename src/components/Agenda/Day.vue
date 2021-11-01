<template>
  <div class="message">
    <div class="message-header" style="font-size: 0.95em">
      {{ moment(date).locale("fr").format("dddd D").toUpperCase() }}
    </div>
    <div class="message-body agenda-day">
      <h3 v-if="courses.length === 0" class="mx-auto">Aucun cours</h3>
      <div
        v-else
        v-for="(course, index) in courses"
        v-bind:key="index"
        class="course has-tooltip-multiline"
        :style="{ 'grid-row': position(course.debut, course.fin) }"
        :data-tooltip="course.prof"
      >
        <div>
          <span>{{ course.debut }}-{{ course.fin }}</span>
          <span
            class="tag"
            v-if="
              !course.salle.startsWith('SALLE') &&
              !course.salle.startsWith('NS')
            "
            >{{ course.salle }}</span
          >
          <span class="tag" v-else> Visio</span>
        </div>
        <span class="has-text-weight-bold is-block is-full">
          {{ course.matiere }}</span
        >
      </div>
      <div
        v-if="courses.length > 0"
        class="repas has-background-success"
        style="grid-row: 5 / 5"
      >
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
      const startTime = start.split(":")[0];
      const endTime = end.split(":")[0];

      return (startTime - 7).toString() + " / " + (endTime - 7).toString();
    },
  },
};
</script>

<style scoped></style>
