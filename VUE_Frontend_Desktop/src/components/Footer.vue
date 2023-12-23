<template>
  <footer class="py-3 footer">
    <div class="container-fluid">
      <div class="row align-items-center justify-content-lg-between">
        <div class="mb-4 col-lg-6 mb-lg-0">
          <div
            class="text-sm text-center copyright text-muted"
            :class="this.$store.state.isRTL ? 'text-lg-end' : 'text-lg-start'"
          >
            ©
            {{ new Date().getFullYear() }}, made by
            <a
              href="https://www.linkedin.com/in/luca-dadone-8858a41a9/?originalSubdomain=it"
              class="font-weight-bold"
              target="_blank"
              >Luca Dadone</a
            > 
           <!-- &
            <a
              href="https://www.linkedin.com/in/davidebenotto/?trk=public_profile_samename-profile_profile-result-card_result-card_full-click&originalSubdomain=it"
              class="font-weight-bold"
              target="_blank"
              >Davide Benotto.</a
            > -->
          </div>
        </div>
       
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  name: "app-footer",
};
</script>
