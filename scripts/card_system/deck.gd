class_name Deck
extends Node

var cards: Array[Card] = []
var discard_pile: Array[Card] = []
var drawn_cards: Array[Card] = []

signal cards_changed

func add_card(card: Card) -> void:
	cards.append(card)
	cards_changed.emit()

func remove_card(card: Card) -> void:
	cards.erase(card)
	cards_changed.emit()

func shuffle_deck() -> void:
	cards.shuffle()

func draw_card(count: int = 1) -> Array[Card]:
	var result: Array[Card] = []
	
	for i in range(count):
		if cards.is_empty():
			# 重新洗牌弃牌堆
			if discard_pile.is_empty():
				break
			cards.append_array(discard_pile)
			discard_pile.clear()
			shuffle_deck()
		
		if not cards.is_empty():
			var card = cards.pop_front()
			drawn_cards.append(card)
			result.append(card)
	
	return result

func discard_card(card: Card) -> void:
	if card in drawn_cards:
		drawn_cards.erase(card)
		discard_pile.append(card)

func get_deck_size() -> int:
	return cards.size()

func get_hand_size() -> int:
	return drawn_cards.size()

func reset() -> void:
	cards.append_array(drawn_cards)
	cards.append_array(discard_pile)
	drawn_cards.clear()
	discard_pile.clear()
	shuffle_deck()
