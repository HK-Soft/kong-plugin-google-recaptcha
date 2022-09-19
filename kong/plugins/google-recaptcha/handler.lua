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

kong.log("recaptcha plugin before", "recaptcha plugin before");

function plugin:init_worker()
  -- Implement logic for the init_worker phase here (http/stream)
  kong.log.plugin("init_worker")
end


function plugin:preread(config)
  -- Implement logic for the preread phase here (stream)
  kong.log.plugin("preread")
end


function plugin:certificate(config)
  -- Implement logic for the certificate phase here (http/stream)
  kong.log.plugin("certificate")
end

function plugin:rewrite(config)
  -- Implement logic for the rewrite phase here (http)
  kong.log.plugin("rewrite")
end

function plugin:access(config)
  -- Implement logic for the access phase here (http)
  kong.log.plugin("access")
end

function plugin:ws_handshake(config)
  -- Implement logic for the WebSocket handshake here
  kong.log.plugin("ws_handshake")
end

function plugin:header_filter(config)
  -- Implement logic for the header_filter phase here (http)
  kong.log.plugin("header_filter")
end

function plugin:ws_client_frame(config)
  -- Implement logic for WebSocket client messages here
  kong.log.plugin("ws_client_frame")
end

function plugin:ws_upstream_frame(config)
  -- Implement logic for WebSocket upstream messages here
  kong.log.plugin("ws_upstream_frame")
end

function plugin:body_filter(config)
  -- Implement logic for the body_filter phase here (http)
  kong.log.plugin("body_filter")
end

function plugin:log(config)
  -- Implement logic for the log phase here (http/stream)
  kong.log.plugin("log")
end

function plugin:ws_close(config)
  -- Implement logic for WebSocket post-connection here
  kong.log.plugin("ws_close")
end


-- return our plugin object
return plugin
