--- Component

---@class Component
---@return Component
local Component = {}
Component.__index = Component

--- Creates a new Component.
---@param populate function @A function that populates the Bag with values
---@return Component
function Component.new(populate)
   local component = setmetatable({
      __populate = populate,

      __isComponent = true,
   }, Component)

   component.__mt = {__index = component}

   return component
end

--- Creates and initializes a new Bag.
---@param ... any @The values passed to the populate function
---@return table @A new initialized Bag
function Component:__initialize(...)
   if self.__populate then
      local bag = setmetatable({}, self.__mt)
      self.__populate(bag, ...)

      return bag
   end

   return true
end

return setmetatable(Component, {
   __call = function(_, ...) return Component.new(...) end,
})
