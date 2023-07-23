<template>
  <div>
    <div class="is-inline-block">
      <i class="fas fa-angle-left navigation__buttons" @click="prevWeek"></i>
      <i class="fas fa-sync-alt navigation__buttons" @click="refresh"></i>
      <i class="fas fa-angle-right navigation__buttons" @click="nextWeek"></i>
      <h2 class="is-inline">
        {{ dayjs(date).locale("fr").format("MMMM YYYY").toUpperCase() }}
      </h2>
    </div>

    <div class="wrapper">
      <div class="agenda-column" v-for="(data, index) in this.edt.data" v-bind:key="index">
        <Day :courses="data.courses" :date="data.date" />
      </div>
    </div>
  </div>
</template>

<script  setup lang="ts">
import { ref } from "vue";
import Day from "./Day";
import dayjs from "dayjs";

const props = defineProps<{
  name: string
}>();

const date = ref<Date>()
const edt = ref<
  {
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
  }>({});

const postEDT = async () => {
  const requestOptions = {
    method: "POST",
    headers: { "Content-Type": "application/json" },
  };
  return await fetch(
    "https://malzik.ovh/api/" +
    "i1/g1" +
    "/" +
    date.value.format("DD-MM-YYYY"),
    requestOptions
  ).then(function (response) {
    if (response.ok) {
      return response.json();
    }
  });
};

const getEDT = async () => {
  return await fetch(
    "https://malzik.ovh/api/" +
    props.name +
    "/" +
    date.value.format("DD-MM-YYYY")
  ).then(function (response) {
    if (response.ok) {
      return response.json();
    }
  });
};

const nextWeek = () => {
  date.value = dayjs(date.value)
    .startOf("week")
    .add(1, "day")
    .add(1, "week");
  edt.value = getEDT();
};

const prevWeek = () => {
  date.value = dayjs(date.value)
    .startOf("week")
    .add(1, "day")
    .add(-1, "week");
  edt.value = getEDT();
};

const refresh = async () => {
  edt.value = await postEDT();
};

onMounted(async () => {
  date.value = dayjs().startOf("week").add(1, "day");
  edt.value = getEDT();
});
</script>

<style scoped lang="scss"></style>
