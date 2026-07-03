-- Makes a tarot announce something, à la Wheel of Fortune "Nope!"
function Tarot_quip(card, text, overrides)
    -- 1. Establish  baseline "default" settings
    local is_pack = G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
    local config = {
        text = text or 'Configure your quip!',
        scale = 1.3,
        hold = 1.4,
        major = card,
        backdrop_colour = G.C.SECONDARY_SET.Tarot,
        align = is_pack and 'tm' or 'cm',
        offset = { x = 0, y = is_pack and -0.2 or 0 },
        silent = true
    }

    -- 2. If the user passed overrides, merge them into the config
    if overrides then
        for k, v in pairs(overrides) do
            config[k] = v
        end
    end

    -- 3. Trigger the native Balatro engine function
    attention_text(config)
end

--flips cards, changes them and flips them back around,
function Change_cards(cards, rank, suit, enhancement, seal, edition, selected)
        for i = 1, #cards do
            local c = cards[i]
            local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    c:flip()
                    play_sound('card1', percent)
                    c:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #cards do
             local c = cards[i]
             local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3
             G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if c and not c.ability.destroyed then
                        if enhancement then c:set_ability(enhancement, true) end
                        if seal then c:set_seal(seal, true) end
                        if edition then c:set_edition(edition) end
                        if rank or suit then SMODS.change_base(c, suit, rank) end
                    end
                    return true
                end
            }))
        end
        for i = 1, #cards do
            local c = cards[i]
            local percent = 0.85 + (i - 0.999) / (#cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    c:flip()
                    play_sound('tarot2', percent, 0.6)
                    c:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        if selected then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end
        delay(0.5)
end

--Returns a random hand (from ***Lib)
function Get_random_hand(ignore, seed, allowhidden)
			local chosen_hand
			ignore = ignore or {}
			seed = seed or "randomhand"
			if type(ignore) ~= "table" then
				ignore = { ignore }
			end
			while true do
				chosen_hand = pseudorandom_element(G.handlist, pseudoseed(seed))
				if G.GAME.hands[chosen_hand].visible or allowhidden then
					local safe = true
					for _, v in pairs(ignore) do
						if v == chosen_hand then
							safe = false
						end
					end
					if safe then
						break
					end
				end
			end
			return chosen_hand
		end


--Rev Wheel effects
 function Edition_effects(key, source, card)
    --holo levels up a random hand
    if key == "e_holo" then
        local randhand = Get_random_hand() --Random poker hand
        update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3, immediate=true}, {
            handname = localize(randhand, "poker_hands"),
            chips = G.GAME.hands[randhand].chips,
            mult = G.GAME.hands[randhand].mult,
            level = G.GAME.hands[randhand].level,
        })
        level_up_hand(source, randhand, true)
		update_hand_text(
			{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0, immediate=true },
			{ mult = 0, chips = 0, handname = "", level = "" }
		)
    --foil creates a random tarot (must have space)
    elseif key == "e_foil" then
        if #G.consumeables.cards < G.consumeables.config.card_limit then
            SMODS.add_card({ set = "Tarot"})
        end
        attention_text({
            text = "Tarot!",
            backdrop_colour = G.C.SECONDARY_SET.Tarot,
            align = 'bm',
            hold = 1.4,
            major = card
        })
    --polychrome gives 1.1x perma money
    elseif key == "e_polychrome" then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                G.GAME.dollar_bonus = G.GAME.dollar_bonus * 1.1
                return {
                    text = "X$1.1",
                    align = 'cm',
                    scale = 0.8,
                    hold = 0.7,
                    cover = G.HUD:get_UIE_by_ID('dollar_text_UI').parent,
                    cover_colour = G.C.FILTER,
                }
            end
        }))
    --negative gives a negative spectral card
    elseif key == "e_negative" then
        SMODS.add_card({ set = "Spectral", edition = "e_negative" })
        attention_text({
            text = "Spectral!",
            backdrop_colour = G.C.SECONDARY_SET.Spectral,
            align = 'bm',
            hold = 1.4,
            major = card
        })
    
    -- other editions give 10$
    else
        ease_dollars(10, true)
        
    end
end

--hook to make win button, Nubby and rev judgement work
local clickref = Card.click
function Card:click()
    if self.ability.name == "c_rebal_winbtn" and not G.SETTINGS.paused then
            G.FUNCS.use_card({config = {ref_table = self}})
    end

    if self.area and self.area.config.type == "title" and G.GAME.nubby_active and G.GAME.nubby_tally > 0 then
        if not self.greyed then
            local deck_card = nil
            for _, card in ipairs(G.deck.cards) do
                if card.base.value == self.base.value and  card.base.suit == self.base.suit and self.seal == card.seal and ((self.edition and card.edition and self.edition.key == card.edition.key) or (not self.edition and not card.edition))then
                    if #self.ability == #card.ability then
                        local all_match = true
                        for k, v in pairs(self.ability) do
                            if type(v) == 'number' then
                                if card.ability[k] ~= v then
                                    all_match = false
                                    break
                                end
                            end
                        end
                        if all_match then
                            deck_card = card
                            break
                        end
                    end 
                end
            end

            if deck_card then
                G.GAME.nubby_tally = G.GAME.nubby_tally - 1
                
                self.greyed = true
                self:set_sprites(nil, self.config.card)

                draw_card(G.deck, G.hand, 90, 'up', false, deck_card)
                if G.GAME.nubby_tally == 0 then
                    --ability fully used up
                    play_sound("timpani")
                end
            else
                play_sound("cancel")
                self:juice_up(0.3, 0.3)
            end
        else
            play_sound("cancel")
            self:juice_up(0.3, 0.3)
        end
    end

    if G.GAME.revjudgement_active and self.area.config.type == "title" then
        SMODS.add_card({key=self.config.center.key})
        G.FUNCS:disable_revjudgement()
    end
    
    clickref(self)
