extends Node2D

@onready var viewport_main = get_viewport()
@onready var pannel_ground = $Panel_Ground
@onready var label_title = $Panel_Ground/Label_Title

var flag_mouse = true
var temp_dir = 0
var size = Vector2i(500, 300)
var file_data = FileData.new()
var file_flag : bool

class FileData:
	var path
	var type
	var name
	var text
	var file_access
	var text_line = []
	var line = 0 # 列数
	
	func init(files):
		path = files[0]
		type = files[0].get_extension()
		name = files[0].get_file()	
		file_access = FileAccess.open(files[0], FileAccess.READ)
		text = file_access.get_as_text()
		
		tag_serch()
		
	func tag_serch():
		while true:
			text_line.resize(line + 1)
			text_line[line] = file_access.get_line()
			
			var span_pos = text_line[line].findn("span")
			
			if span_pos != -1:
				var tag_end = text_line[line].findn("</", span_pos)
				var tag_start = text_line[line].findn(">", span_pos)
				var tango = text_line[line].substr(tag_start + 1, tag_end - tag_start - 1)
				print(tango)
				print(line)
				line = line + 1
				return tango
				break
			
			else:
				line = line + 1

		pass
	
	func title(str):
		return str
		



func _ready():
	# 信号
	viewport_main.files_dropped.connect(on_files_dropped)
	viewport_main.focus_entered.connect(on_focus_entered)
	viewport_main.focus_exited.connect(on_focus_exited)
	viewport_main.mouse_entered.connect(on_mouse_entered)
	viewport_main.mouse_exited.connect(on_mouse_exited)
	
	# 初期化
	viewport_main.title = "Tango" # タイトル
	viewport_main.transparent = true # 透明化
	viewport_main.unresizable = true # サイズ変更禁止
	viewport_main.borderless = true # フレームを隠れる
	viewport_main.size = size # サイズ設定
	viewport_main.always_on_top = true # ピン留め
	
	viewport_main.set_transparent_background(true) # 透明設定
	viewport_main.set_initial_position(0) # ポジション設定
	
	# UI
	pannel_ground.size = size
	


func _process(delta):
	# フレーム移動
	if Input.is_action_just_pressed("MOUSE_BUTTON_LEFT"):
		temp_dir = DisplayServer.mouse_get_position() - viewport_main.get_position()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		viewport_main.set_position(DisplayServer.mouse_get_position() - temp_dir)
		
	return delta


# ファイルを得る
func on_files_dropped(files):

	if files.size() == 1:
		file_flag = true
		file_data.init(files)


	else:
		print("Just support one file.")


# フォーカスを得る	
func on_focus_entered():
	#print("focus_entered")
	pass

# フォーカスを失う
func on_focus_exited():
	#print("focus_exited")
	pass

# マウスを得る	
func on_mouse_entered():
	flag_mouse = true
	#print("mouse_entered")
	pass

# マウスを失う
func on_mouse_exited():
	flag_mouse = false
	#print("mouse_exited")


func _on_button_next_pressed():
	if file_flag: label_title.text = file_data.tag_serch()
	pass


func _on_button_exit_pressed():
	get_tree().quit() # プログラム終了
