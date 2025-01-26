# frozen_string_literal: true

require 'minitest/autorun'
require 'hexa'
require 'pry-byebug'

class OperatorsSyntax < Hexa::Scope
  Suit = type enum(club: 'C', diamond: 'D', spade: 'S', heart: 'H')

  Rank = type enum(two: '2', three: '3', four: '4', five: '5', six: '6', seven: '7', eight: '8',
                   nine: '9', ten: '10', jack: 'J', queen: 'Q', king: 'K', ace: 'A')

  Card = type Suit * Rank

  Hand = type Card.list

  Deck = type Card.list

  Player = type record(name: str, hand: Hand)

  Game = type Deck * Player.list

  Deal = fn Deck >> Deck * Card, :deal

  PickupCard = fn Hand * Card >> Hand, :pickup_card

  def deal(deck)
    card = deck.first
    new_deck = deck[2..]

    [new_deck, card]
  end

  def pickup_card(hand, card)
    hand.to_a + [card]
  end

  export
end


class ScquareBracesSyntax < Hexa::Scope
  Suit = type enum(club: 'C', diamond: 'D', spade: 'S', heart: 'H')

  Rank = type enum(two: '2', three: '3', four: '4', five: '5', six: '6', seven: '7', eight: '8',
                   nine: '9', ten: '10', jack: 'J', queen: 'Q', king: 'K', ace: 'A')

  Card = type tuple(Suit, Rank)

  Hand = type Card.list

  Deck = type Card.list

  Player = type tuple(name: str, hand: Hand)  # which is also equivalent to tuple[str[:name], Hand[:hand]]

  Game = type tuple(Deck, Player.list)

  Deal = fn func(Deck, tuple(Deck, Card)), :deal

  PickupCard = fn func(tuple(Hand, Card), Hand), :pickup_card

  def deal(deck)
    card = deck.first
    new_deck = deck[2..]

    [new_deck, card]
  end

  def pickup_card(hand, card)
    hand.to_a + [card]
  end
end

