SMODS.Shader { key = "shitty", path = "shitty.fs" }

SMODS.Edition({
    key = "shitty",
    discovered = true,
    unlocked = true,
    shader = 'shitty',
    in_shop = true,
    --should be applied automatically
    config = { chips = -30 },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.chips } }
    end,
    calculate = function(self, card, context)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                chips = card.edition.chips
            }
        end
    end
})