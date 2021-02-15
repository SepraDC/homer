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
              moment(record.fields.date_passage).format("DD/MM/YYYY")
            }}</strong>
          </td>
          <td>{{ record.fields.fermeture_a_la_circulation }}</td>
          <td>{{ record.fields.re_ouverture_a_la_circulation }}</td>
        </tr>
      </tbody>
    </table>
  </div>
  <div v-else><h1>Pas de nouvelles fermetures</h1></div>
</template>
<script>
import moment from "moment";
export const today = new Date();
const filterDate = today.getFullYear() + "-" + (today.getMonth() + 1);
export default {
  name: "PontChaban",
  props: {
    row: null,
  },
  data() {
    return {
      nextRecords: [],
      records: {
        fields: {
          date_passage: null,
          type_de_fermeture: "",
          bateau: "",
          fermeture_a_la_circulation: "",
          fermeture_totale: "",
          re_ouverture_a_la_circulation: "",
        },
      },
    };
  },
  created: async function () {
    const fetchedPassages = await this.getPassage();
    for (let i = 0; i < this.row; i++) {
      if (this.validDate(fetchedPassages.records[i].fields.date_passage)) {
        this.nextRecords.push(fetchedPassages.records[i]);
      }
    }
  },
  methods: {
    getPassage: function () {
      return fetch(
        "https://opendata.bordeaux-metropole.fr/api/records/1.0/search/?dataset=previsions_pont_chaban&q=&rows=20&sort=-date_passage&facet=bateau&refine.date_passage=" +
          filterDate
      ).then(function (response) {
        if (response.status !== 200) {
          return;
        }
        return response.json();
      });
    },
    moment,
    validDate: function (date_passage) {
      let date = new Date(date_passage);
      let today = new Date();
      return date.getTime() > today.getTime();
    },
  },
};
</script>

<style scoped></style>
