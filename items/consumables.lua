SMODS.Atlas {
    key = "Rebatlas_Consumables",
    path = "rebatlas_consumables.png",
    px = 71,
    py = 95
}

--Win Button
SMODS.Consumable {
    key = "winbtn",
    set = "Tarot",

    config = { extra = {} },
    atlas = "Rebatlas_Consumables",
    pos = {x= 0, y=0},

    --deletes the deck
    use = function(self, card, context)

        if pseudorandom('winbtn') < 0.99 then
            --fake winscreen
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                func = (function()
                    play_sound('win')
                    G.SETTINGS.paused = true

                    G.FUNCS.overlay_menu{
                        definition = create_UIBox_win(),
                        config = {no_esc = false}
                    }
                    
                    return true
                end)
            }))
            delay(1)
            --removes ui
            G.FUNCS:exit_overlay_menu()

            Tarot_quip(card, "Fuck you!", {backdrop_colour = G.C.RED})
            SMODS.destroy_cards(G.deck.cards)
            local editions = {}
            for i = 1, G.jokers.config.card_limit do
                if G.jokers.cards[i] then editions[i] = G.jokers.cards[i].edition or nil else editions[i] = nil end
            end
            SMODS.destroy_cards(G.jokers.cards, {bypass_eternal = true})
            G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.4,
                    func = function()
                        local setlimit = G.jokers.config.card_limit
                        for i = 1, setlimit do
                            SMODS.add_card {
                                key = "j_rebal_asspoo",
                                force_stickers = {"eternal"},
                                edition = editions[i]
                            }
                        end
                        return true
                    end
                }))
        else
            win_game()
        end
    end,
    can_use = function(self, card)
        return true
    end
       
}
--Instant Baron Mime
SMODS.Consumable {
    key = "baronmime",
    set = "Tarot",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_baron
        info_queue[#info_queue+1] = G.P_CENTERS.j_mime
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        info_queue[#info_queue+1] = G.P_SEALS.Red
    end,

    config = { extra = {} },
    rarity = 1,
    atlas = "Rebatlas_Consumables",
    pos = {x= 1, y=0},

    use = function(self, card, context)     
        --juices itself up
        G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true
        end
        }))

        --convert deck into steel kings
        for i = #G.deck.cards, 1, -1 do
            local c = G.deck.cards[i]
            local percent = 1.15 - (i - 0.999) / (#G.deck.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.05,
                func = function()
                    if c and not c.ability.destroyed then
                        c:set_ability("m_steel", true)
                        c:set_seal("Red", true)
                        SMODS.change_base(c, nil, "King")
                        play_sound('card1', percent)
                        c:juice_up(0.3, 0.3)
                    end
                    return true
                end
            }))
        end

        --convert hand into steel kings
        Change_cards(G.hand.cards, "King", nil, "m_steel", "Red", nil, true)

        --create the jokers
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local targets = {"j_baron", "j_mime"}
                for _, t in ipairs(targets) do
                    SMODS.add_card({key = t, area = G.jokers})
                end
                return true
            end
        }))
                
    end,

    can_use = function(self, card)
        return true
    end

}

