-- File    : 30log-example.lua
-- Purpose : Brief demonstration of 30log on Luerl.
-- See     : ./class.erl


local class = require('30log')

-- Creating a class
local Window = class("Window")

print(Window.name)

-- Giving a class a name is optional though.
local unnamedWindow = class()
print(unnamedWindow.name) -- outputs nil

-- We can define attributes for any class.

Window.width = 150
Window.height = 100

print(Window.width)
print(Window.height)

-- 30log provides a shortcut, for convinience: passing an optional `params` table 
-- (with named keys) as a second argument to class().

local Window = class("Window", {width=150, height=150})

print(Window.width)
print(Window.height)

print(Window)

local Window = class(nil, {width = 150, height = 100})

print(Window)

--local Window = class('Window')
--getmetatable(Window).__tostring = function(t)
--  return "I am class "..(t.name)
--end
--print(Window) -- outputs "I am class Window"


local appWindow = Window()
print(appWindow.width, appWindow.height) -- outputs 150, 100

appWindow.width, appWindow.height = 720, 480
print(appWindow.width, appWindow.height) -- outputs 720, 480
print(Window.width, Window.height) -- outputs 150, 100, hence class attributes are left

local Window = class("Window")
function Window:init(width, height)
  self.width, self.height = width, height
end

local appWindow = Window(800,600)
print(appWindow.width, appWindow.height) -- output 800, 600

--local Window = class("Window")
--Window.init = {width = 500, height = 500}

--appWindow = Window()
--print(appFrame.width, appFrame.height) -- outputs 500, 500

local appWindow = Window:create()
print(appWindow:instanceOf(Window)) -- outputs "true"
print(appWindow.width, appWindow.height) -- outputs nil, nil

Window.width = 250 -- Sets a default width for the class
print(appWindow.width) -- outputs 250

print(appWindow:instanceOf(Window)) -- outputs true

local GraphicalObject = class('GraphicalObject')
local Rect = GraphicalObject:extend('Rect')
local Window = Rect:extend('Window')
local appWindow = Window()

print(appWindow:instanceOf(Window)) -- outputs true
print(appWindow:instanceOf(Rect)) -- outputs true
print(appWindow:instanceOf(GraphicalObject)) -- outputs true

local Rect = class('Rect')
local Window = class('Window')
local w = Rect()
print(w:instanceOf(Rect)) -- outputs true

w:cast(Window) -- Sets class 'Window' to be the class of instance 'w'
print(w:instanceOf(Rect)) -- outputs false
print(w:instanceOf(Window)) -- outputs true
print(w.class) -- outputs class 'Window'

local Rect = class('Rect')
function Rect:init(width, height)
  self.width, self.height = width, height
end

function Rect:area()
  return self.width * self.height
end

local Window = class('Window')
function Window:init(width, height)
  self.width, self.height = width, height
end

function Window:halve()
  self.width, self.height = self.width / 2, self.height / 2
end

local w = Rect(10, 5)
print(w:area()) -- outputs 50

w:cast(Window)
--w:area() -- raises an error
w:halve()
print(w.width, w.height) -- outputs 5, 2.5

local Window = class("Window")
local appWindow = Window()
print(appWindow)

local Window = class()
local appWindow = Window()
print(appWindow)

print(appWindow.class)

local aClass = class()
local someInstance = aClass()
print(getmetatable(someInstance) == aClass) -- true


-- Methods
-- Instances and their class methods.

local maxWidth = 150 -- a maximum width
local maxHeight = 100 -- a maximum height
local Window = class("Window", {width = maxWidth, height = maxHeight})

function Window:init(width,height)
  self.width,self.height = width,height
end

-- A method to cap the Window dimensions to maximum values
function Window:cap()
  self.width = math.min(self.width, Window.width)
  self.height = math.min(self.height, Window.height)
end

local appWindow = Window(200, 200)
appWindow:cap()
print(appWindow.width,appWindow.height) -- outputs 150,100

-- The new class constructor
function Window:init(width,height)
  self.width,self.height = width,height
  self:cap()
end

local appWindow = Window(200, 200)
print(appWindow.width,appWindow.height) -- outputs 150,100

appWindow = Window()
appWindow = Window:new()
--aWindow = appWindow:new() -- Creates an error
--aWindow = appWindow()     -- Also creates an error


-- Methamethods ?
-- Methamethods ?
-- Methamethods ?


-- Subclasses
-- Subclasses
-- Subclasses
local Window = class ("Window", { width = 150, height = 100})
local Frame = Window:extend("Frame", { color = "black" })

local appFrame = Frame()
print(appFrame.width, appFrame.height, appFrame.color)


print(Frame.super)

-- A base class "Window"
local Window = class ("Window", {x = 10, y = 10, width = 150, height = 100})

