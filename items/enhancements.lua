SMODS.Atlas {
    key = "Rebatlas_Enhancements",
    path = "rebatlas_enhancements.png",
    px = 71,
    py = 95
}

--Nult Cards
SMODS.Enhancement {
    key = 'nult',
    atlas = 'Rebatlas_Enhancements', 
    pos = { x = 0, y = 1 },    
    config = { mult = 20, x_mult = 0.75 },
    loc_vars = function(self, info, card)
        return { vars = {card.ability.mult, card.ability.x_mult} }
    end
}

--Malus Cards
SMODS.Enhancement {
    key = 'malus',
    atlas = 'Rebatlas_Enhancements', 
    pos = { x = 1, y = 1 },    
    config = { bonus = 100, x_chips = 0.75 },
    loc_vars = function(self, info, card)
        return { vars = {card.ability.bonus, card.ability.x_chips} }
    end
}

--Platinum cards
SMODS.Enhancement {
    key = 'platinum',
    atlas = 'Rebatlas_Enhancements', 
    pos = { x = 0, y = 0 },    
    config = { extra= {h_dollars = -20, xdollar = 1.5 } },
    loc_vars = function(self, info, card)
        return { vars = {card.ability.extra.h_dollars, card.ability.extra.xdollar } }
    end,


    calculate = function(self, card, context)
        local message = nil
        if context.playing_card_end_of_round and context.cardarea == G.hand then
            card_eval_status_text(card, 'dollars', card.ability.extra.h_dollars)
            ease_dollars(card.ability.extra.h_dollars)

            message = "X$"..tostring(card.ability.extra.xdollar)

            --ease_dollars but with X
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
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
        end
    return {
        message = message,
        colour = G.C.MONEY
    }
    end
}

--Locked cards
SMODS.Enhancement {
    key = 'locked',
    atlas = 'Rebatlas_Enhancements', 
    pos = { x = 1, y = 0 },    
    config = { forced_selection = true, x_mult = 2 },

    loc_vars = function(self, info, card)
        return { vars = {card.ability.x_mult} }
    end,

    --selects itself when drawn
    calculate = function(self, card, context)
        --forced_selection goes away after the blind, gotta reapply it if the card is drawn again
        card.ability.forced_selection = true
        if context.drawing_cards then
            card.area:add_to_highlighted(card)
        end
    end
}

--Bricked Cards
SMODS.Enhancement {
    key = 'bricked',
    atlas = 'Rebatlas_Enhancements', 
    pos = { x = 3, y = 0 },    
    config = {indestructible = true, prevent_debuff = true},
    
    --Cannot be debuffed or destroyed (handled in funcs)
    set_ability = function(self, card, context)
       SMODS.debuff_card(card, "prevent_debuff", "Bricked")
    end
}

--Unlucky cards
SMODS.Enhancement {
    key = 'unlucky',
    atlas = 'Rebatlas_Enhancements',
    pos = { x = 2, y = 0 },
    config = { extra = { mult = 20, dollars = 20, mult_odds = 5, dollars_odds = 15 } },
    loc_vars = function(self, info_queue, card)
        local mult_numerator, mult_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.mult_odds,
            'rebal_unlucky_mult')
        local dollars_numerator, dollars_denominator = SMODS.get_probability_vars(card, 1,
            card.ability.extra.dollars_odds, 'rebal_unlucky_money')
        return { vars = { mult_numerator, mult_denominator, card.ability.extra.mult, dollars_numerator, dollars_denominator, card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local ret = {}
            if SMODS.pseudorandom_probability(card, 'rebal_unlucky_mult', 1, card.ability.extra.mult_odds) then
                ret.mult = -card.ability.extra.mult
                ret.dollars = card.ability.extra.dollars
            end
            if SMODS.pseudorandom_probability(card, 'rebal_unlucky_money', 1, card.ability.extra.dollars_odds) then
                ret.dollars = -card.ability.extra.dollars
                ret.mult = card.ability.extra.mult
            end
            return ret
        end
    end,
}

--Worse stone cards
SMODS.Enhancement:take_ownership('stone',
    {
        calculate = function(self, card, context)
            if G.GAME.revtrib_active and card.ability.bonus > 0 then
                card.ability.bonus = card.ability.bonus * -1
            end
        end
    },
true)