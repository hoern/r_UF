local addon, ns = ...
local cfg = CreateFrame("Frame")

cfg.statusbar_texture =      [[Interface\AddOns\r_UF\p\Armory]]
cfg.backdrop_texture = 	     [[Interface\AddOns\r_UF\p\Armory]]
cfg.backdrop_edge_texture =  [[Interface\AddOns\r_UF\p\Armory]]
cfg.font = "FONTS\\FRIZQT__.ttf"

cfg.frames_locked = false
cfg.allow_frame_movement = true

cfg.showplayer = true
cfg.showtarget = true
cfg.showtot = true
cfg.showpet = true
cfg.showfocus = true
cfg.showparty = true
cfg.showraid = true
cfg.allow_frame_movement = true
cfg.frames_locked = false

ns.cfg = cfg