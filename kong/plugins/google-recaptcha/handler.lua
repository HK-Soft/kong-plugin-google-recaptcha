local https = require "ssl.https"
local ltn12 = require "ltn12"
local json = require "cjson"

local plugin = {
  PRIORITY = 1000,
  VERSION = "0.1.0",
}

-- kong global variable
-- https://docs.konghq.com/gateway/latest/plugin-development/pdk/
local kong = kong
local api_server = 'https://www.google.com/recaptcha/api/siteverify'

function valid(secret_key, g_captcha_res, remote_ip)

  if not g_captcha_res then
    return nil, 'Missing required g-captcha-response'
  end
  if not remote_ip then
    return nil, 'Missing require remote_ip'
  end

  local request_body = {
    secret = secret_key,
    response = g_captcha_res,
    remoteip = remote_ip
  }

  request_body = json.encode(request_body)

  local response_body = {}

  local _, code, _, _ = https.request {
    url = api_server,
    method = 'POST',
    headers = {
      ["Content-Type"] = "application/json",
      ["Content-Length"] = string.len(request_body)
    },
    source = ltn12.source.string(request_body),
    sink = ltn12.sink.table(response_body)
  }
  response_body = json.decode(table.concat(response_body))

  if not response_body and code ~= 200 then
    return nil
  end
  if not response_body.success then
    return false, response_body['error-codes']
  end

  return true, nil, response_body.score, response_body.action
end

function plugin:access(config)
  kong.log.debug(string.format("Validating a recaptcha secret :: %s for site key %s ", config.version, config.site_key))

  local remote_ip = kong.client.get_ip()
  local g_captcha_response = kong.request.get_header("g_captcha_response")
  if not kong.api_server then
    kong.log.debug(string.format("Updating server api :: %s ", kong.api_server))
    api_server = kong.api_server
  end

  local status, err, score, action = valid(config.secret_key, g_captcha_response, remote_ip)
  kong.log.inspect({ status, err, score, action })

end

return plugin
