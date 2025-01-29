# frozen_string_literal: true

require 'minitest/autorun'
require 'hexa'
require 'pry-byebug'

class OperatorsSyntax < Hexa::Scope
  Suit = enum club: 'C', diamond: 'D', spade: 'S', heart: 'H'

  Rank = enum two: '2', three: '3', four: '4', five: '5', six: '6', seven: '7', eight: '8',
              nine: '9', ten: '10', jack: 'J', queen: 'Q', king: 'K', ace: 'A'

  Card = Suit * Rank

  Hand = Card.list

  Deck = Card.list

  Player = str[:name] * Hand[:hand]

  Game = Deck * Player.list

  export_default fn :dael, Deck >> Deck * Card, instance_method: true

  export fn :pickup_card, Hand * Card >> Hand, instance_method: true


  def deal(deck)
    card = deck.first
    new_deck = deck[2..]

    [new_deck, card]
  end

  def pickup_card(hand, card)
    hand.to_a + [card]
  end
end


