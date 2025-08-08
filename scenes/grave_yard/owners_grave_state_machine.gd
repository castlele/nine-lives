class_name OwnersGraveStateMachine extends Object


enum Stage {
	FIRST,
	FIRST_HINT,
	SLEEPING,
}


signal player_bring_fish(collectable: CollectableData)

var _current_stage := Stage.FIRST


func make_interaction():
	match _current_stage:
		Stage.FIRST:
			_current_stage = Stage.FIRST_HINT
			LevelStateMachine.enqueue_messages([
				"\"bla bla bla\""
			])
		Stage.FIRST_HINT:
			if _is_giving_fish():
				_current_stage = Stage.SLEEPING
				_place_fish()
				LevelStateMachine.enqueue_messages([
					"\"I love you so much, my friend\"",
					"\"You are not my friend, you are my brother my friend\"",
				])
				return

			LevelStateMachine.enqueue_messages([
				"\"I think, he would be happy to have a fresh fish for dinner!\"",
				"\"I remember somewhere here was a path to the lake\"",
			])


func _is_giving_fish() -> bool:
	var items := LevelStateMachine.get_inventory()

	for item in items:
		if not item:
			continue

		if item.name.to_lower() == "fish":
			return true

	return false


func _place_fish() -> void:
	var items := LevelStateMachine.get_inventory()

	for i in range(len(items)):
		if not items[i] or items[i].name.to_lower() != "fish":
			continue

		LevelStateMachine.remove_inventory_item(i)
		items[i].interactable = false
		player_bring_fish.emit(items[i])
		return
