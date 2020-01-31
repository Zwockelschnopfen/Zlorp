--- Instance

local PATH = (...):gsub('%.[^%.]+$', '')

local Entity = require(PATH..".entity")
local System = require(PATH..".system")
local Type   = require(PATH..".type")
local List   = require(PATH..".list")

---@class Instance
---@return Instance @The new instance.
local Instance = {}
Instance.__index = Instance

--- Creates a new Instance.
---@return Instance @The new instance.
function Instance.new()
   local instance = setmetatable({
      entities = List(),
      systems  = List(),
      events   = {},
      removed  = {},
      toRemove = nil,

      __isInstance = true,
   }, Instance)

   return instance
end

--- Adds an Entity to the Instance.
---@param e Entity @The Entity to add
---@return Instance
function Instance:addEntity(e)
   if not Type.isEntity(e) then
      error("bad argument #1 to 'Instance:addEntity' (Entity expected, got "..type(e)..")", 2)
   end

   self:onEntityAdded(e)

   e.instances:add(self)
   self.entities:add(e)
   self:checkEntity(e)

   return self
end

--- Checks an Entity against all the systems in the Instance.
---@param e Entity @The entity to check.
---@return Instance
function Instance:checkEntity(e)
   if not Type.isEntity(e) then
      error("bad argument #1 to 'Instance:checkEntity' (Entity expected, got "..type(e)..")", 2)
   end

   for i = 1, self.systems.size do
      self.systems:get(i):__check(e)
   end

   return self
end

--- Marks an Entity as removed from the Instance.
---@param e Entity @The Entity to mark
---@return Instance
function Instance:removeEntity(e)
   if not Type.isEntity(e) then
      error("bad argument #1 to 'Instance:removeEntity' (Entity expected, got "..type(e)..")", 2)
   end

   self.removed[#self.removed + 1] = e

   return self
end

--- Completely removes all marked Entities in the Instance.
---@return Instance
function Instance:flush()
   while #self.removed > 0 do
      self.toRemove = self.removed
      self.removed  = {}

      for i = 1, #self.toRemove do
         local e = self.toRemove[i]

         e.instances:remove(self)
         self.entities:remove(e)

         for i = 1, self.systems.size do
            self.systems:get(i):__remove(e)
         end

         self:onEntityRemoved(e)
      end
   end

   return self
end

--- Adds a System to the Instance.
---@param system System @The System to add.
---@param eventName string @The Event to register to.
---@param callback string @The function name to call. Defaults to eventName.
---@param enabled boolean @If the system is enabled. Defaults to true.
---@return Instance
function Instance:addSystem(system, eventName, callback, enabled)
   if not Type.isSystem(system) then
      error("bad argument #1 to 'Instance:addSystem' (System expected, got "..type(system)..")", 2)
   end

   if system.__instance and system.__instance ~= self then
      error("System already in instance '" ..tostring(system.__instance).."'")
   end

   if not self.systems:has(system) then
      self.systems:add(system)
      system.__instance = self

      system:addedTo(self)
   end

   if eventName then
      self.events[eventName] = self.events[eventName] or {}

      local i = #self.events[eventName] + 1
      self.events[eventName][i] = {
         system   = system,
         callback = callback or eventName,
         enabled  = enabled == nil or enabled,
      }

      if enabled == nil or enabled then
         system:enabledCallback(callback or eventName)
      end
   end

   local e
   for i = 1, self.entities.size do
      e = self.entities:get(i)

      self:checkEntity(e)
   end

   return self
end

--- Enables a System in the Instance.
---@param system System @The system to enable.
---@param eventName string @The Event it was registered to.
---@param callback string @The callback it was registered with. Defaults to eventName.
---@return Instance
function Instance:enableSystem(system, eventName, callback)
   if not Type.isSystem(system) then
      error("bad argument #1 to 'Instance:enableSystem' (System expected, got "..type(system)..")", 2)
   end

   return self:setSystem(system, eventName, callback, true)
end

--- Disables a System in the Instance.
---@param system System @The System to disable
---@param eventName string @The Event it was registered to.
---@param callback string @The callback it was registered with. Defaults to eventName.
---@return Instance
function Instance:disableSystem(system, eventName, callback)
   if not Type.isSystem(system) then
      error("bad argument #1 to 'Instance:disableSystem' (System expected, got "..type(system)..")", 2)
   end

   return self:setSystem(system, eventName, callback, false)
end

--- Sets a System 'enable' in the Instance.
---@param system System @The System to set.
---@param eventName string @The Event it was registered to.
---@param callback string @The callback it was registered with. Defaults to eventName.
---@return Instance
function Instance:setSystem(system, eventName, callback, enable)
   if not Type.isSystem(system) then
      error("bad argument #1 to 'Instance:setSystem' (System expected, got "..type(system)..")", 2)
   end

   callback = callback or eventName

   if callback then
      local listeners = self.events[eventName]

      if listeners then
         for i = 1, #listeners do
            local listener = listeners[i]

            if listener.system == system and listener.callback == callback then
               if enable and not listener.enabled then
                  system:enabledCallback(callback)
               elseif not enable and listener.enabled then
                  system:disabledCallback(callback)
               end

               listener.enabled = enable

               break
            end
         end
      end
   end

   return self
end

--- Emits an Event in the Instance.
---@param eventName string @The Event that should be emitted.
---@param ... any @Parameters passed to listeners.
---@return Instance
function Instance:emit(eventName, ...)
   if not eventName or type(eventName) ~= "string" then
      error("bad argument #1 to 'Instance:emit' (String expected, got "..type(eventName)..")")
   end

   self:flush()

   local listeners = self.events[eventName]

   if listeners then
      for i = 1, #listeners do
         local listener = listeners[i]

         if listener.enabled then
            listener.system[listener.callback](listener.system, ...)
         end
      end
   end

   return self
end

--- Removes all entities from the Instance
---@return Instance
function Instance:clear()
   for i = 1, self.entities.size do
      self.entities:get(i):destroy()
   end

   self:flush()

   return self
end

--- Default callback for adding an Entity.
---@param e Entity @The Entity that was added.
function Instance:onEntityAdded(e)
end

--- Default callback for removing an Entity.
---@param e Entity @The Entity that was removed.
function Instance:onEntityRemoved(e)
end

return setmetatable(Instance, {
   __call = function(_, ...) return Instance.new(...) end,
})
