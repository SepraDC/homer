<template>
  <div class="is-flex mx-1">
    <div class="changeWeek" v-on:click="prevWeek">
      <i class="fas fa-angle-left"></i>
    </div>
    <div class="columns is-1">
      <div
        class="column mx-2"
        v-for="(data, index) in this.edt.data"
        v-bind:key="index"
      >
        <Day :courses="data.courses" :date="data.date" />
      </div>
    </div>
    <div class="changeWeek" v-on:click="nextWeek">
      <i class="fas fa-angle-right"></i>
    </div>
  </div>
</template>

<script>
import moment from "moment";
import Day from "@/components/Agenda/Day";
export default {
  name: "Agenda",
  components: {
    Day,
  },
  props: {
    name: null,
  },
  data() {
    return {
      date: null,
      edt: {
        data: {
          date: null,
          courses: {
            debut: "",
            fin: "",
            matiere: "",
            prof: "",
            salle: "",
          },
        },
      },
    };
  },
  created: async function () {
    this.date = moment().startOf("week").add(1, "day");
    this.edt = await this.getEDT();
  },
  methods: {
    getEDT: function () {
      return fetch(
        "https://malzik.ovh/api/" +
          this.name +
          "/" +
          this.date.format("DD-MM-YYYY")
      ).then(function (response) {
        if (response.ok) {
          return response.json();
        }
      });
    },
    async nextWeek() {
      this.date = moment(this.date)
        .startOf("week")
        .add(1, "day")
        .add(1, "week");
      this.edt = await this.getEDT();
    },
    async prevWeek() {
      this.date = moment(this.date)
        .startOf("week")
        .add(1, "day")
        .add(-1, "week");
      this.edt = await this.getEDT();
    },
    moment,
  },
};
</script>

<style scoped lang="scss"></style>
