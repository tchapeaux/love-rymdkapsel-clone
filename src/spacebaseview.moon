export ^

require "star"
gamera = require "lib/gamera/gamera"

export cos, sin = math.cos, math.sin

class SpacebaseView
    new: (@spacebase) =>
        @size = @spacebase.totalSize()
        @canvas = love.graphics.newCanvas(@size, @size)
        @cam = gamera.new(-@size/3, -@size/3, 5/3 * @size, 5/3 * @size)
        @cam\setPosition(@size/2, @size/2)
        @cam\setAngle(math.pi/4)

        @offset_speed = 500  -- px/s
        @zoom_rate = 0.7
        @rotationspeed = 1

        @starField = {}
        number_of_stars = 200
        for i=1,number_of_stars
            table.insert(@starField, Star())

    update: (dt) =>
        cam_x, cam_y = @cam\getPosition()
        cam_zoom = @cam\getScale()
        cam_angle = @cam\getAngle()
        if love.keyboard.isDown("down")
            cam_x -= @offset_speed * dt * sin(cam_angle)
            cam_y += @offset_speed * dt * cos(cam_angle)
        if love.keyboard.isDown("up")
            cam_x += @offset_speed * dt * sin(cam_angle)
            cam_y -= @offset_speed * dt * cos(cam_angle)
        if love.keyboard.isDown("right")
            cam_x += @offset_speed * dt * cos(cam_angle)
            cam_y += @offset_speed * dt * sin(cam_angle)
        if love.keyboard.isDown("left")
            cam_x -= @offset_speed * dt * cos(cam_angle)
            cam_y -= @offset_speed * dt * sin(cam_angle)
        @cam\setPosition(cam_x, cam_y)
        if love.keyboard.isDown("i")
            @cam\setScale(cam_zoom + cam_zoom * @zoom_rate * dt)
        if love.keyboard.isDown("o")
            @cam\setScale(cam_zoom - cam_zoom * @zoom_rate * dt)
        if love.keyboard.isDown("r")
            @cam\setAngle(cam_angle + @rotationspeed * dt)

    draw: =>
        @draw_starfield()
        love.graphics.scale(1, 0.5)
        @cam\draw(@spacebase\draw)

    draw_starfield: =>
        spaceColor = {14, 17, 23}
        cam_x, cam_y = @cam\getPosition()
        love.graphics.setColor(spaceColor)
        love.graphics.rectangle("fill", 0, 0, wScr(), hScr())
        for star in *@starField
            star\draw(cam_x, cam_y)

    -- draw_spacebase: =>
    --     w, h = wScr(), hScr()
    --     @canvas\clear(0, 0, 0, 0) -- clear to transparent
    --     love.graphics.setCanvas(@canvas)
    --     @spacebase\draw()
    --     love.graphics.setCanvas()
    --     love.graphics.scale(@zoom, @zoom)
    --     translate_x = @offset_center_x + w / (2 * @zoom)
    --     translate_y = @offset_center_y + h / (2 * @zoom)
    --     love.graphics.translate(translate_x, translate_y)
    --     -- love.graphics.scale(1, 0.5)
    --     -- love.graphics.rotate(math.pi/4 + @rotation)
    --     -- love.graphics.circle("fill", 0, 0, 10)
    --     love.graphics.setColor(255, 255, 255)
    --     love.graphics.draw(@canvas, -@size / (2 * @zoom), -@size / (2 * @zoom))


    keyreleased: (key) =>

    coordinatesInWorld: (x, y) =>
        world_x, world_y = @cam\toWorld(x, 2 * y)
        return {world_x, world_y}
