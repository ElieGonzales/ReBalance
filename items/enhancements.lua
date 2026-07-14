SMODS.Atlas {
    key = "Rebatlas_Enhancements",
    path = "rebatlas_enhancements.png",
    px = 71,
    py = 95
}

--Nult cards
SMODS.Enhancement {
    key = 'nult',
    atlas = 'Rebatlas_Enhancements', 
    pos = { x = 0, y = 1 },    
    config = { mult = 20, x_mult = 0.75 },
    loc_vars = function(self, info, card)
        return { vars = {card.ability.mult, card.ability.x_mult} }
    end
}

--Malus cards
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

--Bricked cards
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

--None cards
SMODS.Enhancement {
    key = 'none',
    atlas = 'centers',
    prefix_config = {atlas = false},
    pos = { x = 1, y = 0 },
    no_rank = true,
    no_suit = true,
    replace_base_card = true,
    always_scores = true,

    config = {extra =  {
        bonus = 20,
        x_chips = 2,
        mult = 4,
        x_mult = 1.5,
        h_chips = 100,
        h_x_chips = 1.5,
        h_mult = 20,
        h_x_mult = 2,
        p_dollars = 4,
        h_dollars = 6,
        level_up = 1,
        odds = 11
    }},

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            local ret = {}
            if SMODS.pseudorandom_probability(card, 'rebal_none_mult', 1, card.ability.extra.odds) then
                ret.mult = card.ability.extra.mult
            end
            if SMODS.pseudorandom_probability(card, 'rebal_none_xmult', 1, card.ability.extra.odds) then
                ret.xmult = card.ability.extra.x_mult
            end
            if SMODS.pseudorandom_probability(card, 'rebal_none_xchips', 1, card.ability.extra.odds) then
                ret.xchips = card.ability.extra.x_chips
            end
            if SMODS.pseudorandom_probability(card, 'rebal_none_bonus', 1, card.ability.extra.odds) then
                ret.bonus = card.ability.extra.bonus
            end
            if SMODS.pseudorandom_probability(card, 'rebal_none_pdollars', 1, card.ability.extra.odds) then
                ret.dollars = card.ability.extra.p_dollars
            end
            if SMODS.pseudorandom_probability(card, 'rebal_none_levelup', 1, card.ability.extra.odds) then
                ret.level_up = card.ability.extra.level_up
            end
            return ret
        end

        if context.cardarea == G.hand and context.main_scoring then
            local ret = {}
            if SMODS.pseudorandom_probability(card, 'rebal_none_hmult', 1, card.ability.extra.odds) then
                ret.h_mult = card.ability.extra.h_mult
            end
            if SMODS.pseudorandom_probability(card, 'rebal_none_hxmult', 1, card.ability.extra.odds) then
                ret.h_x_mult = card.ability.extra.h_x_mult
            end
            if SMODS.pseudorandom_probability(card, 'rebal_none_hchips', 1, card.ability.extra.odds) then
                ret.h_chips = card.ability.extra.h_chips
            end
            if SMODS.pseudorandom_probability(card, 'rebal_none_hxchips', 1, card.ability.extra.odds) then
                ret.h_x_chips = card.ability.extra.h_x_chips
            end
            if SMODS.pseudorandom_probability(card, 'rebal_none_hdollars', 1, card.ability.extra.odds) then
                ret.h_dollars = card.ability.extra.h_dollars
            end
            return ret
        end
    end
}

--Omni cards
SMODS.Enhancement {
    key = "omni",
    atlas = "Rebatlas_Enhancements",
    pos = { x = 2, y = 1 },
    config = {any_rank = true},
    any_suit = true,
    overrides_base_rank = true,
    replace_base_card = true,
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