--Reverse Fool
SMODS.Consumable {
    key = "revfool",
    set = "RevTarot",

    config = { extra = {plus_rev_arcana_chance = 0.1, plus_rev_soul_chance = 0.05} },
    rarity = 1,
    atlas = "Rebatlas_Consumables",
    pos = {x= 3, y=0},  
        
    loc_vars = function (self, info_queue, card)
        local revfool_c = G.GAME.last_tarot_planet and G.P_CENTERS[G.GAME.last_tarot_planet] or nil
        local revfool_c_text = revfool_c and localize { type = 'name_text', key = revfool_c.key, set = revfool_c.set } or
            localize('k_none')
        local colour = not revfool_c and G.C.RED or G.C.GREEN

        if revfool_c then
            info_queue[#info_queue+1] = revfool_c
        end
        --ripped from The Fool
        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = ' ' .. revfool_c_text .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
                        }
                    }
                }
            }
        }
        return { vars = { revfool_c_text, colours={G.C.REVERSE_TAROT} }, main_end = main_end }
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                Tarot_quip(card, "Banished!", {backdrop_colour = G.C.REVERSE_TAROT})

                G.GAME.rev_arcana_chance = G.GAME.rev_arcana_chance + card.ability.extra.plus_rev_arcana_chance
                G.GAME.rev_soul_chance = G.GAME.rev_soul_chance + card.ability.extra.plus_rev_soul_chance
                G.GAME.banned_keys[G.GAME.last_tarot_planet] = true
                G.GAME.last_tarot_planet = nil
                card:juice_up(0.3, 0.5)
                
                return true
            end
        }))
        
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.GAME.last_tarot_planet ~= nil
    end,

    can_sell = function(self, card)
        return false
    end
}

--Reverse Magician
SMODS.Consumable {
    key = "revmagician",
    set = "RevTarot",
    atlas = "Rebatlas_Consumables",
    pos = {x= 0, y=1},


    config = { max_highlighted = 2, mod_conv = "m_rebal_unlucky" },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,

    use = function(self, card, area, copier)

        --juice self up
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        --flip selected cards
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)

        --convert selected cards
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability(card.ability.mod_conv)
                    return true
                end
            }))
        end

        --flip back cards
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        --unhighlight cards
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,

    --cannot be less than 2 selected
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted+0.1 and #G.hand.highlighted >= card.ability.max_highlighted-0.1 -- this is for misprint deck...
    end,
    can_sell = function(self, card)
        return false
    end
}

--Reverse High Priestess
SMODS.Consumable {
    key = "revhighpriestess",
    set = "RevTarot",
    config = { extra = { dollars = 12, lvl_downs = 2 } },
    atlas = "Rebatlas_Consumables",
    pos = {x= 1, y=2},

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.lvl_downs } }
    end,

    use = function(self, card, context)
        local max = card.ability.extra.lvl_downs
        local timeout = 100
        while max > 0 and timeout > 0 do
            local randhand = Get_random_hand() --Random poker hand
            if G.GAME.hands[randhand].level > 1 then
                update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3, immediate=true}, {
                    handname = localize(randhand, "poker_hands"),
                    chips = G.GAME.hands[randhand].chips,
                    mult = G.GAME.hands[randhand].mult,
                    level = G.GAME.hands[randhand].level,
                })
                level_up_hand(card, randhand, false, -1)
                update_hand_text(
                { sound = "button", volume = 0.7, pitch = 1.1, delay = 0, immediate=true },
                { mult = 0, chips = 0, handname = "", level = "" }
                )
                max = max - 1
            end
            timeout = timeout - 1
        end

        ease_dollars(card.ability.extra.dollars)
    end,

    can_use = function(self, card)
        return true
    end,
}

--Reverse Hermit
SMODS.Consumable {
    key = "revhermit",
    set = "RevTarot",

    config = { extra = { xdollar = -2, dollarbonus = 1.25 } },
    atlas = "Rebatlas_Consumables",
    pos = {x= 2, y=0},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xdollar, card.ability.extra.dollarbonus, colours={G.C.REVERSE_TAROT} } }
    end,

    use = function(self, card, context)
        --ripped from ease_dollars
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                
            local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI') 
            
            G.GAME.dollars = card.ability.extra.xdollar*G.GAME.dollars
            dollar_UI.config.object:update()
            G.HUD:recalculate()
            
            local color = {}
            if card.ability.extra.xdollar <= 0 then 
                color = G.C.RED
            else
                color = G.C.MONEY
                check_and_set_high_score('most_money', G.GAME.dollars)
                check_for_unlock({type = 'money'})
                inc_career_stat('c_dollars_earned', G.GAME.dollars * (card.ability.extra.xdollar - 1))
            end

            attention_text({
                text = "X$"..tostring(card.ability.extra.xdollar),
                scale = 0.8,
                hold = 0.7,
                cover = dollar_UI.parent,
                cover_colour = color,
                align = 'cm',
            })
            play_sound('coin1')
            return true
            end
        }))
        G.GAME.dollar_bonus = G.GAME.dollar_bonus * card.ability.extra.dollarbonus
    end,
    
    can_use = function(self, card)
        return G.GAME.dollars > 0
    end,

    can_sell = function(self, card)
        return false
    end
}

