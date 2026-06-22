class_name BattleManager
extends Node2D

var player: Player
var enemy: Enemy
var current_turn: String = "player"
var battle_active: bool = false

@onready var enemy_node = $GameLayer/Enemy
@onready var player_node = $GameLayer/Player
@onready var enemy_health_bar = $UILayer/Control/EnemyHUD/EnemyHealthBar
@onready var enemy_armor_label = $UILayer/Control/EnemyHUD/EnemyArmorLabel
@onready var enemy_intent_label = $UILayer/Control/EnemyHUD/IntentLabel
@onready var player_health_bar = $UILayer/Control/PlayerHUD/PlayerHealthBar
@onready var player_armor_label = $UILayer/Control/PlayerHUD/PlayerArmorLabel
@onready var energy_label = $UILayer/Control/PlayerHUD/EnergyLabel
@onready var turn_label = $UILayer/Control/ActionPanel/TurnLabel
@onready var end_turn_button = $UILayer/Control/ActionPanel/EndTurnButton
@onready var hand_container = $UILayer/Control/HandContainer

func _ready() -> void:
	_initialize_battle()
	end_turn_button.pressed.connect(_on_end_turn_pressed)

func _initialize_battle() -> void:
	# 创建玩家
	player = Player.new()
	add_child(player)
	
	# 创建敌人
	enemy = Enemy.new()
	enemy.max_health = 50
	enemy.current_health = 50
	enemy.name_text = "哥布林"
	add_child(enemy)
	
	# 连接信号
	player.health_changed.connect(_on_player_health_changed)
	player.armor_changed.connect(_on_player_armor_changed)
	player.energy_changed.connect(_on_player_energy_changed)
	
	enemy.health_changed.connect(_on_enemy_health_changed)
	enemy.armor_changed.connect(_on_enemy_armor_changed)
	
	# 初始化 UI
	_update_ui()
	
	# 开始战斗
	battle_active = true
	start_player_turn()

func start_player_turn() -> void:
	current_turn = "player"
	turn_label.text = "玩家回合"
	end_turn_button.disabled = false
	
	player.end_turn()
	player.draw_cards(5)
	_update_hand_display()
	_update_ui()

func start_enemy_turn() -> void:
	current_turn = "enemy"
	turn_label.text = "敌人回合"
	end_turn_button.disabled = true
	
	enemy.plan_action()
	enemy_intent_label.text = "意图: %s" % enemy.intent
	_update_ui()
	
	await get_tree().create_timer(1.5).timeout
	
	enemy.execute_action(player)
	_update_ui()
	
	await get_tree().create_timer(1.0).timeout
	
	if player.is_alive() and battle_active:
		start_player_turn()
	elif not player.is_alive():
		battle_active = false
		turn_label.text = "你输了!"
		end_turn_button.disabled = true

func _on_end_turn_pressed() -> void:
	if current_turn == "player":
		if enemy.is_alive():
			start_enemy_turn()
		else:
			battle_active = false
			turn_label.text = "你赢了!"
			end_turn_button.disabled = true

func _update_hand_display() -> void:
	for i in range(hand_container.get_child_count()):
		var card_panel = hand_container.get_child(i)
		if i < player.hand.size():
			var card = player.hand[i]
			card_panel.get_node("CardLabel%d" % (i + 1)).text = "%s\n成本: %d" % [card.card_name, card.cost]
			card_panel.visible = true
		else:
			card_panel.visible = false

func _update_ui() -> void:
	# 敌人信息
	enemy_health_bar.max_value = enemy.max_health
	enemy_health_bar.value = enemy.current_health
	enemy_armor_label.text = "护甲: %d" % enemy.armor
	
	# 玩家信息
	player_health_bar.max_value = player.max_health
	player_health_bar.value = player.current_health
	player_armor_label.text = "护甲: %d" % player.armor
	energy_label.text = "能量: %d/%d" % [player.energy, player.max_energy]

func _on_player_health_changed(new_health: int) -> void:
	player_health_bar.value = new_health

func _on_player_armor_changed(new_armor: int) -> void:
	player_armor_label.text = "护甲: %d" % new_armor

func _on_player_energy_changed(new_energy: int) -> void:
	energy_label.text = "能量: %d/%d" % [new_energy, player.max_energy]

func _on_enemy_health_changed(new_health: int) -> void:
	enemy_health_bar.value = new_health

func _on_enemy_armor_changed(new_armor: int) -> void:
	enemy_armor_label.text = "护甲: %d" % new_armor