end

--hooks to make locked cards work in boosters
local cardarea_updateref = CardArea.update
function CardArea:update(dt)
    cardarea_updateref(self, dt)

    --this says: if we're in a booster pack and there's a forced selection card, highlight it (basically make that function work in the packs.)
    if self == G.pack_cards then
        for _, card in pairs(self.cards) do
            if card.ability.forced_selection and not card.highlighted then
                self:add_to_highlighted(card)
                break
            end
        end
    end
end

local cardarea_add_to_highlighted_ref = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
    --this says: if we're in a booster pack and there's a forced selection card in the highlighted, make sure only that card is highlighted. 
    if self.highlighted[1] and self == G.pack_cards then
        for _, highlighted_card in ipairs(self.highlighted) do
            if highlighted_card.ability and highlighted_card.ability.forced_selection then
                if not (card.ability and card.ability.forced_selection) then
                    return
                end
                break
            end
        end
    end

    cardarea_add_to_highlighted_ref(self, card, silent)
end
--end of locked card hooks

--mod_calc make broken cards and rev arcanas work
function SMODS.current_mod.calculate(self, context)
    if context.after then
        for k, v in pairs(G.jokers.cards) do
            if v.ability["rebal_broken"] and v.debuff then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.45,
                    func = function()
                        SMODS.debuff_card(v, false, "rebal_broken")
                        v:juice_up(0.3, 0.3)
                        attention_text({
                            text = "Repaired!",
                            backdrop_colour = G.C.GREEN,
                            align = 'bm',
                            major = v,
                            delay = 0.45
                        })
                        return true
                    end
                }))
            end
        end
    end

    if context.open_booster then
        G.GAME.in_reverse_arcana_pack = false
    end
end

--redefs can_skip_booster to not allow skipping reverse arcana packs
G.FUNCS.can_skip_booster = function(e)
    if not G.GAME.in_reverse_arcana_pack and (not (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) and
    (G.STATE == G.STATES.SMODS_BOOSTER_OPENED or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.STANDARD_PACK or G.STATE == G.STATES.BUFFOON_PACK or (G.hand  )) then 
        e.config.colour = G.C.GREY
        e.config.button = 'skip_booster'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

--redefs ease_dollars to make rev hermit work
local easedollarref = ease_dollars
function ease_dollars(mod, instant)
    if mod > 0 then
        mod = mod*G.GAME.dollar_bonus
    end
    easedollarref(mod, instant)
end

--hook to make hollow soul spawns work
local createcardref = SMODS.create_card
function SMODS.create_card(t)
    if G.GAME.used_revsoul and t.set ~= "Joker" then
        t.key = "c_rebal_hollowsoul"
        return createcardref(t)
    else
        return createcardref(t)
    end
end

--self explanatory, makes rev judgement work
G.FUNCS.disable_revjudgement = function()
    G.GAME.revjudgement_active = false
    G.GAME.used_jokers = G.GAME.usedjokerref
    G.FUNCS:exit_overlay_menu()
end

Create_UIBox_revjudgement = function(rarity, len)
    local cards = {}
    local legendary = nil
		--please someone add a rarity api to steamodded
		if rarity == 1 then
			rarity = 0
		elseif rarity == 2 then
			rarity = 0.9
		elseif rarity == 3 then
			rarity = 0.99
		elseif rarity == 4 then
			rarity = nil
			legendary = true
		end

    local pool = SMODS.get_clean_pool("Joker", rarity, legendary)
    for i, c in ipairs(pool) do
        for _, j in ipairs(G.jokers.cards) do
            if j.config.center.key == c then
                table.remove(pool, i)
                break
            end
        end
    end

    for i = 1, len do
		local center = G.P_CENTERS[pseudorandom_element(pool , pseudoseed("revjudgement"..i))]
        cards[#cards + 1] = center
        for i, c in ipairs(pool) do
            if c == center.key then
                table.remove(pool, i)
                break
            end
        end
	end
    
	return SMODS.card_collection_UIBox(cards, { len%5, math.ceil(len/5) }, {
		no_materialize = true,
		snap_back = true,
		h_mod = 1.03,
		hide_single_page = true,
        back_func = "disable_revjudgement"
	})
end

