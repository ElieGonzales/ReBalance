SMODS.Atlas {
	key = "Rebatlas_Jokers",
	path = "rebatlas_jokers.png",
	px = 71,
	py = 95
}

--Asspoo
SMODS.Joker {
    key = "asspoo",
    blueprint_compat = true,
    in_pool = function ()
        return false
    end,
        
    rarity = 1,
    atlas = "Rebatlas_Jokers",
    pos = {x= 0, y=0},
    config = { extra = {chips = -100} },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
    
}

--Table Turner
SMODS.Joker {
    --id
    key = "tableturner",

    --settings and sprite
    rarity = 2,
    cost = 5,
    atlas = "Rebatlas_Jokers",
    pos = {x= 1, y=0},

    --numbers
    config = { extra = {x_chips = 3, x_mult = 3}},

    --sending numbers to description + info bubbbles (none in this case)
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_chips, card.ability.extra.x_mult } }
    end,


    --always negative edition
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition({negative = true}, true)
    end,

    add_to_deck = function(self, card, from_debuff)
        card:set_edition({negative = true}, true)
    end,

    --card logic
    calculate = function(self, card, context)
        if context.final_scoring_step then
            local xchips = 1
            local xmult = 1
            if hand_chips < 0 then
                xchips = -card.ability.extra.x_chips
            end
            if mult < 0 then
                xmult = -card.ability.extra.x_mult
            end
            return {
                xchips = xchips,
                xmult = xmult
            }
        end
    end
}

--Nubby
SMODS.Joker {
    key = "nubby",
    rarity = 4,
    atlas = "Rebatlas_Jokers",
    pos = {x= 2, y=0},
    soul_atlas = "Rebatlas_Jokers",
    soul_pos = {x=3, y=0},
    config = { extra = {cards = 5, tally = 5} },
    cost = 20,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards, card.ability.extra.tally, colours = {HEX("878ce8")} } }
    end,

    load = function(self, card)
        if G.GAME.blind.in_blind or G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            G.GAME.nubby_active = true
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.GAME.blind.in_blind or G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            G.GAME.nubby_active = true
        end
    end,
    
    calculate = function(self, card, context)

        if context.starting_shop or context.setting_blind then --tally resets when starting shop or starting blind
            G.GAME.nubby_tally = card.ability.extra.cards
        end

        if context.setting_blind or (context.open_booster and context.booster.draw_hand == true) then --activates when starting blind or opening booster
            G.GAME.nubby_active = true
            return {
                message = "Active!",
                backdrop_colour = G.C.ATTENTION,
            }
        end


        if context.end_of_round or context.ending_booster then --deactivates when leaving blind or booster
            G.GAME.nubby_active = false
        end
    end,

    update = function(self, card, dt)
        card.ability.extra.tally = G.GAME.nubby_tally
    end
}

--Op joker wtv
SMODS.Joker {
    key = "opjoker",
    bluepint_compat = true,
    rarity = 3,
    atlas = "Rebatlas_Jokers",
    pos = {x=0, y=1},
    config = {extra = {eemult = 5}},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.eemult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                eemult = card.ability.extra.eemult
            }
        end
    end
}

--Snake
SMODS.Joker {
    key = "snake",
    rarity = 3,
    atlas = "Rebatlas_Jokers",
    pos = {x=4, y=1},

    config = {extra = {selection_bonus = 0, change = 1, type = 'Straight'}},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.selection_bonus, card.ability.extra.change, localize(card.ability.extra.type, 'poker_hands') } }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) and #context.scoring_hand == 5+card.ability.extra.selection_bonus then
            local cards = {}
            for _, c in ipairs(context.scoring_hand) do
                cards[#cards + 1] = c:get_id()
            end
            table.sort(cards)
            local lastcard = 0
            for _, c in ipairs(cards) do
                if lastcard ~= 0 and c ~= lastcard + 1 then
                    return {}
                end
                lastcard = c
            end
            SMODS.scale_card(card, {
                ref_table = card.ability.extra, -- the table that has the value you are changing in
                ref_value = "selection_bonus", -- the key to the value in the ref_table
                scalar_value = "change", -- the key to the value to scale by, in the ref_table by default
            })
            SMODS.change_play_limit(card.ability.extra.change)
            SMODS.change_discard_limit(card.ability.extra.change)
            G.hand:change_size(card.ability.extra.change)
            
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_play_limit(-card.ability.extra.selection_bonus)
        SMODS.change_discard_limit(-card.ability.extra.selection_bonus)
        G.hand:change_size(-card.ability.extra.selection_bonus)
    end
}

