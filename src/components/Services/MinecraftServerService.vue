<template>
  <div>
    <div class="card">
      <a :href="this.item.url" rel="noreferrer">
        <div class="card-content">
          <div class="media">
            <div class="media-left has-text-centered">
              <figure class="image is-32x32 mx-2">
                <img
                  v-if="server.online"
                  src="assets/tools/checked.svg"
                  alt="none"
                />
                <img v-else src="assets/tools/cancel.svg" alt="none" />
              </figure>
              <span v-if="server.online" class="has-text-success is-6"
                >Online</span
              >
              <span v-else class="has-text-danger is-6">Offline</span>
            </div>
            <div class="media-content">
              <p class="title is-4" v-html="this.server.description"></p>
            </div>
          </div>
          <div class="dropdown is-hoverable">
            <div class="dropdown-trigger">
              <div
                class="tag"
                aria-haspopup="true"
                aria-controls="dropdown-menu4"
              >
                <strong class="tag-text"
                  >{{ server.players.online }}/{{ server.players.max }}</strong
                >
              </div>
            </div>
            <div
              v-if="server.players.online > 0"
              class="dropdown-menu"
              id="dropdown-menu4"
              role="menu"
            >
              <div class="dropdown-content">
                <div class="dropdown-item">
                  <div v-for="player in server.players.sample">
                    <p>
                      <img width="16" :src="player.avatar" alt="" />

                      {{ player.name }}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </a>
    </div>
  </div>
</template>

<script>
export default {
  name: "MinecraftServerService",
  props: {
    item: Object,
  },
  data() {
    return {
      server: {
        hostname: null,
        port: null,
        players: {
          online: 0,
          max: 10,
          sample: {
            id: null,
            name: null,
            avatar: null,
          },
        },
        description: null,
      },
    };
  },
  created: async function () {
    this.server = await this.getServer();
  },
  methods: {
    getServer: function () {
      return fetch(
        "http://192.168.1.59:3000/server/" + this.item.hostname
      ).then(function (response) {
        if (response.ok) {
          return response.json();
        }
      });
    },
  },
};
</script>

<style scoped lang="scss"></style>