--Reverse Wheel of Fortune
SMODS.Consumable {
    key = "revwheel",
    set = "RevTarot",

    config = {},
    rarity = 1,
    atlas = "Rebatlas_Consumables",
    pos = {x= 0, y=2},

   

    use = function(self, card, context)
        --juice self up
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))


        --checks jokers first
        for _, c in ipairs(G.jokers.cards) do
            if c.edition then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        c:flip()
                        return true
                    end
                }))
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.4,
                    func = function()
                        Edition_effects(c.edition.key, card, c)
                        c:set_edition(nil)                   
                        return true
                    end 
                }))

                G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    c:flip()
                    return true
                end
            }))

            end
        end


        --same for deck
        for _, c in ipairs(G.deck.cards) do
            if c.edition then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.4,
                    func = function()
                        c:flip()
                        G.deck:remove_card(c)
                        G.play:emplace(c)
                        return true
                    end
                })) 
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        Edition_effects(c.edition.key, card, c)
                        c:set_edition(nil)                   
                        return true
                    end 
                }))

                G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    c:flip()
                    return true
                end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        G.play:remove_card(c)
                        G.deck:emplace(c)
                        return true
                    end
                }))

            end
        end
        
                    
    end,

    can_use = function(self, card)
        return true
    end,

    can_sell = function(self, card)
        return false
    end
}

--Reverse Strength
SMODS.Consumable {
    key = 'revstrength',
    set = 'RevTarot',
    atlas = 'Rebatlas_Consumables',
    pos = { x = 3, y = 2 },
    config = { max_highlighted = 2, lvl_downs = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted, card.ability.lvl_downs } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    assert(SMODS.modify_rank(G.hand.highlighted[i], -card.ability.lvl_downs))
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
    
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted+0.1 and #G.hand.highlighted >= card.ability.max_highlighted-0.1 -- this is for misprint deck...
    end,
    can_sell = function(self, card)
        return false
    end
}

--Reverse Hanged Man
SMODS.Consumable {
    key = "revhangedman",
    set = "RevTarot",
    atlas = "Rebatlas_Consumables",
    pos = {x= 0, y=3},

    config = { extra = {created_cards = 2}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.created_cards } }
    end,

    use = function(self, card, context)
        --Adds to hand if in booster or blind, else add to deck
        local area = G.deck
        if G.GAME.blind.in_blind or G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            area = G.hand
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                for _ = 1, card.ability.extra.created_cards do
                    local _edition = SMODS.poll_edition { key = "rebal_rhme" .. G.GAME.round_resets.ante, mod = 4}
                    local _seal = SMODS.poll_seal({key="rebal_rhms", mod = 10 })
                    SMODS.add_card({set = 'Enhanced', area = area, key_append = "rebal_rhmc".. G.GAME.round_resets.ante, seal = _seal, edition = _edition})
                end
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end,

    can_use = function(self, card)
        return true
    end,

    can_sell = function(self, card)
        return false
    end
}

--Reverse Devil
SMODS.Consumable {
    key = "revdevil",
    set = "RevTarot",
    atlas = "Rebatlas_Consumables",
    pos = {x= 2, y=2},


    config = { max_highlighted = 1, mod_conv = "m_rebal_platinum" },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,

    use = function(self, card, area, copier)

        --juice self up
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        --flip selected cards
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)

        --convert selected cards
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability(card.ability.mod_conv)
                    return true
                end
            }))
        end

        --flip back cards
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        --unhighlight cards
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,

    --cannot be less than 2 selected
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted == card.ability.max_highlighted
    end,
    can_sell = function(self, card)
        return false
    end
}