function Window:init(x, y, width, height)
  Window.set(self, x, y, width, height)
end

function Window:set(x, y, w, h)
  self.x, self.y, self.width, self.height = x, y, w, h
end

-- a "Frame" subclass
local Frame = Window:extend({color = 'black'})
function Frame:init(x, y, width, height, color)
  -- Calling the superclass constructor
  Frame.super.init(self, x, y, width, height)
  -- Setting the extra class member
  self.color = color
end

-- Redefining the set() method
function Frame:set(x,y)
  self.x = x - self.width/2
  self.y = y - self.height/2
end

-- An appFrame from "Frame" class
local appFrame = Frame(100,100,800,600,'red')
print(appFrame.x, appFrame.y) -- outputs 100, 100

-- Calls the new set() method
appFrame:set(400,400)
print(appFrame.x, appFrame.y) -- outputs 0, 100

-- Calls the old set() method in the superclass "Window"
appFrame.super.set(appFrame,400,300)
print(appFrame.x, appFrame.y) -- outputs 400, 300

local aClass = class("aClass")
local aSubClass= aClass:extend()
print(getmetatable(aSubClass)) -- outputs "class 'aClass' (table: 0x0002cee8)"

local aClass = class("aClass")
local aSubClass= aClass:extend()
print(aClass:classOf(aSubClass)) -- outputs true

local classLevelOne = class("classLevelOne")
local classLevelTwo = classLevelOne:extend("classLevelTwo")
local classLevelThree = classLevelTwo:extend("classLevelThree")

print(classLevelOne:classOf(classLevelTwo)) -- outputs true
print(classLevelOne:classOf(classLevelThree)) -- also outputs true

local aClass = class("aClass")
local aSubClass= aClass:extend()
print(aSubClass:subclassOf(aClass)) -- outputs true

local classLevelOne = class("classLevelOne")
local classLevelTwo = classLevelOne:extend("classLevelTwo")
local classLevelThree = classLevelTwo:extend("classLevelThree")

print(classLevelThree:subclassOf(classLevelTwo)) -- outputs true
print(classLevelThree:subclassOf(classLevelOne)) -- also outputs true

local GraphicalObject = class('GraphicalObject')
local Rect = GraphicalObject:extend('Rect')
local Window = Rect:extend('Window')
local Button = Rect:extend('Button')

local subclasses = GraphicalObject:subclasses()
for _, subclass in ipairs(subclasses) do print(subclass) end -- outputs 'Rect', 'Window' and 'Button'.

local subclasses = Rect:subclasses()
for _, subclass in ipairs(subclasses) do print(subclass) end -- outputs 'Window' and 'Button'.

local direct_subclasses = GraphicalObject:subclasses(function(s)
  return s.super == GraphicalObject
end)
for _, subclass in ipairs(direct_subclasses) do print(subclass) end -- outputs 'Rect'

local GraphicalObject = class('GraphicalObject')
local Rect = GraphicalObject:extend('Rect')
local Window = Rect:extend('Window')
local Button = Rect:extend('Button')

local aRect = Rect()
local aWindow = Window()
local aButton = Button()

local instances = Rect:instances()
for _, instance in ipairs(instances) do print(instance) end -- outputs `aRect `, `aWindow` and `aButton`.

local instances = Window:instances()
for _, instance in ipairs(instances) do print(instance) end -- outputs `aWindow`.

local instances = Button:instances()
for _, instance in ipairs(instances) do print(instance) end -- outputs `aButton`.

local direct_instances = Rect:instances(function(s)
  return s.class == Rect
end)
for _, instance in ipairs(direct_instances) do print(instance) end


-- Mixins
-- Mixins
-- Mixins
-- Mixins
-- Mixins
-- Mixins

-- A simple Geometry mixin
local Geometry = {
  getArea = function(self) return self.width * self.height end
}

-- Let us define two unrelated classes
local Window = class ("Window", {width = 480, height = 250})
local Button = class ("Button", {width = 100, height = 50, onClick = false})

-- Include the "Geometry" mixin in Window and Button classes
Window:with(Geometry)
Button:with(Geometry)

-- Let us define instances from those classes
local aWindow = Window()
local aButton = Button()

-- Instances can use functionalities brought by Geometry mixin.
print(aWindow:getArea()) -- outputs 120000
print(aButton:getArea()) -- outputs 5000


print(Window:includes(Geometry)) -- outputs true
print(Button:includes(Geometry)) -- outputs true

-- Let us create a subclass from Window class
local subWindow = Window:extend()
print(subWindow:includes(Geometry)) -- still outputs true

Window:without(Geometry)
print(Window:includes(Geometry)) -- outputs false
print(Window.getArea) -- outputs nil
