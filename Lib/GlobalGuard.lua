local GlobalGuard = {
  enabled = false
}

local globals = { }
local mt = { }

function mt.__index(table, name)
  assert(table == _G)
  if globals[name] then
    return nil
  else
    error("access to undeclared global '" .. tostring(name) .. "'", 2)
  end
end

function mt.__newindex(table, name, value)
  assert(table == _G)
  if not globals[name] then
    error("write to undeclared global '" .. tostring(name) .. "' = " .. tostring(value), 2)
  end
end

function GlobalGuard.enableGuard()
  GlobalGuard.enabled = true
  setmetatable(_G, mt)
end

function GlobalGuard.disableGuard()
  GlobalGuard.enabled = false
end

function GlobalGuard.declare(name, value)
  globals[name] = true
  _G[name] = value
end

return GlobalGuard