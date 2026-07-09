return {
	["misc"] = {
		["labels"] = {
			["rebal_shitty"] = "Shitty",
			["rebal_broken"] = "Broken",
			["revtarot"] = "Reverse Tarot",
			["k_rebal_reverse"] = "Reverse"
		},
		["dictionary"] = {
			["k_revtarot"] = "Reverse Tarot",
			["b_revtarot_cards"] = "Reverse Tarot Cards",
			["k_rebal_reverse"] = "Reverse"

		}
		},
	["descriptions"] = {
		["Other"] = {
			["rebal_broken"] = {
				["name"] = "Broken",
				["text"] = {
					"Debuffed every {C:attention}#1#{} hands",
					"{C:inactive}({C:attention}#2#{C:inactive} remaining)"
				},
			},
		},
		["Blind"] = {
			
		},
		["Joker"] = {
			["j_rebal_asspoo"] = {
				["name"] = "Asspoo",
				["text"] = {
					"Poops on your score, giving you",
					"{C:chips}#1#{} Chips.",
				},
			},
			["j_rebal_tableturner"] = {
				["name"] = "Table Turner",
				["text"] = {
					"If Chips are negative, turn them positive",
					"and gain {X:chips,C:white}X#1#{} Chips",
					"If Mult is negative, turn it positive",
					"and gain {X:mult,C:white}X#2#{} Mult",
					"{C:inactive,s:0.9}(Always negative)",
				},
			},
			["j_rebal_nubby"] = {
				["name"] = "{V:1}Nubby",
				["text"] = {
					"Add {C:attention}#1#{} selected cards", 
					"from the deck to the hand,",
					"replenishes every shop and round",
					"{C:inactive}#2# remaining"
				},
			},
			["j_rebal_opjoker"] = {
				["name"] = "Overpowered Joker",
				["text"] = {
					"{X:legendary,C:white}^^#1#{} Mult"
				},
			},
			["j_rebal_revcaino"] = {
				["name"] = "{V:1}Reverse Canio",
				["text"] = {
					"{C:red}Destroys{} every",
					"{C:attention}face{} card played"
				},
			},
			["j_rebal_revperkeo"] = {
				["name"] = "{V:1}Reverse Perkeo",
				["text"] = {
					"{C:red}Destroys{} every {C:attention}consumable{} card",
					"in your possession",
					"at the end of the {C:attention}shop"
				},
			},
			["j_rebal_revyorick"] = {
				["name"] = "{V:1}Reverse Yorick",
				["text"] = {
					"{X:red,C:white}X#1#{} Mult",
					"loses {X:red,C:white}X#2#{} every",
					"{C:attention}card{} discarded",
					"resets every hand played"
				},
			},
			["j_rebal_revchicot"] = {
				["name"] = "{V:1}Reverse Chicot",
				["text"] = {
					"Turns every {C:attention}Blind{}",
					"into a {C:attention}Boss Blind{}"
				},
			},
			["j_rebal_revtriboulet"] = {
				["name"] = "{V:1}Reverse Triboulet",
				["text"] = {
					"Played {C:attention}Kings{} and {C:attention}Queens{}",
					"become {C:attention}Stone{} cards when scored",
					"{C:attention}Stone{} cards give {C:chips}#1#{} Chips",
				},
			},
			["j_rebal_nubby_reverse"] = {
				["name"] = "{V:1}Reverse Nubby",
				["text"] = {
					"Discards {C:attention}#1#{} random",
					"cards per hand played"
				},
			},


		
		},
		["Tarot"] = {
			["c_rebal_winbtn"] = {
				["name"] = "Win Button",
				["text"] = {
					"{C:inactive,s:1.2,E:1}Win.",
				},
			},
			["c_rebal_baronmime"] = {
				["name"] = "Instant Baron Mime",
				["text"] = {
					"Creates {C:attention}Baron{} and {C:attention}Mime{}",
					"then transforms deck into", 
					"{C:attention}Red Seal Steel Kings",
				},
			},
			

		},
		["RevTarot"] = {
			["c_rebal_revfool"] = {
				["name"] = "Reverse Fool",
				["text"] = {
					"{V:1}Banishes{} the last", 
					"{C:tarot}Tarot{} or {C:planet}Planet{} card",
					"used during this run",
					"Increases the chance of {V:1}Reverse Soul{}",
					"and {V:1}Reverse Arcana Packs{} appearing"
				},
			},
			["c_rebal_revmagician"] = {
				["name"] = "Reverse Magician",
				["text"] = {
					"Enhances {C:attention}2",
					"selected cards into",
					"{C:attention}Unlucky Cards{}",
				},
			},
			["c_rebal_revhighpriestess"] = {
				["name"] = "Reverse High Priestess",
				["text"] = {
					"Reduces the level of",
					"{C:attention}#2#{} random hands",
					"Earn {C:money}$#1#{}",
				},
			},
			["c_rebal_revemperor"] = {
				["name"] = "Reverse Emperor",
				["text"] = {
					"{V:1}Cancels{} the next",
					"{C:attention}#1#{} {C:tarot}Tarot{} cards used",
					"Gain {C:money}$#2#{} for each card cancelled",
				},
			},
			["c_rebal_revchariot"] = {
				["name"] = "Reverse Chariot",
				["text"] = {
					"Enhances {C:attention}1",
					"selected card into a",
					"{C:attention}Locked Card{}",
				},
			},
			["c_rebal_revjustice"] = {
				["name"] = "Reverse Justice",
				["text"] = {
					"Enhances {C:attention}1",
					"selected card into a",
					"{C:attention}Bricked Card{}",
				},
			},
			["c_rebal_revhermit"] = {
				["name"] = "Reverse Hermit",
				["text"] = {
					"{B:1,C:white}X$#1#{}",
					"Permanent {X:money,C:white}X$#2#{} gained",
					"{s:0.8}cannot be used if",
					"{s:0.8}money is already negative",
				},
			},
			["c_rebal_revwheel"] = {
				["name"] = "Reverse Wheel of Fortune",
				["text"] = {
					"Removes {C:attention}Edition{} of every",
					"{C:attention}Joker{} and {C:attention}card{} in deck",
					"Gain a positive effect",
					"for each {C:attention}Edition{} removed",
				},
			},
			["c_rebal_revstrength"] = {
				["name"] = "Reverse Strength",
				["text"] = {
					"Decreases rank of",
					"{C:attention}#1#{} selected ",
					"cards by {C:attention}#2#{}",
				},
			},
			["c_rebal_revhangedman"] = {
				["name"] = "Reverse Hanged Man",
				["text"] = {
					"Creates {C:attention}#1#{} random",
					"{C:attention}Enhanced{} cards",
				},
			},
			["c_rebal_revtemperance"] = {
				["name"] = "Reverse Temperance",
				["text"] = {
					"Sells {C:red}all{} {C:attention}Jokers{}",
					"for {X:attention,C:white}X#1#{} their sell value",
				},
			},
			["c_rebal_revdevil"] = {
				["name"] = "Reverse Devil",
				["text"] = {
					"Enhances {C:attention}1",
					"selected card into a",
					"{C:attention}Platinum Card{}",
				},
			},
			["c_rebal_revjudgement"] = {
				["name"] = "Reverse Judgement",
				["text"] = {
					"{C:red}destroys{} selected {C:attention}Joker{}",
					"Choose between {C:attention}#1# Jokers{}",
					"of the same {C:attention}rarity{}"
				},
			},
			["c_rebal_revsoul"] = {
				["name"] = "{V:1}Reverse Soul",
				["text"] = {
					"Creates an {C:attention}Eternal{} {C:dark_edition}Negative{}",
                    "{C:legendary,E:1}Legendary{} Joker",
					"{V:1}Replaces every consumable",
					"with {V:1}Hollow Soul{}",
				},
			},
			["c_rebal_hollowsoul"] = {
				["name"] = "{V:1}Hollow Soul",
				["text"] = {
					"Turns every {C:legendary,E:1}Legendary{} Joker",
					"into its {V:1}Reverse{} version",
				},
			},
		
		},
		["Enhanced"] = {
			["m_rebal_platinum"] = {
				["name"] = "Platinum Card",
				["text"] = {
					"{C:red}$#1#{} and {X:money,C:white}X$#2#{} if this",
					"card is held in hand",
					"at the end of the round",
				},
			},
			["m_rebal_locked"] = {
				["name"] = "Locked Card",
				["text"] = {
					"{X:mult,C:white}X#1#{} Mult",
					"forced to",
					"be selected"
				},
			},
			["m_rebal_bricked"] = {
				["name"] = "Bricked Card",
				["text"] = {
					"Cannot be {C:red}destroyed{}",
					"Cannot be {C:red}debuffed{}",
				},
			},
			["m_rebal_unlucky"] = {
                name = "Unlucky Card",
                text = {
                    "{C:green}#1# in #2#{} chance",
                    "for {C:mult}-#3#{} Mult and {C:money}$#6#",
                    "{C:green}#4# in #5#{} chance",
                    "for {C:red}$-#6#{} and {C:mult}#3#{} Mult",
                },
			},
		},
		["Edition"] = {
			["e_rebal_shitty"] = {
				["name"] = "Shitty",
				["text"] = {
					"{C:chips}#1#{} chips"
				},
			},
		},
	},
}