<template>
  <div v-if="this.nextRecords.length > 0" class="table-container">
    <table class="table is-fullwidth is-striped is-hoverable">
      <thead>
        <tr>
          <th>Bateau</th>
          <th>Date Passage</th>
          <th>Fermeture</th>
          <th>Réouverture</th>
        </tr>
      </thead>
      <tbody>
        <tr class="tr-body" v-for="record in nextRecords">
          <td>
            <p>
              <i
                v-if="record.fields.bateau === 'MAINTENANCE'"
                class="fa-fw fas fa-wrench"
              ></i>
              <i v-else class="fa-fw fas fa-ship"></i>
              {{ record.fields.bateau }}
            </p>
          </td>
          <td>
            <strong>{{
              dayjs(record.fields.date_passage).format("DD/MM/YYYY")
            }}</strong>
          </td>
          <td>{{ record.fields.fermeture_a_la_circulation }}</td>
          <td>{{ record.fields.re_ouverture_a_la_circulation }}</td>
        </tr>
      </tbody>
    </table>
  </div>
  <div v-else><h2>Pas de nouvelles fermetures</h2></div>
</template>
<script setup lang="ts">
import { ref, onMounted } from "vue";
import dayjs from "dayjs";

const today = new Date();
const filterDate = today.getFullYear() + "-" + (today.getMonth() + 1);

const props = defineProps<{
  row: unknown
}>();

const nextRecords = ref([]);

interface records {
  fields: {
          date_passage: null,
          type_de_fermeture: "",
          bateau: "",
          fermeture_a_la_circulation: "",
          fermeture_totale: "",
          re_ouverture_a_la_circulation: "",
        },
};


const getPassage= async () => {
      return fetch(
        "https://opendata.bordeaux-metropole.fr/api/records/1.0/search/?dataset=previsions_pont_chaban&q=&rows="+props.row+"&sort=-date_passage&facet=bateau&refine.date_passage=" +
          filterDate
      ).then(function (response) {
        if (response.status !== 200) {
          return;
        }
        return response.json();
      });
    };

const validDate = (date_passage) => {
      let date = new Date(date_passage);
      let today = new Date();
      return date.getTime() >= today.getTime();
    };


  onMounted(async () => {
    const fetchedPassages = await getPassage();
    for (let i = 0; i < props.row; i++) {
      if (validDate(fetchedPassages.records[i].fields.date_passage)) {
        nextRecords.value.push(fetchedPassages.records[i]);
      }
    }

  });
</script>

<style scoped></style>
