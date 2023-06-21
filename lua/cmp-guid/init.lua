local source = {}

local charset = {}  do -- [0-9a-z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 97, 102 do table.insert(charset, string.char(c)) end
end

local function uid(len)
  if not len or len <= 0 then return '' end
  return uid(len - 1) .. charset[math.random(1, #charset)]
end

local uuid =
  coroutine.wrap(function()
    while true do
      local _uuid =  uid(8) ..
              '-' .. uid(4) ..
              '-' .. uid(4) ..
              '-' .. uid(4) ..
              '-' .. uid(12)
      coroutine.yield({
        label = _uuid,
        insertText = _uuid,
      })
    end
  end)

function source.new()
    return setmetatable({}, { __index = source })
end

function source:is_available()
  return true
end

function source:get_keyword_pattern()
  return [[\k\+]]
end

function source:complete(_, callback)
  local items = {}
  for _ = 1, 5 do
    table.insert(items, uuid())
  end
  callback({
    items = items
  })
end

return source

