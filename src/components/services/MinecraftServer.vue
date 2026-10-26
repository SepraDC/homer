<template>
  <Generic :item="item">
    <template #indicator>
      <div v-if="status" class="status" :class="status">
        {{ status }}
      </div>
    </template>
    <template #content>
      <p class="title is-4">{{ item.name }}</p>
      <p class="subtitle is-6">
        <template v-if="item.subtitle">{{ item.subtitle }}</template>
        <template v-else-if="motd">{{ motd }}</template>
      </p>
      <p v-if="status === 'online'" class="players" :title="playerNames">
        <i class="fa-fw fas fa-users"></i>
        {{ players.online }}/{{ players.max }}
        <img
          v-for="player in players.list"
          :key="player.uuid"
          :src="`https://mc-heads.net/avatar/${player.uuid}/16`"
          :alt="player.name"
          width="16"
          height="16"
        />
      </p>
    </template>
  </Generic>
</template>

<script>
import service from "@/mixins/service.js";

export default {
  name: "MinecraftServer",
  mixins: [service],
  props: {
    item: Object,
  },
  data: () => ({
    status: null,
    motd: null,
    players: { online: 0, max: 0, list: [] },
  }),
  computed: {
    playerNames: function () {
      return this.players.list.map((player) => player.name).join(", ");
    },
  },
  created() {
    this.autoUpdateMethod = this.fetchStatus;
    this.fetchStatus();
  },
  methods: {
    fetchStatus: async function () {
      // mcsrvstat.us by default, any API answering the same format works through `endpoint`.
      const api = this.item.endpoint || "https://api.mcsrvstat.us/3";

      // Third-party public API: the service mixin fetch (proxy, item url) does not apply.
      try {
        const response = await fetch(`${api}/${this.item.hostname}`);
        if (!response.ok) {
          throw Error(response.statusText);
        }
        const server = await response.json();
        this.status = server.online ? "online" : "offline";
        this.motd = server.motd?.clean?.join(" ") ?? null;
        this.players = {
          online: server.players?.online ?? 0,
          max: server.players?.max ?? 0,
          list: server.players?.list ?? [],
        };
      } catch (e) {
        console.error(e);
        this.status = "offline";
      }
    },
  },
};
</script>

<style scoped lang="scss">
.status {
  font-size: 0.8rem;
  color: var(--text-title);
  white-space: nowrap;
  margin-left: 0.25rem;

  &.online:before {
    background-color: #94e185;
    border-color: #78d965;
    box-shadow: 0 0 5px 1px #94e185;
  }

  &.offline:before {
    background-color: #c9404d;
    border-color: #c42c3b;
    box-shadow: 0 0 5px 1px #c9404d;
  }

  &:before {
    content: " ";
    display: inline-block;
    width: 7px;
    height: 7px;
    margin-right: 10px;
    border: 1px solid #000;
    border-radius: 7px;
  }
}

.players {
  font-size: 0.85rem;
  color: var(--text-subtitle);

  img {
    vertical-align: middle;
    margin-left: 2px;
  }
}
</style>
