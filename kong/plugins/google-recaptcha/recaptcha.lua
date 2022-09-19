---
--- Created by Abdeldjalil.
--- DateTime: 9/19/2022
---

local requests = require 'requests'
local api_server = 'https://www.google.com/recaptcha/api/siteverify'
local site_key, secret_key

local recaptcha = {}

function recaptcha:new(config_site_key, config_secret_key)
  print('inside recaptcha constructor')
  if not config_site_key then return nil, 'Missing required site_key' end
  if not config_secret_key then return nil, 'Missing required secret_key' end
  site_key = config_site_key
  secret_key = config_secret_key
  return self
end


function recaptcha.valid(g_captcha_res, remote_ip)
  if not g_captcha_res then return nil, 'Missing required g-captcha-response' end
  if not remote_ip then return nil, 'Missing require remote_ip' end
  print('inside recaptcha valid')
  local data =  {
    secret   = secret_key,
    response = g_captcha_res,
    remoteip = remote_id
  }
  print('inside recaptcha valid before requests.post')
  local response  = requests.post(api_server, { data = recaptcha.encode_url(data) })
  print('inside recaptcha valid after requests.post')
  local json, err = response.json()
  print(json)
  if not json then return nil, err end
  if not json.success then return false, json['error-codes'] end
  return true
end

-- encode string into escaped hexadecimal representation
-- from socket.url implementation
function recaptcha.escape(s)
  return (string.gsub(s, "([^A-Za-z0-9_])", function(c)
    return string.format("%%%02x", string.byte(c))
  end))
end

-- encode url
function recaptcha.encode_url(args)
  local params = {}
  for k, v in pairs(args) do table.insert(params, k .. '=' .. recaptcha.escape(v)) end
  return table.concat(params, "&")
end


return recaptcha
