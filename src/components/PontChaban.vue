<template>
  <div class="flex-div">
    <div v-for="record in nextRecords" class="px-2">
      <article class="message">
        <div class="message-header">
          <i
            v-if="record.fields.bateau === 'MAINTENANCE'"
            class="fa-fw fas fa-wrench"
          ></i>
          <i v-else class="fa-fw fas fa-ship"></i>
          <p>{{ record.fields.bateau }}</p>
        </div>
        <div class="message-body">
          <div class="columns">
            <div class="column">Passage</div>
            <div class="column">
              <strong>{{
                moment(record.fields.date_passage).format("DD/MM/YYYY")
              }}</strong>
            </div>
          </div>
          <div class="columns">
            <div class="column">Fermeture</div>
            <div class="column">
              <strong>{{ record.fields.fermeture_a_la_circulation }}</strong>
            </div>
          </div>
          <div class="columns">
            <div class="column">Réouverture</div>
            <div class="column">
              <strong>{{ record.fields.re_ouverture_a_la_circulation }}</strong>
            </div>
          </div>
        </div>
      </article>
    </div>
  </div>
</template>
<script>
import moment from "moment";
const today = new Date();
const currentDate =
  today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
const date = today.getFullYear() + "-" + (today.getMonth() + 1); // + "-" + today.getDate();

export default {
  name: "PontChaban",
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
    for (let record of fetchedPassages.records) {
      if (this.validDate(record.fields.date_passage)) {
        this.nextRecords.push(record);
      }
    }
  },
  methods: {
    getPassage: function () {
      return fetch(
        "https://opendata.bordeaux-metropole.fr/api/records/1.0/search/?dataset=previsions_pont_chaban&q=&rows=20&sort=-date_passage&facet=bateau&refine.date_passage=" +
          date
      ).then(function (response) {
        if (response.status !== 200) {
          return;
        }
        return response.json();
      });
    },
    moment,
    validDate: function (date_passage) {
      return !moment(date_passage).isBefore(currentDate);
    },
  },
};
</script>

<style scoped></style>
