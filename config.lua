local addon, ns = ...
local cfg = CreateFrame("Frame")

cfg.statusbar_texture =      [[Interface\AddOns\r_UF\p\Armory]]
cfg.backdrop_texture = 	     [[Interface\AddOns\r_UF\p\Armory]]
cfg.backdrop_edge_texture =  [[Interface\AddOns\r_UF\p\Armory]]
cfg.font = "FONTS\\FRIZQT__.ttf"

cfg.player_loc = { x = -240, y = -240 }
cfg.target_loc = { x =  240, y = -240 }
cfg.tot_loc    = { x =    0, y = -240 }

ns.cfg = cfg