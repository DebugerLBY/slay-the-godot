class_name CardDisplay
extends Panel

var card: Card
var is_hovered: bool = false
var battle_manager: BattleManager

@onready var card_name_label = $VBoxContainer/CardNameLabel
@onready var cost_label = $VBoxContainer/CostLabel
@onready var description_label = $VBoxContainer/DescriptionLabel
@onready var effect_label = $VBoxContainer/EffectLabel

signal card_clicked(card: Card)

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	
	# 设置卡牌样式
	add_theme_stylebox_override("panel", preload("res://assets/styles/card_normal.tres") if ResourceLoader.exists("res://assets/styles/card_normal.tres") else StyleBox.new())

func set_card(new_card: Card, manager: BattleManager) -> void:
	card = new_card
	battle_manager = manager
	_update_display()

func _update_display() -> void:
	if not card:
		return
	
	card_name_label.text = card.card_name
	cost_label.text = "成本: %d" % card.cost
	description_label.text = card.description
	
	# 根据效果类型显示效果
	var effect_text = ""
	match card.effect_type:
		"damage":
			effect_text = "伤害: %d" % card.effect_value
		"shield":
			effect_text = "护甲: %d" % card.effect_value
		"draw":
			effect_text = "抽卡: %d" % card.effect_value
		"heal":
			effect_text = "恢复: %d" % card.effect_value
		"strength":
			effect_text = "力量: +%d" % card.effect_value
	
	effect_label.text = effect_text
	
	# 根据稀有度设置颜色
	_set_rarity_color()

func _set_rarity_color() -> void:
	var color = Color.WHITE
	match card.rarity:
		"common":
			color = Color.WHITE
		"rare":
			color = Color.CYAN
		"epic":
			color = Color.MEDIUM_PURPLE
		"legendary":
			color = Color.GOLD
	
	card_name_label.add_theme_color_override("font_color", color)

func _on_mouse_entered() -> void:
	is_hovered = true
	scale = Vector2(1.1, 1.1)

func _on_mouse_exited() -> void:
	is_hovered = false
	scale = Vector2(1.0, 1.0)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if battle_manager and battle_manager.player:
			var success = battle_manager.player.play_card(card)
			if success:
				card_clicked.emit(card)
				battle_manager._update_hand_display()
				battle_manager._update_ui()
			else:
				# 播放失败音效或提示
				print("无法打出卡牌：能量不足")
