local PLUGIN_NAME = "google-recaptcha"

return {
  name = PLUGIN_NAME,
  fields = {
    {
      config = {
        type = "record",
        fields = {
          -- Describe your plugin's configuration's schema here.
          site_key = {
            type = "string",
            required = true,
          },
          {
            site_secret = {
              type = "string",
              default = true,
            },
          },
          {
            version = {
              type = "string",
              default = "v2",
              one_of = {
                "v2",
                "v3",
              },
            },
          },
        },
      }
    },
  },
  entity_checks = {
  },
}
