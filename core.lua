--keeps track of game-specific shit
G.screenshader_fade = 1
SMODS.current_mod.reset_game_globals = function(run_start)
    if run_start then
        G.GAME.usedjokerref = {}
        G.GAME.rev_arcana_chance = 0.2
        G.GAME.rev_arcana_cumul_chance = 0
        G.GAME.rev_soul_chance = 0.003
        G.GAME.dollar_bonus = 1
        G.GAME.in_reverse_arcana_pack = false
        G.GAME.nubby_active = false
        G.GAME.nubby_tally = 5
        G.GAME.used_revsoul = false
        G.GAME.revchicot_active = false
        G.GAME.revtrib_active = false
        G.GAME.revjudgement_active = false
        G.GAME.revemperor_cancels = 0
    end
end

G.C.REVERSE_TAROT = HEX("C62828")

SMODS.load_file("items/funcs.lua")()
SMODS.load_file("items/consumables.lua")()
SMODS.load_file("items/jokers.lua")()
SMODS.load_file("items/enhancements.lua")()
SMODS.load_file("items/editions.lua")()
SMODS.load_file("items/other.lua")()
