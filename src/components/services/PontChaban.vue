<template>
  <Generic :item="item">
    <template #content>
      <p class="title is-4">{{ item.name }}</p>
      <p v-if="error" class="subtitle is-6">Prévisions indisponibles</p>
      <p v-else-if="closures.length === 0" class="subtitle is-6">
        Pas de fermeture prévue
      </p>
      <ul v-else class="closures">
        <li v-for="closure in closures" :key="closure.key" :title="closure.boat">
          <i
            :class="[
              'fa-fw',
              'fas',
              closure.maintenance ? 'fa-wrench' : 'fa-ship',
            ]"
          ></i>
          <strong>{{ closure.date }}</strong>
          {{ closure.from }} → {{ closure.to }}
          <span class="boat">{{ closure.boat }}</span>
        </li>
      </ul>
    </template>
  </Generic>
</template>

<script>
const API =
  "https://opendata.bordeaux-metropole.fr/api/explore/v2.1/catalog/datasets/previsions_pont_chaban/records";

export default {
  name: "PontChaban",
  props: {
    item: Object,
  },
  data: () => ({
    closures: [],
    error: false,
  }),
  created() {
    this.fetchClosures();
  },
  methods: {
    fetchClosures: async function () {
      const params = new URLSearchParams({
        where: "date_passage >= now()",
        order_by: "date_passage",
        limit: parseInt(this.item.rows, 10) || 3,
      });

      // Third-party public API: the service mixin fetch (proxy, item url) does not apply.
      try {
        const response = await fetch(`${API}?${params}`);
        if (!response.ok) {
          throw Error(response.statusText);
        }
        const { results } = await response.json();
        this.closures = results.map((record, index) => ({
          key: `${record.date_passage}-${index}`,
          date: new Date(record.date_passage).toLocaleDateString("fr-FR", {
            weekday: "short",
            day: "2-digit",
            month: "2-digit",
          }),
          from: record.fermeture_a_la_circulation,
          to: record.re_ouverture_a_la_circulation,
          boat: record.bateau,
          maintenance: record.bateau === "MAINTENANCE",
        }));
      } catch (e) {
        console.error(e);
        this.error = true;
      }
    },
  },
};
</script>

<style scoped lang="scss">
// The closures list does not fit in the fixed height of a regular card
:deep(.card-content) {
  height: auto;
  min-height: 85px;
}

.closures {
  font-size: 0.85rem;
  color: var(--text-subtitle);

  li {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .boat {
    font-style: italic;
  }
}
</style>
