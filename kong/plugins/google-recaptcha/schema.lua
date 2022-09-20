local PLUGIN_NAME = "google-recaptcha"

return {
  name = PLUGIN_NAME,
  fields = {
    {
      config = {
        type = "record",
        fields = {
          {
            site_key = {
              type = "string",
              required = true,
            }
          },
          {
            secret_key = {
              type = "string",
              required = true,
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
      },
    }
  },
}

