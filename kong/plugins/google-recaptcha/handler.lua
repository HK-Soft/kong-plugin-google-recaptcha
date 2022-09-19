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

-- runs in the 'access_by_lua_block'
function plugin:access(plugin_conf)

  -- your custom code here
  -- kong.log.inspect(plugin_conf)   -- check the logs for a pretty-printed config!
  kong.log("recaptcha plugin", "recaptcha plugin")

end --]]


-- return our plugin object
return plugin
