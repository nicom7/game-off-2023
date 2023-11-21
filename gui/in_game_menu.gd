extends CanvasLayer

signal closed()

enum TabIndex
{
	IN_GAME_MENU,
	SETTINGS_MENU,
	CREDITS_MENU,
}


func _on_credits_menu_contents_back_pressed() -> void:
	%TabContainer.current_tab = TabIndex.IN_GAME_MENU


func _on_settings_menu_contents_back_pressed() -> void:
	%TabContainer.current_tab = TabIndex.IN_GAME_MENU


func _on_in_game_menu_contents_settings_pressed() -> void:
	%TabContainer.current_tab = TabIndex.SETTINGS_MENU


func _on_in_game_menu_contents_credits_pressed() -> void:
	%TabContainer.current_tab = TabIndex.CREDITS_MENU


func _on_in_game_menu_contents_exit_pressed() -> void:
	get_tree().quit()


func _on_in_game_menu_contents_close_pressed() -> void:
	closed.emit()
