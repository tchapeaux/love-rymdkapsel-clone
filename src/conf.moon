love.conf = (t) ->
    t.title = "kärlekkapsel"        -- The title of the window the game is in (string)
    t.icon = "res/logo/blanklogo.png" -- Filepath to an image to use as the window's icon (string)
    t.author = "Altom"        -- The author of the game (string)
    t.identity = "karlekkapsel"            -- The name of the save directory (string)
    t.version = "11.2"         -- The LÖVE version this game was made for (string)
    t.console = true           -- Attach a console (boolean, Windows only)
    t.release = false           -- Enable release mode (boolean)
    t.window.width = 800        -- The window width (number)
    t.window.height = 600       -- The window height (number)
    t.modules.joystick = false   -- Enable the joystick module (boolean)
    t.modules.physics = false    -- Enable the physics module (boolean)
