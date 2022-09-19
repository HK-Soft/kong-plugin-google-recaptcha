-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

--assert(ngx.get_phase() == "timer", "The world is coming to an end!")

local plugin = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1.0", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}

-- kong global variable
-- https://docs.konghq.com/gateway/latest/plugin-development/pdk/
local kong = kong

function plugin:access(config)
  -- Implement logic for the access phase here (http)
  kong.log.debug('starting the access process')
  local site_key = config.site_key
  local secret_key = config.secret_key

  kong.log.debug('instancing recaptcha')
  local recaptcha = require 'recaptcha'
  local captcha   = recaptcha:new(site_key, secret_key)

  local remote_ip = kong.client.get_ip()
  local g_captcha_response = kong.request.get_header("g_captcha_response")

  kong.log.inspect(site_key)
  kong.log.inspect(secret_key)
  kong.log.inspect(remote_ip)
  kong.log.inspect(g_captcha_response)

  if captcha.valid(g_captcha_response, remote_ip) then
    kong.log.inspect('valid captcha')
  end
end

-- return our plugin object
return plugin
