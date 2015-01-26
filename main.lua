UI = require 'ui/UI'

function love.load()
    love.window.setMode(800, 600, {display = 1})
    love.graphics.setBackgroundColor(255, 255, 255)

    button = UI.Button(50, 50, 100, 50)
    button.draw = function(self)
        love.graphics.setColor(64, 64, 64)
        if self.hot then love.graphics.setColor(96, 96, 96) end
        if self.down then love.graphics.setColor(32, 32, 32) end
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    end

    frame = UI.Frame(150, 150, 200, 200, {draggable = true, resizable = true, closeable = true})
    frame.draw = function(self)
        if self.closed then return end

        -- Draw frame
        love.graphics.setColor(64, 64, 64)
        if self.hot then love.graphics.setColor(96, 96, 96) end
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

        -- Draw resize border
        if self.resizable then
            love.graphics.setColor(32, 32, 32)
            if self.resize_hot then love.graphics.setColor(64, 64, 64) end
            if self.resizing then love.graphics.setColor(48, 48, 48) end
            love.graphics.rectangle('fill', self.x, self.y, self.w, self.resize_margin)
            love.graphics.rectangle('fill', self.x, self.y + self.h - self.resize_margin, self.w, self.resize_margin)
            love.graphics.rectangle('fill', self.x, self.y, self.resize_margin, self.h)
            love.graphics.rectangle('fill', self.x + self.w - self.resize_margin, self.y, self.resize_margin, self.h)
        end

        -- Draw drag bar
        if self.draggable then
            love.graphics.setColor(32, 32, 32)
            if self.drag_hot then love.graphics.setColor(64, 64, 64) end
            if self.dragging then love.graphics.setColor(48, 48, 48) end
            love.graphics.rectangle('fill', self.x, self.y, self.w, self.drag_margin)
        end

        -- Draw close button
        if self.closeable then
            local cb = self.close_button
            love.graphics.setColor(64, 64, 64)
            if cb.hot then love.graphics.setColor(96, 96, 96) end
            if cb.down then love.graphics.setColor(32, 32, 32) end
            love.graphics.rectangle('fill', cb.x, cb.y, cb.w, cb.h)
        end

        -- Draw elements in the frame
        for _, element in ipairs(self.elements) do element:draw() end
    end
end

function love.update(dt)
    button:update(dt)
    frame:update(dt)
end

function love.draw()
    button:draw()
    frame:draw()
end

function love.keypressed(key)
    UI.keypressed(key)
end

function love.keyreleased(key)
    UI.keyreleased(key)
end

function love.mousepressed(x, y, button)
    UI.mousepressed(button)
end

function love.mousereleased(x, y, button)
    UI.mousereleased(button)
end

function love.gamepadpressed(joystick, button)
    UI.gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
    UI.gamepadreleased(joystick, button)
end

function love.gamepadaxis(joystick, axis, value)
    UI.gamepadaxis(joystick, axis, value)
end

function love.textinput(text)
    UI.textinput(text)
end
