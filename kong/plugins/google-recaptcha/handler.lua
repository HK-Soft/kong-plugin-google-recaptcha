-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

--assert(ngx.get_phase() == "timer", "The world is coming to an end!")

local https = require "ssl.https"
local ltn12 = require "ltn12"
local json = require "cjson"

local plugin = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1.0", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}

-- kong global variable
-- https://docs.konghq.com/gateway/latest/plugin-development/pdk/
local kong = kong

function valid(secret_key, g_captcha_res, remote_ip)
  print('in the valid method')
  if not g_captcha_res then
    return nil, 'Missing required g-captcha-response'
  end
  if not remote_ip then
    return nil, 'Missing require remote_ip'
  end

  local api_server = 'https://www.google.com/recaptcha/api/siteverify'
  kong.log.inspect(api_server)
  local request_body = {
    secret = secret_key,
    response = g_captcha_res,
    remoteip = remote_ip
  }
  kong.log.inspect(request_body)
  request_body = json.encode(request_body)
  kong.log.inspect(request_body)
  local response_body = {}

  local res, code, headers, status = https.request {
    url = api_server,
    method = 'POST',
    headers = {
      ["Content-Type"] = "application/json",
      ["Content-Length"] = string.len(request_body)
    },
    source = ltn12.source.string(request_body),
    sink = ltn12.sink.table(response_body)
  }
  response_body = table.concat(response_body)
  local jsonResp = json.decode(response_body)
  kong.log.inspect(jsonResp)
  kong.log.inspect(jsonResp["error-codes"])
  kong.log.inspect(jsonResp.success)
  kong.log.inspect({res, code, headers, status})


  return true
end

function plugin:access(config)
  -- Implement logic for the access phase here (http)
  kong.log.debug('starting the access process')
  local site_key = config.site_key
  local secret_key = config.secret_key

  local remote_ip = kong.client.get_ip()
  local g_captcha_response = kong.request.get_header("g_captcha_response")

  kong.log.inspect(site_key)
  kong.log.inspect(secret_key)
  kong.log.inspect(remote_ip)
  kong.log.inspect(g_captcha_response)
  kong.log.inspect(http)

  local v, m = valid(secret_key, g_captcha_response, remote_ip)
  kong.log.inspect(v)
  kong.log.inspect(m)

end

-- return our plugin object
return plugin
