extends Node2D

@onready var viewport_main = get_viewport()
@onready var pannel_ground = $Panel_Ground

var flag_mouse = true
var temp_dir
var size = Vector2i(500, 250)

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
	
	pass


func _process(delta):
	if Input.is_action_just_pressed("MOUSE_BUTTON_LEFT"):
		temp_dir = DisplayServer.mouse_get_position() - viewport_main.get_position()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):	
		viewport_main.set_position(DisplayServer.mouse_get_position() - temp_dir)
		
	return delta


# ファイルを得る
func on_files_dropped(files):
	#print("get file")
	pass

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
