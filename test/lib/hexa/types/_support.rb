# frozen_string_literal: true

require 'minitest/autorun'
require 'hexa'
require 'pry-byebug'

SUITS = { club: 'C', diamond: 'D', spade: 'S', heart: 'H' }.freeze
RANKS = { two: '2', three: '3', four: '4', five: '5', six: '6', seven: '7', eight: '8',
          nine: '9', ten: '10', jack: 'J', queen: 'Q', king: 'K', ace: 'A' }.freeze

class OperatorsSyntax < Hexa::Scope
  club, diamond, spade, heart = constants(*SUITS.map { |k, v| str[k, eq: v] })

  Suit = type club | diamond | spade | heart

  two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace =
    constants(*RANKS.map { |k, v| str[k, eq: v] })

  Rank = type two | three | four | five | six | seven | eight | nine | ten | jack | queen | king | ace

  Card = type Suit * Rank

  Hand = type ~Card

  Deck = type ~Card

  Player = type str[:name] * Hand[:hand]

  Game = type Deck * ~Player

  Deal = const :deal, Deck >> Deck * Card

  PickupCard = const :pickup_card, Hand * Card >> Hand

  implement Deal
  def deal(deck)
    card = deck.first
    new_deck = deck[2..]

    [new_deck, card]
  end

  implement PickupCard
  def pickup_card(hand, card)
    hand.to_a + [card]
  end

  export nil, Deal, PickupCard
end


class ScquareBracesSyntax < Hexa::Scope
  Suit = type enum.of(**SUITS) # enum is just a syntax sugar. it will create consts and then a choice type

  Rank = type enum.of(**RANKS)

  Card = type tuple[Suit, Rank]

  Hand = type list[Card]

  Deck = type list[Card]

  Player = type tuple[name: str, hand: Hand]  # which is also equivalent to tuple[str[:name], Hand[:hand]]

  Game = type tuple[Deck, list[Player]]

  Deal = const func[Deck, tuple[Deck, Card]]

  PickupCard = const func[tuple[Hand, Card], Hand]

  implement Deal
  def deal(deck)
    card = deck.first
    new_deck = deck[2..]

    [new_deck, card]
  end
end

