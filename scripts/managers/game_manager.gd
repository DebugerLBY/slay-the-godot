extends Node

var current_scene: String
var player_deck: Deck
var current_run: Dictionary = {}

func _ready() -> void:
	player_deck = Deck.new()

func start_new_run() -> void:
	current_run = {
		"level": 1,
		"floor": 0,
		"wins": 0,
		"losses": 0
	}

func get_player_deck() -> Deck:
	return player_deck

func add_card_to_deck(card: Card) -> void:
	player_deck.add_card(card)

func get_run_info() -> Dictionary:
	return current_run

func save_run() -> void:
	# TODO: 实现存档功能
	pass

func load_run() -> void:
	# TODO: 实现读档功能
	pass
