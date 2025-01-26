# frozen_string_literal: true

require 'minitest/autorun'
require 'hexa'
require 'pry-byebug'

class OperatorsSyntax < Hexa::Scope
  Suit = type enum(club: 'C', diamond: 'D', spade: 'S', heart: 'H')

  Rank = type enum[two: '2', three: '3', four: '4', five: '5', six: '6', seven: '7', eight: '8',
                   nine: '9', ten: '10', jack: 'J', queen: 'Q', king: 'K', ace: 'A']

  Card = type Suit * Rank

  Hand = type ~Card

  Deck = type ~Card

  Player = type str[:name] * Hand[:hand]

  Game = type Deck * ~Player

  Deal = implement fn Deck >> Deck * Card
  def deal(deck)
    card = deck.first
    new_deck = deck[2..]

    [new_deck, card]
  end

  PickupCard = implement fn Hand * Card >> Hand
  def pickup_card(hand, card)
    hand.to_a + [card]
  end

  export
end


class ScquareBracesSyntax < Hexa::Scope
  Suit = type enum[club: 'C', diamond: 'D', spade: 'S', heart: 'H']

  Rank = type enum[two: '2', three: '3', four: '4', five: '5', six: '6', seven: '7', eight: '8',
                   nine: '9', ten: '10', jack: 'J', queen: 'Q', king: 'K', ace: 'A']

  Card = type tuple[Suit, Rank]

  Hand = type list[Card]

  Deck = type list[Card]

  Player = type tuple[name: str, hand: Hand]  # which is also equivalent to tuple[str[:name], Hand[:hand]]

  Game = type tuple[Deck, list[Player]]

  Deal = implement fn func[Deck, tuple[Deck, Card]]
  def deal(deck)
    card = deck.first
    new_deck = deck[2..]

    [new_deck, card]
  end

  PickupCard = implement fn func[tuple[Hand, Card], Hand]
  def deal(deck)
    card = deck.first
    new_deck = deck[2..]

    [new_deck, card]
  end
end

class Example < Hexa::Scope
  t1 = type record.wip
  selection_1 = str >> either(t1)
  f1 = const selection_1
  f2 = const selection_1
  f3 = const selection_1
  f4 = const selection_

  f4 = one_of(all_of(f1[:f1], f2[:f2], f3[:f3]), f4)
end

