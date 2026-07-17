SMODS.Atlas {
    key = "Rebatlas_Misc",
    path = "rebatlas_misc.png",
    px = 71,
    py = 95
}

--Reverse joker rarity
SMODS.Rarity {
    key = "reverse",
    pools = {},
    badge_colour = G.C.REVERSE_TAROT,
}

--Reverse Tarots
SMODS.ConsumableType {
    key = "RevTarot",
    default = "c_rebal_revfool",
    primary_colour = G.C.REVERSE_TAROT,
    secondary_colour = G.C.REVERSE_TAROT,
    text_colour = HEX("000000"),
    collection_rows = { 5, 6 }
}
SMODS.UndiscoveredSprite {
    key = "RevTarot",
    atlas = "Rebatlas_Misc",
    pos = { x = 1, y = 0 },
    overlay_pos = { x = 2, y = 0 }
}

--Broken Sticker
SMODS.Sticker {
    key = "broken",
    atlas = "Rebatlas_Misc",
    pos = { x = 0, y = 0 },
    badge_colour = G.C.RED,

    always_scores = true,
    config = {broken_cycle= 3, broken_tally= 3},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.rebal_broken.broken_cycle, card.ability.rebal_broken.broken_tally } }
    end,

    sets = {
        Joker = true
    },

    calculate = function(self, card, context)
        if context.before then
                if card.ability.rebal_broken.broken_tally == 1 then
                    card.ability.rebal_broken.broken_tally = card.ability.rebal_broken.broken_cycle
                    return {
                        message = localize('k_disabled_ex'),
                        colour = G.C.FILTER,
                        delay = 0.45,
                        func = function()
                            card:set_debuff(true)
                        end
                    }
                else
                    card.ability.rebal_broken.broken_tally = card.ability.rebal_broken.broken_tally - 1
                end
            end
    end

}


--Reverse Arcana pack
--takes ownership of arcana packs, and gives them a chance to be reverse
--chance starts at 20%, increases by 5% each time a reverse arcana pack is not drawn, and resets to 20% when one is drawn
--chance increases by a flat 10% when reverse fool is used
SMODS.Booster:take_ownership_by_kind("Arcana", 
{
    ease_background_colour = function(self)
        --random call
        if pseudorandom('reverse_arcana') < (G.GAME.rev_arcana_chance + G.GAME.rev_arcana_cumul_chance) then
            G.GAME.rev_arcana_cumul_chance = 0
            G.GAME.in_reverse_arcana_pack = true
            ease_colour(G.C.DYN_UI.MAIN, G.C.REVERSE_TAROT)
            ease_background_colour{new_colour = darken(G.C.BLACK, 0.2), special_colour = G.C.REVERSE_TAROT, contrast = 3}
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                func = function()
                    attention_text({
                        scale = 0.8,
                        text = "Skipping will banish rightmost joker!",
                        hold = 12,
                        align = "cm",
                        offset = { x = 0, y = -2.7 },
                        major = G.play,
                    })
                return true
                end
            }))
        else
            G.GAME.rev_arcana_cumul_chance = G.GAME.rev_arcana_cumul_chance + 0.05
            G.GAME.in_reverse_arcana_pack = false
            ease_background_colour_blind(G.STATES.TAROT_PACK)
        end
    end,

    create_card = function(self, card, i)
        local _card
        if not G.GAME.in_reverse_arcana_pack then
            if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
                _card = {
                    set = "Spectral",
                    area = G.pack_cards,
                    skip_materialize = true,
                    soulable = true,
                    key_append =
                    "ar2"
                }
            else
                _card = {
                    set = "Tarot",
                    area = G.pack_cards,
                    skip_materialize = true,
                    soulable = true,
                    key_append =
                    "ar1"
                }
            end
        else
            _card = {
                    set = "RevTarot",
                    area = G.pack_cards,
                    skip_materialize = true,
                    soulable = true,
                    key_append =
                    "rebal_ar3"
                }
        end
    return _card
    end
}
,true)

--Hollow shader
SMODS.ScreenShader {
    key = "hollow",
    path = "hollow.fs",
    should_apply = function()
        return G.GAME.used_revsoul
    end,

    send_vars = function(self)
        return { fade = G.screenshader_fade }
    end
}

--Hollow music
SMODS.Sound {
    key = "hollow_music",
    path = "hollow.ogg",
    select_music_track = function()
        if G.GAME.used_revsoul then
            return 100
        else
            return nil
        end
    end
}

--None Deck
SMODS.Back {
    key = "none",
    pos = { x = 1, y = 0 },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
           trigger = 'immediate',
           delay = 0,
           func = function()
                for _, c in ipairs(G.deck.cards) do
                    c:set_ability('m_rebal_none')
                end
                return true
            end
        }))
    end,
}