<template>
  <div v-if="item.type === 'Link'">
    <LinkService v-bind:item="item" />
  </div>
  <div v-else-if="item.type === 'MinecraftServer'">
    <MinecraftServer v-bind:item="item" />
  </div>
</template>

<script>
import LinkService from "@/components/LinkService";
import MinecraftServer from "@/components/MinecraftServerService";
export default {
  name: "Services",
  components: {
    MinecraftServer,
    LinkService,
  },
  props: {
    item: Object,
  },
};
</script>

<style scoped lang="scss"></style>
