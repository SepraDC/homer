<template>
  <div class="container">
    <figure class="image is-16x16">
      <img v-if="server.online" src="assets/tools/checked.svg" />
      <img v-else src="assets/tools/cancel.svg" />
    </figure>
    <div v-for="line in this.server.motd.html" v-html="line"></div>
    <div class="dropdown">
      <div class="dropdown-trigger">
        <button
          class="button"
          aria-haspopup="true"
          aria-controls="dropdown-menu3"
        >
          <span>{{ server.players.online }}/{{ server.players.max }}</span>
        </button>
      </div>
      <div class="dropdown-menu" id="dropdown-menu3" role="menu">
        <div class="dropdown-content">
          <a
            v-for="player in server.players.list"
            href="#"
            class="dropdown-item"
          >
            {{ player }}
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "MinecraftServer",
  props: {
    hostname: null,
  },
  data() {
    return {
      server: {
        ip: null,
        port: null,
        motd: {
          html: {},
        },
        players: {
          online: 0,
          max: 10,
          list: {},
        },
        online: false,
      },
    };
  },
  created: async function () {
    const fetchedMessage = await this.getServer();
    console.log(fetchedMessage);
    this.server = fetchedMessage;
  },
  methods: {
    getServer: function () {
      return fetch("https://api.mcsrvstat.us/2/" + this.hostname).then(
        function (response) {
          if (response.status != 200) {
            return;
          }
          return response.json();
        }
      );
    },
  },
};
</script>

<style scoped></style>
