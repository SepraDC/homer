<template>
  <div>
    <div class="is-inline-block">
      <i
        class="fas fa-angle-left navigation__buttons"
        v-on:click="prevWeek"
      ></i>
      <i class="fas fa-sync-alt navigation__buttons" v-on:click="refresh"></i>
      <i
        class="fas fa-angle-right navigation__buttons"
        v-on:click="nextWeek"
      ></i>
      <h2 class="is-inline">
        {{ moment(date).locale("fr").format("MMMM YYYY").toUpperCase() }}
      </h2>
    </div>

    <div class="wrapper">
      <div
        class="agenda-column"
        v-for="(data, index) in this.edt.data"
        v-bind:key="index"
      >
        <Day :courses="data.courses" :date="data.date" />
      </div>
    </div>
  </div>
</template>

<script>
import moment from "moment";
import Day from "./Day";

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
    postEDT: function () {
      const requestOptions = {
        method: "POST",
        headers: { "Content-Type": "application/json" },
      };
      return fetch(
        "https://malzik.ovh/api/" +
          "i1/g1" +
          "/" +
          this.date.format("DD-MM-YYYY"),
        requestOptions
      ).then(function (response) {
        if (response.ok) {
          return response.json();
        }
      });
    },
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
    async refresh() {
      this.edt = await this.postEDT();
    },
    moment,
  },
};
</script>

<style scoped lang="scss"></style>
