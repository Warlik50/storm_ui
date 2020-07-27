local panel = require((...):gsub("[^/]+$", "/panel"))

local label = class(panel)

function label:init()
    panel.init(self)

    self:set_hover_enabled(false)
end

function label:post_init()
    panel.post_init(self)

    self:set_draw_background(false)
    self:set_draw_outline(false)

    self.font = self.ui_manager.theme.label.font
    self.text = "label"
    self.text_align = 1
    self.rotation = 0
    self.text_object = love.graphics.newText(self.font, self.text)

    self:set_text_color({unpack(self.ui_manager.theme.label.text_color)})
    self.text_shadow_color = {unpack(self.ui_manager.theme.label.text_shadow_color)}

    self:add_hook("on_validate", function(this)
        this:set_text(this:get_text())
    end)
end

function label:size_to_contents()
    local padding = self:get_dock_padding()
    self.w = self.font:getWidth(self.text) + padding[1] + padding[3]
    self.h = self.font:getHeight() + padding[2] + padding[4]
    self:set_text(self.text)
end

function label:set_width_internal(w)
    local scale_x, scale_y = self:get_text_scale()

    panel.set_width_internal(self, w)
    self.text_object:setf(self.text, w / scale_x, self:need_a_better_name())
end

function label:get_horizontal_align()
    local align = self.text_align

    if align == 1 or align == 4 or align == 7 then
        return "left"
    elseif align == 2 or align == 5 or align == 8 then
        return "center"
    elseif align == 3 or align == 6 or align == 9 then
        return "right"
    end
end

function label:get_align()
    return self.text_align
end

function label:set_align(align)
    self.text_align = align
    self:set_text(self.text)
end

function label:get_text()
    return self.text
end

function label:set_text(text)
    if not text then
        text = ""
    end

    local scale_x, scale_y = self:get_text_scale()
    scale_x = 1

    self.text = tostring(text)
    self.text_object:setf(self.text, self.w / scale_x, self:get_horizontal_align())
end

function label:get_font()
    return self.font
end

function label:set_font(font)
    self.font = font
    self.text_object:setFont(self.font)
end

function label:set_text_color(r, g, b, a)
    assert(r, "No color passed to set_text_color.")
    self.text_color = type(r) == "table" and r or {r, g, b, a}
end

function label:get_text_color()
    return self.text_color
end

function label:get_text_scale()
    local manager = self.ui_manager

    local scale_x = manager.w / manager.theme.window.designed_width
    local scale_y = manager.h / manager.theme.window.designed_height
    
    return scale_x, scale_y
end

function label:set_dropshadow(bool)
    self.should_draw_dropshadow = bool
end

function label:get_dropshadow()
    return self.should_draw_dropshadow
end

function label:draw_text()
    if not self.text then
        return
    end

    local text_width = self.text_object:getWidth()
    local text_height = self.text_object:getHeight()
    local x, y = self:get_screen_pos()

    if self.text_align > 6 then
        y =  y + self.h - text_height
    elseif self.text_align > 3 then
        y = y + self.h / 2 - text_height / 2
    end

    if self.should_draw_dropshadow then
        love.graphics.setColor(self.text_shadow_color)
        love.graphics.draw(self.text_object, x + 2, y + 2)
    end

    love.graphics.setColor(self.text_color)
    love.graphics.draw(self.text_object, x, y)
end

function label:draw()
    panel.draw(self)
    self:draw_text()
end

return label