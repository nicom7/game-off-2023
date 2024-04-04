extends CanvasLayer

signal closed()

enum TabIndex
{
	IN_GAME_MENU,
	SETTINGS_MENU,
	HELP_MENU,
	CREDITS_MENU,
}


func _on_settings_menu_contents_back_pressed() -> void:
	%TabContainer.current_tab = TabIndex.IN_GAME_MENU


func _on_help_menu_contents_back_pressed() -> void:
	%TabContainer.current_tab = TabIndex.IN_GAME_MENU


func _on_credits_menu_contents_back_pressed() -> void:
	%TabContainer.current_tab = TabIndex.IN_GAME_MENU


func _on_in_game_menu_contents_settings_pressed() -> void:
	%TabContainer.current_tab = TabIndex.SETTINGS_MENU


func _on_in_game_menu_contents_help_pressed() -> void:
	%TabContainer.current_tab = TabIndex.HELP_MENU


func _on_in_game_menu_contents_credits_pressed() -> void:
	%TabContainer.current_tab = TabIndex.CREDITS_MENU


func _on_in_game_menu_contents_exit_pressed() -> void:
	$AcceptDialog.show()


func _on_in_game_menu_contents_close_pressed() -> void:
	closed.emit()


func _on_accept_dialog_confirmed() -> void:
	get_tree().quit()