--Reverse Canio
SMODS.Joker {
    key = "revcaino", --[sic]
    rarity = "rebal_reverse",
    atlas = "Rebatlas_Jokers",
    pos = {x=1, y=1},
    soul_atlas = "Rebatlas_Jokers",
    soul_pos = {x=2, y=1},

    loc_vars = function(self, info_queue, card) return { vars = {colours = {G.C.REVERSE_TAROT}} } end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            SMODS.destroy_cards(context.other_card)
        end
    end
}

--Reverse Perkeo
SMODS.Joker {
    key = "revperkeo",
    rarity = "rebal_reverse",
    atlas = "Rebatlas_Jokers",
    pos = {x=3, y=1},
    soul_atlas = "Rebatlas_Jokers",
    soul_pos = {x=0, y=2},

    loc_vars = function(self, info_queue, card) return { vars = {colours = {G.C.REVERSE_TAROT}} } end,

    calculate = function(self, card, context)
        if context.ending_shop then
            SMODS.destroy_cards(G.consumeables.cards)
        end
    end
}

--Reverse Yorick
SMODS.Joker {
    key = "revyorick",
    rarity = "rebal_reverse",
    atlas = "Rebatlas_Jokers",
    pos = {x=1, y=2},
    soul_atlas = "Rebatlas_Jokers",
    soul_pos = {x=2, y=2},
    config = {extra = {xmult = 1, xmult_loss = 0.01}},

    loc_vars = function(self, info_queue, card) return { vars = {card.ability.extra.xmult, card.ability.extra.xmult_loss, colours = {G.C.REVERSE_TAROT}} } end,

    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
             card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_loss
              return {
                    message = localize { type = 'variable', key = 'a_xmult_minus', vars = { card.ability.extra.xmult_loss } },
                    colour = G.C.RED,
                    delay = 0.2
                }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
        if context.after then
            card.ability.extra.xmult = 1
            return {
                message = "Reset!",
                colour = G.C.GREEN,
                delay = 0.2 
            }
        end
    end
}

--Reverse Chicot
SMODS.Joker {
    key = "revchicot",
    rarity = "rebal_reverse",
    atlas = "Rebatlas_Jokers",
    pos = {x=3, y=2},
    soul_atlas = "Rebatlas_Jokers",
    soul_pos = {x=0, y=3},

    loc_vars = function(self, info_queue, card) return { vars = {colours = {G.C.REVERSE_TAROT}} } end,

    add_to_deck = function(self, card, from_debuff)
            G.GAME.revchicot_active = true
    end,

    remove_from_deck = function(self, card, from_debuff)
            G.GAME.revchicot_active = false
    end,
}

--Reverse Triboulet
SMODS.Joker {
    key = "revtriboulet",
    rarity = "rebal_reverse",
    atlas = "Rebatlas_Jokers",
    pos = {x=1, y=3},
    soul_atlas = "Rebatlas_Jokers",
    soul_pos = {x=2, y=3},

    config = {extra = {stone_chips = -50}},

    loc_vars = function(self, info_queue, card) 
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return { vars = {card.ability.extra.stone_chips, colours = {G.C.REVERSE_TAROT}} } end,

    add_to_deck = function(self, card, from_debuff)
            G.GAME.revtrib_active = true
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local stoned = false
            for _, c in ipairs (context.scoring_hand) do
                if c:get_id() == 13 or c:get_id() == 12 or c.ability.any_rank then
                    c:set_ability("m_stone")
                    stoned = true
                end
            end
            if stoned then
                return {
                    message = 'Stone!',
                    colour = G.C.REVERSE_TAROT,
                    delay = 0.2
                }
            end
            
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
            G.GAME.revtrib_active = false
    end,
}

--Reverse Nubby
SMODS.Joker {
    key = "nubby_reverse",
    rarity = "rebal_reverse",
    atlas = "Rebatlas_Jokers",
    pos = {x=4, y=0},
    soul_atlas = "Rebatlas_Jokers",
    soul_pos = {x=5, y=0},

    config = {extra = {discarded = 5}},

    loc_vars = function(self, info_queue, card) 
        return { vars = {card.ability.extra.discarded, colours = {G.C.REVERSE_TAROT}} }
    end,

    calculate = function(self, card, context)
        -- the hook mechanic
        if context.press_play then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local any_selected = nil
                    local _cards = {}
                    for _, playing_card in ipairs(G.hand.cards) do
                        _cards[#_cards + 1] = playing_card
                    end
                    for i = 1, card.ability.extra.discarded do
                        if G.hand.cards[i] then
                            local selected_card, card_index = pseudorandom_element(_cards, 'rev_nubby')
                            G.hand:add_to_highlighted(selected_card, true)
                            table.remove(_cards, card_index) --works for The Hook *shrug*
                            any_selected = true
                            play_sound('card1', 1)
                        end
                    end
                    if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
                    return true
                end
            }))
        end
    end
}