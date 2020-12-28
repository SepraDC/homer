<template>
  <article v-if="show" class="message" :class="message.style">
    <div v-if="message.title || message.icon" class="message-header">
      <p>
        <i v-if="message.icon" :class="`fa-fw ${message.icon}`"></i>
        {{ message.title }}
      </p>
    </div>
    <div class="message-body">
      <div v-if="message.content" v-html="message.content"></div>
      <span
        v-if="message.author"
        class="is-italic is-inline-block has-text-right"
        style="width: 100%;"
        v-html="message.author"
      ></span>
    </div>
  </article>
</template>

<script>
export default {
  name: "Message",
  props: {
    item: Object,
  },
  data: function () {
    return {
      show: false,
      message: {},
    };
  },
  created: async function () {
    // Look for a new message if an endpoint is provided.
    this.message = Object.assign({}, this.item);
    if (this.item && this.item.url) {
      const fetchedMessage = await this.getMessage(this.item.url);
      // keep the original config value if no value is provided by the endpoint
      for (const prop of ["title", "style", "content"]) {
        if (prop in fetchedMessage && fetchedMessage[prop] !== null) {
          this.message[prop] = fetchedMessage[prop];
        }
      }
    } else if (!this.item) {
      const fetchedQuotes = await this.getQuotes();
      this.message.title = "💬 Citation du jour";
      this.message.content = fetchedQuotes.contents.quotes[0].quote;
      this.message.author = fetchedQuotes.contents.quotes[0].author;
    }

    this.show = this.message.title || this.message.content;
  },
  methods: {
    getQuotes: function () {
      return fetch("https://quotes.rest/qod").then(function (response) {
        if (response.status != 200) {
          return;
        }
        return response.json();
      });
    },
    getMessage: function (url) {
      return fetch(url).then(function (response) {
        if (response.status != 200) {
          return;
        }
        return response.json();
      });
    },
  },
};
</script>