--Reverse Judgement
SMODS.Consumable {
    key = "revjudgement",
    set='RevTarot',
    atlas = "Rebatlas_Consumables",
    pos = {x=1, y=3},
    config = {extra = {choice = 3}},

    loc_vars = function(self, info_queue, card)
        return {vars={card.ability.extra.choice}}
    end,

    use = function(self, card, area, copier)
        G.GAME.usedjokerref = SMODS.shallow_copy(G.GAME.used_jokers)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                card:juice_up(0.3, 0.5)
                play_sound('tarot1')
                G.GAME.revjudgement_active = true
                local j = G.jokers.highlighted[1]
                local rarity = j.config.center.rarity
                SMODS.destroy_cards(j)
                G.FUNCS.overlay_menu({
                    definition = Create_UIBox_revjudgement(rarity, card.ability.extra.choice),
                    config = {no_esc = true}
                })               
            return true
            end
        }))
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.highlighted == 1 and not SMODS.is_eternal(G.jokers.highlighted[1])
    end,

    can_sell = function(self, card)
        return false
    end
}



--Reverse Soul
SMODS.Consumable {
    key = 'revsoul',
    set = 'RevTarot',
    atlas = 'Rebatlas_Consumables',
    pos = { x = 1, y = 1 },
    soul_atlas = "Rebatlas_Consumables",
    soul_pos = {x=2, y=1},
    hidden = true,
    soul_set = 'RevTarot',
    soul_rate = 0.003,
    loc_vars = function(self, info_queue, card)

        return { vars = { colours={G.C.REVERSE_TAROT} } }
    end,
    use = function(self, card, area, copier)
        G.GAME.rev_soul_chance = 0.003
        G.GAME.rev_arcana_chance = 0.1
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Joker', legendary = true, key_append = "rebal_revsoul", force_stickers = {"eternal"}, edition = "e_negative" })
                    G.GAME.used_revsoul = true
                    check_for_unlock { type = 'spawn_legendary' }
                    card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'ease',
            ease = 'insine',
            ref_table = G,
            ref_value = 'screenshader_fade',
            ease_to = 0,
            delay = 6,
            func = function(t) return t end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end  
}  

--Hollow Soul
SMODS.Consumable {
    key = 'hollowsoul',
    set = 'RevTarot',
    atlas = 'Rebatlas_Consumables',
    hidden = true,
    pos = { x = 3, y = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { colours={G.C.REVERSE_TAROT} } }
    end,

    use = function(self, card, area, copier)
        G.GAME.used_revsoul = false
        for _, c in ipairs(G.jokers.cards) do
            if c.config.center.rarity == 4 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        SMODS.destroy_cards(c, {bypass_eternal = true, immediate = true})
                        local revjokerkey = "j_rebal_rev"..string.sub(c.config.center.key, 3)
                        if revjokerkey and G.P_CENTERS[revjokerkey] then
                            SMODS.add_card({ set = 'Joker', legendary = true, key = revjokerkey, force_stickers = c.ability.eternal and {"eternal"} or nil, edition = c.edition or nil })
                        end

                        --crossmod support
                        local modrevjokerkey = c.config.center.key.."_reverse"
                        if modrevjokerkey and G.P_CENTERS[modrevjokerkey] then
                            SMODS.add_card({ set = 'Joker', legendary = true, key = modrevjokerkey, force_stickers = c.ability.eternal and {"eternal"} or nil, edition = c.edition or nil})
                        end
                        return true
                    end
                }))
            end
        end
        delay(0.6)
    end,

    can_use = function(self, card)
        for _, c in ipairs(G.jokers.cards) do
            if c.config.center.rarity == 4 then
                return true
            end
        end
    end
}


