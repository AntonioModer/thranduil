local Button = {}
Button.__index = Button

function Button.new(ui, x, y, w, h, settings)
    local self = {}

    self.ui = ui
    self.id = self.ui.addToElementsList(self)
    self.type = 'Button'

    self.ix, self.iy = x, y
    self.x, self.y = x, y
    self.w, self.h = w, h
    local settings = settings or {}
    for k, v in pairs(settings) do self[k] = v end

    self.input = self.ui.Input()
    self.input:bind('return', 'key-enter')
    self.input:bind('mouse1', 'left-click')

    self.hot = false
    self.selected = false
    self.down = false
    self.pressed = false
    self.released = false
    self.enter = false
    self.exit = false
    self.selected_enter = false
    self.selected_exit = false

    self.pressing = false
    self.previous_hot = false
    self.previous_selected = false
    self.previous_pressed = false
    self.previous_released = false

    -- Initialize extensions
    for _, extension in ipairs(self.extensions or {}) do
        if extension.new then extension.new(self) end
    end

    return setmetatable(self, Button)
end

function Button:update(dt, parent)
    local x, y = love.mouse.getPosition()
    if parent then 
        if parent.type == 'Frame' and self.annotation == "Frame's close button" then
            self.ix = parent.w - parent.close_margin - parent.close_button_width
            self.iy = parent.close_margin
        end
        self.x, self.y = parent.x + self.ix, parent.y + self.iy 
    end

    -- Check for hot
    if x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h then
        self.hot = true
    else self.hot = false end

    -- Check for enter 
    if self.hot and not self.previous_hot then
        self.enter = true
    else self.enter = false end

    -- Check for exit
    if not self.hot and self.previous_hot then
        self.exit = true
    else self.exit = false end

    -- Check for selected_enter
    if self.selected and not self.previous_selected then
        self.selected_enter = true
    else self.selected_enter = false end

    -- Check for selected_exit
    if not self.selected and self.previous_selected then
        self.selected_exit = true
    else self.selected_exit = false end

    -- Check for pressed/released/down on mouse hover
    if self.hot and self.input:pressed('left-click') then
        self.pressed = true
        self.pressing = true
    end
    if self.pressing and self.input:down('left-click') then
        self.down = true
    end
    if self.pressing and self.input:released('left-click') then
        self.released = true
        self.pressing = false
        self.down = false
    end

    -- Check for pressed/released/down on key press
    if self.selected and self.input:pressed('key-enter') then
        self.pressed = true
        self.pressing = true
    end
    if self.pressing and self.input:down('key-enter') then
        self.down = true
    end
    if self.pressing and self.input:released('key-enter') then
        self.released = true
        self.pressing = false
        self.down = false
    end

    -- Update extensions
    for _, extension in ipairs(self.extensions or {}) do
        if extension.update then extension.update(self, dt, parent) end
    end

    if self.pressed and self.previous_pressed then self.pressed = false end
    if self.released and self.previous_released then self.released = false end

    -- Set previous frame state
    self.previous_hot = self.hot
    self.previous_pressed = self.pressed
    self.previous_released = self.released
    self.previous_selected = self.selected

    self.input:update(dt)
end

function Button:draw()
    -- Draw extensions
    for _, extension in ipairs(self.extensions or {}) do
        if extension.draw then extension.draw(self) end
    end
end

function Button:bind(key, action)
    self.input:bind(key, action)
end

function Button:destroy()
    self.ui.removeFromElementsList(self.id)
end

function Button:press()
    self.pressed = true
    self.released = true
end

return setmetatable({new = new}, {__call = function(_, ...) return Button.new(...) end})
