tool
extends WindowDialog


onready var hide_script_panel_button = $MarginContainer/VBoxContainer/SettingsVB/HideScriptPanelOnStart
onready var include_help_pages_button = $MarginContainer/VBoxContainer/SettingsVB/IncludeHelpPages
onready var adaptive_height_button = $MarginContainer/VBoxContainer/SettingsVB/AdaptiveHeight
onready var show_path_for_recent_button = $MarginContainer/VBoxContainer/SettingsVB/ShowPathForRecentFiles
onready var keyboard_shortcut_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeyboardShortcut/LineEdit
onready var width_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/WindowWidth/LineEdit
onready var max_height_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/WindowMaxHeight/LineEdit
onready var keyword_goto_line_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordGotoLine/LineEdit
onready var keyword_goto_method_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordGotoMethod/LineEdit
onready var keyword_all_files_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordAllFiles/LineEdit
onready var keyword_all_scenes_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordAllScenes/LineEdit
onready var keyword_all_scripts_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordAllScripts/LineEdit
onready var keyword_all_open_scenes_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordOpenScenes/LineEdit
onready var keyword_select_node_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordSelectNode/LineEdit
onready var keyword_editor_settings_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordSettings/LineEdit
onready var keyword_set_inspector_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordInspector/LineEdit
onready var keyword_folder_tree_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordFileTree/LineEdit
onready var keyword_texteditor_plugin_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordTexteditorPlugin/LineEdit
onready var keyword_todo_plugin_LineEdit = $MarginContainer/VBoxContainer/SettingsVB/KeywordTODOPlugin/LineEdit


func _ready() -> void:
	load_settings()


func _unhandled_key_input(event: InputEventKey) -> void:
	if visible:
		get_tree().set_input_as_handled()


func _on_SaveButton_pressed() -> void:
	save_settings()
	hide()


func _on_DefaultsButton_pressed() -> void:
	load_default_settings()


func _on_CommandPaletteSettings_popup_hide() -> void:
	load_settings()
	get_parent().filter.grab_focus()


func load_settings() -> void:
	var config = ConfigFile.new()
	var error = config.load("user://command_palette_settings.cfg")
	
	if error == ERR_FILE_NOT_FOUND:
		load_default_settings()
		save_settings()
	
	elif error == OK:
		width_LineEdit.text = config.get_value("Settings", "width") as String
		max_height_LineEdit.text = config.get_value("Settings", "max_height") as String
		keyboard_shortcut_LineEdit.text = config.get_value("Settings", "keyboard_shortcut")
		keyword_goto_line_LineEdit.text = config.get_value("Settings", "goto_line")
		keyword_goto_method_LineEdit.text = config.get_value("Settings", "goto_method")
		keyword_all_files_LineEdit.text = config.get_value("Settings", "keyword_all_files")
		keyword_all_scenes_LineEdit.text = config.get_value("Settings", "keyword_all_scenes")
		keyword_all_scripts_LineEdit.text = config.get_value("Settings", "keyword_all_scripts")
		keyword_all_open_scenes_LineEdit.text = config.get_value("Settings", "keyword_all_open_scenes")
		keyword_select_node_LineEdit.text = config.get_value("Settings", "keyword_select_node")
		keyword_editor_settings_LineEdit.text = config.get_value("Settings", "keyword_editor_settings")
		keyword_set_inspector_LineEdit.text = config.get_value("Settings", "keyword_set_inspector")
		keyword_folder_tree_LineEdit.text = config.get_value("Settings", "keyword_folder_tree")
		keyword_texteditor_plugin_LineEdit.text = config.get_value("Settings", "keyword_texteditor_plugin")
		keyword_todo_plugin_LineEdit.text = config.get_value("Settings", "keyword_todo_plugin")
		hide_script_panel_button.pressed = bool(config.get_value("Settings", "hide_script_panel"))
		include_help_pages_button.pressed = bool(config.get_value("Settings", "include_help_pages"))
		adaptive_height_button.pressed = bool(config.get_value("Settings", "adaptive_height"))
		show_path_for_recent_button.pressed = bool(config.get_value("Settings", "show_path_for_recent"))


func load_default_settings() -> void:
	var screen_factor = max(OS.get_screen_dpi() / 100, 1)
	width_LineEdit.text = clamp(1500 * screen_factor, 0, OS.get_screen_size().x * 0.75) as String
	max_height_LineEdit.text = clamp(OS.get_screen_size().y / 2 + 200 * screen_factor, 0, OS.get_screen_size().y * 0.75) as String
	keyboard_shortcut_LineEdit.text = "Command+P" if OS.get_name() == "OSX" else "Control+P"
	keyword_goto_line_LineEdit.text = "g "
	keyword_goto_method_LineEdit.text = "m "
	keyword_all_files_LineEdit.text = "a "
	keyword_all_scenes_LineEdit.text = "as "
	keyword_all_scripts_LineEdit.text = "ac "
	keyword_all_open_scenes_LineEdit.text = "s "
	keyword_select_node_LineEdit.text = "n "
	keyword_editor_settings_LineEdit.text = "sett "
	keyword_set_inspector_LineEdit.text = "set "
	keyword_folder_tree_LineEdit.text = "res"
	keyword_texteditor_plugin_LineEdit.text = "file "
	keyword_todo_plugin_LineEdit.text = "todo "
	hide_script_panel_button.pressed = false
	include_help_pages_button.pressed = false
	adaptive_height_button.pressed = true
	show_path_for_recent_button.pressed = false


func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("Settings", "width", width_LineEdit.text)
	config.set_value("Settings", "max_height", max_height_LineEdit.text)
	config.set_value("Settings", "keyboard_shortcut", keyboard_shortcut_LineEdit.text)
	config.set_value("Settings", "goto_line", keyword_goto_line_LineEdit.text)
	config.set_value("Settings", "goto_method", keyword_goto_method_LineEdit.text)
	config.set_value("Settings", "keyword_all_files", keyword_all_files_LineEdit.text)
	config.set_value("Settings", "keyword_all_scenes", keyword_all_scenes_LineEdit.text)
	config.set_value("Settings", "keyword_all_scripts", keyword_all_scripts_LineEdit.text)
	config.set_value("Settings", "keyword_all_open_scenes", keyword_all_open_scenes_LineEdit.text)
	config.set_value("Settings", "keyword_select_node", keyword_select_node_LineEdit.text)
	config.set_value("Settings", "keyword_editor_settings", keyword_editor_settings_LineEdit.text)
	config.set_value("Settings", "keyword_set_inspector", keyword_set_inspector_LineEdit.text)
	config.set_value("Settings", "keyword_folder_tree", keyword_folder_tree_LineEdit.text)
	config.set_value("Settings", "keyword_texteditor_plugin", keyword_texteditor_plugin_LineEdit.text)
	config.set_value("Settings", "keyword_todo_plugin", keyword_todo_plugin_LineEdit.text)
	config.set_value("Settings", "hide_script_panel", hide_script_panel_button.pressed if hide_script_panel_button.pressed else "")
	config.set_value("Settings", "include_help_pages", include_help_pages_button.pressed if include_help_pages_button.pressed else "")
	config.set_value("Settings", "adaptive_height", adaptive_height_button.pressed if adaptive_height_button.pressed else "")
	config.set_value("Settings", "show_path_for_recent", show_path_for_recent_button.pressed if show_path_for_recent_button.pressed else "")
	config.save("user://command_palette_settings.cfg")
