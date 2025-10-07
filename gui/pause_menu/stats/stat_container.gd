## stat_container.gd

class_name Stats extends PanelContainer


# References
@onready var level_stat: Label = %LevelStat
@onready var xp_stat: Label = %XPStat
@onready var attack_stat: Label = %AttackStat
@onready var defence_stat: Label = %DefenceStat
@onready var attack_change: Label = %AttackChange
@onready var defence_change: Label = %DefenceChange


### -------------------- FUNCTIONS --------------

func _ready() -> void:
	PauseMenu.shown.connect(update_stats)


func update_stats() -> void:
	var _p : Player = GlobalPlayerManager.player
	level_stat.text = str(_p.level)
	if _p.level < GlobalPlayerManager.level_requirements.size():
		xp_stat.text = str(_p.xp) + " / " + str( GlobalPlayerManager.level_requirements[_p.level] )
	else:
		xp_stat.text = "MAX"
	attack_stat.text = str(_p.attack)
	defence_stat.text = str(_p.defence)
