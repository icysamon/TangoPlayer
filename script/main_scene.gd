extends Node2D

@onready var viewport_main = get_viewport()

# Called when the node enters the scene tree for the first time.
func _ready():
	# 信号
	viewport_main.files_dropped.connect(on_files_dropped)
	viewport_main.focus_entered.connect(on_focus_entered)
	viewport_main.focus_exited.connect(on_focus_exited)
	
	# 初期化
	viewport_main.title = "Tango" # タイトル
	viewport_main.transparent = true # 透明化
	viewport_main.unresizable = true # サイズ変更禁止
	viewport_main.borderless = true # フレームを隠れる
	viewport_main.size = Vector2i(500, 500) # サイズ設定
	
	viewport_main.set_transparent_background(true) 
	pass



func _process(delta):
	pass

# ファイルを得る
func on_files_dropped(files):
	print("get file")

# フォーカスを得る	
func on_focus_entered():
	print("focus_entered")

# フォーカスを失う
func on_focus_exited():
	print("focus_exited")
