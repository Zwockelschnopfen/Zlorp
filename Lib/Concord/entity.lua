--- Entity

local PATH = (...):gsub('%.[^%.]+$', '')

local Type = require(PATH..".type")
local List = require(PATH..".list")

---@class Entity
---@return Entity
local Entity = {}
Entity.__index = Entity

---@ Creates and initializes a new Entity.
---@return Entity @A new Entity
function Entity.new()
   local e = setmetatable({
      components = {},
      removed    = {},
      instances  = List(),

      __isEntity = true,
   }, Entity)

   return e
end

--- Gives an Entity a component with values.
---@param component Component @The Component to add
---@param ... any @The values passed to the Component
---@return Entity
function Entity:give(component, ...)
   if not Type.isComponent(component) then
      error("bad argument #1 to 'Entity:give' (Component expected, got "..type(component)..")", 2)
   end

   local comp = component:__initialize(...)
   self.components[component] = comp
   self[component] = comp

   return self
end

--- Removes a component from an Entity.
---@param component Component @The Component to remove
---@return Entity
function Entity:remove(component)
   if not Type.isComponent(component) then
      error("bad argument #1 to 'Entity:remove' (Component expected, got "..type(component)..")")
   end

   self.removed[component] = true

   return self
end

--- Checks the Entity against the pools again.
---@return Entity
function Entity:apply()
   for i = 1, self.instances.size do
      self.instances:get(i):checkEntity(self)
   end

   for component, _ in pairs(self.removed) do
      self.components[component] = nil
      self[component] = nil
      self.removed[component] = nil
   end

   return self
end

--- Destroys the Entity.
---@return Entity
function Entity:destroy()
   for i = 1, self.instances.size do
      self.instances:get(i):removeEntity(self)
   end

   return self
end

--- Gets a Component from the Entity.
---@param component Component @The Component to get
---@return Component @The Component in question
function Entity:get(component)
   if not Type.isComponent(component) then
      print(component)
      error("bad argument #1 to 'Entity:get' (Component expected, got "..type(component)..")")
   end

   return self.components[component]
end

--- Returns true if the Entity has the Component.
---@param component Component @The Component to check against
---@return boolean @True if the entity has the Bag. False otherwise
function Entity:has(component)
   if not Type.isComponent(component) then
      error("bad argument #1 to 'Entity:has' (Component expected, got "..type(component)..")")
   end

   return self.components[component] ~= nil
end

return setmetatable(Entity, {
   __call = function(_, ...) return Entity.new(...) end,
})
