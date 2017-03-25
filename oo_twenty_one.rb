# 1. Write a description of the problem and extract major nouns and verbs.
# 2. Make an initial guess at organizing the verbs into nouns and do a spike to explore the problem with temporary code.
# 3. Optional - when you have a better idea of the problem, model your thoughts into CRC cards.

# Description:
# The goal of the game is to get a hand that is closer to a score of 21 than your opponent but not above 21. Number cards are worth their number; Jacks, Queens, and Kings are worth 10, and an Ace can be worth 1 or 11, whichever the player chooses.
# The dealer deals to cards to him/herself and two to the dealer. The player chooses whether to hit (take another card) or stay (stop). S/he can keep choosing this (and seeing the card dealt) until s/he either busts (goes over 21) or stops. Then the dealer deals cards to him/herself, with the same process. If neither players has busted, after both have stayed, the one whose hand is closer to 21 wins. If a player busts, their opponent wins.

# Nouns: game, player, score, card, dealer -- deck, total
# Verbs: hit, stay, bust, deal

'''
Player
- hit
- stay
- busted?
- total
- deal ???

Deck
- deal (here or in Player)

Game
- start

'''
