extends Node2D

@onready var viewport_main = get_viewport()
@onready var pannel_ground = $Panel_Ground
@onready var label_title = $Panel_Ground/Label_Title
@onready var label_text = $Panel_Ground/Label_Text
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
	
	var parser = XMLParser.new()
	
	func init(files):
		path = files[0]
		type = files[0].get_extension()
		name = files[0].get_file()	
		file_access = FileAccess.open(files[0], FileAccess.READ)
		text = file_access.get_as_text()
		
		parser.open(path)
		
		
	func xml_parser():
		# init
		var pos = 0
		var in_main = false
		var in_div = 0
		
		var title : String = ""
		var text : String = ""
		
		# while
		while parser.read() != ERR_FILE_EOF:
			
			# NODE_ELEMENT
			if parser.get_node_type() == XMLParser.NODE_ELEMENT:
				## <main>
				if parser.get_node_name() == "main": in_main = true

				# <span>
				elif in_main && parser.get_node_name() == "span":
					if parser.get_named_attribute_value_safe("class") == "title":
						while parser.read() != ERR_FILE_EOF:
							if parser.get_node_type() == XMLParser.NODE_TEXT:
								title = parser.get_node_data()
								print("Title: " + parser.get_node_data())
								break
				
				## <div>
				elif parser.get_node_name() == "div": in_div += 1
					

			# NODE_ELEMENT_END
			elif parser.get_node_type() == XMLParser.NODE_ELEMENT_END:
				## <div>
				if parser.get_node_name() == "div": in_div -= 1
				
				## <main>
				if parser.get_node_name() == "main":
					in_main = false
					break
			
			
			# XMLParser.NODE_TEXT	
			elif parser.get_node_type() == XMLParser.NODE_TEXT:
				# in main && not in div
				if in_main && in_div == 0:
					text = text + parser.get_node_data()
					print("Text: " + parser.get_node_data())
		
		return [title, text]




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
	if file_flag:
		var array = []
		array = file_data.xml_parser()
		label_title.text = array[0]
		label_text.text = array[1]
	pass


func _on_button_exit_pressed():
	get_tree().quit() # プログラム終了
