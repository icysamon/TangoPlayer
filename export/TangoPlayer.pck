GDPC                                                                                          X   res://.godot/exported/133200997/export-53924df8e0ba501d0cdbcf3847bbfbf3-main_scene.scn          g      ��r��0�IZ3�(h}    T   res://.godot/exported/133200997/export-97fef84aea54af999ff5898c940d6ab5-theme1.res   #      �      �a�IR�8�%Y�c0    \   res://.godot/exported/133200997/export-ae4ef22a5e307f1cbeed5cf604474d4b-label_settings.res  �      �      P�E��%�偺.e˝�>    ,   res://.godot/global_script_class_cache.cfg   �             ��Р�8���8~$}P�    H   res://.godot/imported/Picture.png-177ae9801e24cff07ab70e34079dee29.ctex P5      ��      ��(i���e+4�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�'      �      �̛�*$q�*�́        res://.godot/uid_cache.bin   �            �q�Ы���C��=       res://Picture.png.import �      �       ��M��ĩF�Z��)t       res://icon.svg  @�      �      C��=U���^Qu��U3       res://icon.svg.import   �4      �       �u�ۢp{�Qv�v�]       res://project.binary �      �      ��;�|~�r���x    $   res://scene/main_scene.tscn.remap   ��      g       ۟L�W����s�r�       res://script/main_scene.gd  p      x      ��S@A���ʍ��y�    (   res://settings/label_settings.tres.remap@�      k       T���7�jՈ��]��        res://shader/background.gdshader�      �      2�XH:���I����p�       res://shader/button.gdshaderp!      �      ��v\�@�=c��t        res://theme/theme1.tres.remap   ��      c       a����E�cw�� �m    RSRC                    PackedScene            ��������                                            	      resource_local_to_scene    resource_name    shader    shader_parameter/color    shader_parameter/angle    script    shader_parameter/center    shader_parameter/r 	   _bundled       Script    res://script/main_scene.gd ��������   Shader !   res://shader/background.gdshader ��������   Theme    res://theme/theme1.tres ��3O~?r   Shader    res://shader/button.gdshader ��������   LabelSettings #   res://settings/label_settings.tres ��a��=�      local://ShaderMaterial_0ulqx          local://ShaderMaterial_y0xnw \         local://ShaderMaterial_en7wl �         local://ShaderMaterial_faqgf *         local://PackedScene_f4drk �         ShaderMaterial                      ��0?���>��/?  �?   )   �������?         ShaderMaterial                   
      ?   ?   )   �������?        �?д4>��>��H?         ShaderMaterial                   
      ?   ?   )   �������?      ��?  �?��*?��H?         ShaderMaterial                   
      ?   ?   )   �������?      �\?��>��#?��H?         PackedScene          	         names "       
   MainScene    script    Node2D    Panel_Ground 	   material    offset_right    offset_bottom    theme    Panel    Button_Exit    layout_mode    anchors_preset    anchor_left    anchor_right    offset_left    offset_top    grow_horizontal    Button    Button_Next    Label    text    horizontal_alignment    vertical_alignment    Button_Back    Label_Title    label_settings    Label_Text    autowrap_mode    _on_button_exit_pressed    pressed    _on_button_next_pressed    _on_button_back_pressed    	   variants    "                            �C     �C                             �?     4�     �@     ��     4B                    ��C    ��C      A     �@     B     B      R               <B      L     ��C     �B      TangoPlayer               `A     �B     �C     �C   ]   A dictionary made by Godot, you should drag a txt which converted from mdx into the program.             node_count    	         nodes     �   ��������       ����                            ����                                         	   ����
         
                                 	      
                                ����         
               	                                ����   
                                                                 ����         
               	                                ����   
                                                                 ����   
                                                           ����   
                                        !             conn_count             conns                                                                                      node_paths              editable_instances              version             RSRC         extends Node2D

@onready var viewport_main = get_viewport()
@onready var pannel_ground = $Panel_Ground
@onready var label_title = $Panel_Ground/Label_Title
@onready var label_text = $Panel_Ground/Label_Text
var flag_mouse = true
var temp_dir = 0
var size = Vector2i(500, 300)
var file_data = FileData.new()
var file_flag : bool

var inf_list : Array
var inf_num : int = 0
var inf_last : int = 0

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
		var in_main = false
		var span_title = false
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
						span_title = true

				
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
				if in_main && !span_title && in_div == 0:
					text = text + parser.get_node_data()
					
				elif in_main && span_title:
					title = parser.get_node_data()
					span_title = false
					
		
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
		if file_data.type == "txt": _on_button_next_pressed()


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
	if file_flag && file_data.type == "txt":
		if inf_num == inf_last:
			# Get information from FileData
			var inf_get = []
			inf_get = file_data.xml_parser()
			
			# Set Label
			if inf_get != ["",""]:
				label_title.text = inf_get[0]
				label_text.text = inf_get[1]
				
				# Save data
				inf_last += 1
				inf_num = inf_last # last pos
				
				inf_list.resize(inf_last + 1)
				inf_list[inf_last] = inf_get # not use 0 idx
				
				
				


		elif inf_num != inf_last:
			inf_num += 1
			label_title.text = inf_list[inf_num][0]
			label_text.text = inf_list[inf_num][1]
		
		
	pass


func _on_button_exit_pressed():
	get_tree().quit() # プログラム終了


func _on_button_back_pressed():
	if inf_num > 1:
		inf_num -= 1
		label_title.text = inf_list[inf_num][0]
		label_text.text = inf_list[inf_num][1]
	
	pass # Replace with function body.
        RSRC                    LabelSettings            ��������                                                  resource_local_to_scene    resource_name    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset    script           local://LabelSettings_cfqeu d         LabelSettings                    RSRC              shader_type canvas_item;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float angle = 0.1;

void fragment() {
	// Place fragment code here.
	COLOR = texture(TEXTURE, UV);
	//COLOR = color;
	COLOR = vec4(sin(TIME)/2.0,0.8,1.0,0.9);
	
	
	
	// Angle

//	if(UV.x < angle){
//		if(UV.y < angle || UV.y > 1.0 - angle){
//			COLOR.a = 0.0;
//		}
//	}
//	if(UV.x > 1.0 - angle){
//		if(UV.y < angle || UV.y > 1.0 - angle){
//			COLOR.a = 0.0;
//		}
//	}

}
       shader_type canvas_item;

#define diagonal(X, Y) pow(X, 2) + pow(Y, 2)

uniform vec2 center = vec2(0.5, 0.5);
uniform float r = 0.4;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	// Place fragment code here.
	COLOR = texture(TEXTURE, UV);
	if(diagonal(abs(center.x - UV.x), abs(center.y - UV.y)) < pow(r, 2)) COLOR = color;
    else COLOR.a = 0.0;
}
              RSRC                    Theme            ��������                                            #      resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script    default_base_scale    default_font    default_font_size    Button/styles/normal    Panel/styles/panel           local://StyleBoxFlat_7gkl7 �         local://StyleBoxFlat_vhbpl �         local://Theme_ldxdp a         StyleBoxFlat          	��>��T?��J?��!?         StyleBoxFlat              ���>�� >���>        �?  �?  �?                      �� ?         Theme    !             "                  RSRC     GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bnryv2dni0xci"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                GST2     I     ����               I       r�  RIFFj�  WEBPVP8L^�  /
� �(j�H�d��x�]���0����y���;.tiS,��p8.�g���S泙q��a���&�x�s��1�qI�b��1���_!����S G�mU���pn��Ǳ���[�8�$YVR "V���>�S��+l۶�ҽ{�U�Xv����sB"' ���{s�w��{N�s���ؗ�Q�m;�i���F���q��S��Uq��ӷ ��� (�G�||#Ŵto���� Q�{�Ʋ� mj������d���{5���_�X7��	�u�ۆ��˾W��?8��G�����U�e��3���x)ܫ���"""A<�cD����'v���='_݃�mIJʟ�|{� "&�PmYkqߑ��՝m ׄ^�	8�������`��y�W`Pc�e����ذm[�����%	-���5{�t���?wwwwwww�_������q�4�!y���ә�xg�U�ڶ-������Y���Y豇����q��7`X�l���&��Y�P�'۶U۶$����=�	33K�^Hr!A)�|H$(�`fff�����}�#$�m$I#b���r�s�4���ZJ�}N�}�����@�E��5Yc�%q7=Fc�	£I�5y�M�]wc]cK�b�Ja�2�>��s�����s���d��¶��$��y��DFD�*�c��sٶm۶m�{v�.۶m���B:���ݶmӶ�M��>����g�mۺ�W��v��/۶���}�^�נ(I���LB��ڳ����0P�?Mi���f$�$#u0���6�V!�(㉚�tji5�K'4��TJ�C��@6R9�f�29Js(a�����(�+
�b	9���t�efN^�a�.Y����6E�m�z��8��b0���6ƍm�qC��$�%f����sV+3���rlۮ�f̍>�!�Sz���(��wwI��6�@�P��:�\��>._�JB��ΐ��# �T��&�Iy ���W+�xj�.Q��\���V����]1bՕ U�˫;�9F (j�4oG�1�"�-  �.e� �v�u �S�:m���L���Ee�%[V,���T�آ)�4�h�c����K�"A �J� �-%Y�XZ9��2��%���Ng�.
��Q�
�vx@�!���tUuZ <v�U:��;_␵WQ��t[������a(eW�r��z�n���DjV� ����n����k����;�n��(�ғ%��bQK�P��t��rk;m XUN[=4[/�����c4�,��JY'Vy�7��u��-rF�Jڐsx� j� �~�{p��A ��c{���n�(8�r�����E�3l�kB�;�P�@@$ 	 �{� �V��H(�VRz�����Y�V�7G�x�5 hf9tx|;(�7�:E3 J�@�#@jri�Jv��!�<�t����:i�$��4;K��ĳF��v�h�M�Y���z]��y;�N�X�� ��O�M��o[��y�ç�߬������q��qb���8r͐2�:�k^��l�ˏ; �����X}qU���œ�'��ϐ��# �T��&�Iyæ���d�||���䨍�DEs5�ZZm�[ vňUW^T Ti�.������3���d��οLߛk��[k��V������XRV��o��1�����s�aIy���/]��ի_@��8o���h��Ȏ_	Z��~�E�O���wZ���+�.��2���?�������\��"�Λ��~��c���ϴ�l�`<  ດ5`��pA� n9����v��iW�Xˠ�ؒ-
+��FW*Vl�UF �B�v�$`�3����3�<��V��Uޠ̻�O����[�s��Owo��
;�����"��˽s�;)�u�<��K�Š,�I���O��/��G.`����1/����mNO_2ِ�� a�V*����� 	_�x�˃���-,���[��X�t��0�խ �߷)[��3?s`z���ə����t��]e��J`�C�<86NΪ���3^o}v���u��+�:g��ݲ��m0.�f�/����ms������q�н�?�����O\ ������������?�
%�Z���W~K~5�w���<{e�/��_+2 ��Yy�K(h�۶���u-��y��'$�ӴK ½��)�`�g]3�3����{��Ҁ���Lo ��g{6ԁ���x`lo�*��'?\�Z������Go������[̬�PdH�� �/]U���  6�w�`��WQ��t[������a(eW�r��z�n�by��'-���A�Vs⊭?�#�}���W�9��@��*;/b���ۧ���W"�����ܳ�sO'��4,�w�i����j�7�����眻2&�g�=�s�?���k3)�	���#��{\U��h�}�o�G��� ��o
���	>�ο�����P='���[��,����NSr�r�������y��}]��,�[z�vٖ���jA���O�f�4�sR2'fdON7�u{�&��.�B���������D��b7�6T�Hͪ�� �Yv���v���+Yr ,+�d�� �n�% �$$�����Vc}r����-�O�$��<G�t�E�U?�D��uWk�X��
Ԥ��Ld�N[21'qUѦM�Bmqpq��e����7l������}��<Ϻ���} �MR$��\���@S�����sN�]��g��́Һ�ƽ +۰դ}]��猶6Y�k��O�y�z��O=���o��zK�jg}p��o�����oq9������ױ8����F�AŉU�Fѳn�Q��"g�Z0�� t ց )�RI]��'f���w�%m9A"h�dw���pÿ x�L {��s��o�*�ͻ�R��U��
����������ɏ��]�_���V��>��GB4JR$:��/q��@��h@
z/l�%�̕1n�<�65��޼|/��W�߸�����.�G�Dξ������_����"_�1������c��  ����du�E���jGθ��(r��/!�4M�s`br������T41;+QE8+p��B�+`���o&|��N���~/���?��v��������Y}�7��[>��;$�V�е����A�{��[-��]��tπ�Nk_��F/�z�JF�~1��w��ş�
�w����Yw�XZ{��	/G5��k���k��Z�h�:z�Ϥ�T %tSl��-���\���t�X�D  ��8[W�ڛ�}&=���޾ubO����Ǌ_T}�K�3/�Zi�ؘ�������O�3�F"���т�3'"��������o�[�ҜUhy�������_�7�s��o�Ώ~X��~���9��H�0 ��gB*��>fI�����ơ �i�\����^ HJ��xo���mJFg��߿���:��?���L���_�-��;��s�?��_���_&����]��G.'��ߖ^��"e�lZ{�X���N�x�^���-#��ҫ m�f��m �oc�H���[�w��'oWm�n���2�( x~\�N{eў��j.�
"���<��W�V�hٯ������Z^�{�n"I�{��Hǳ�E�E�� ��~ͽ��f�3���_�3�+��_����o��~��p���n�g�{{����G?�S x���W_��+��t����x�5���vZɱo��u�4�-�g�sE�;6�niS���d�m]��X������y�>V��+7��n�����������+��o��"�L����+Wob���/�o��/�( �ş�Y��l��������y r�j�u��/���ӭ
��i �'O�7xY{�<��{>���s�������ȯ���I&/��qg<�����;�<@��<���VO@|m�˟_��'���?{���������+��).|��VhL���r�<px�  �����S��<�b����o�<���~�헷.�>��!�Y8�~]{����w������V7��Yڞ���|����H����⯬�l�_	���� �/�������������o~:�����o_�}��c���ǂ���=�ڛ���V������>�b�M>n�-��>X���
��̋u�����61vu�K_}B�Լ���l�7��Z���2%q��	���ܢx�Z�1�Y<�qg��GB��\��~�MT��Eve��cQ����js-���0@�����s^����[k��V������XRV��o��1��J䟰�s͇ZC\�wlh<?}���u�g ����<?Z[ռ�����伵ǧ+�3��W��ﮟ�����L�/��fe=��*0�_^���6+��l���^J�v��Z[�m����]�>~|W�W�!���_~1��<��r�ҵ:= ���`Vf4�l���O��c���p�%�3�v��X�é,���Neڍ.��p�Mi2x%�yP;sYھ;[��ɩauܼQ�U6���������x<9ǰ:n��;;���6�IO_���I���u�h�J�􁤳`��|V��1��G���ɳ�`/�ո�yU}�@�bߥ̏_�@��V}@A�kj���}����n��z��h�k���쾰�N;�J�Uu��ح��9��U�o��,m�� L�ss79�\ݞ�nЂ`�����%%���89�N��x���}�[��f���ʼsho� `�l���!Y8y�ZOA��$GY�a��=(4>q��8��8?a��������������U��m��t]pvn=����v	@��;K@�`���(k�F������Ȫr:���i���dd2Ӎ�Q��E���I��1+���q�[@cF6��X�dd�� ����v��3W^�d���m�R0��?	�c�lj@czLL��C�TN��f�n+��:������� ��v0����{�R�蜼� ,���^���ڢ�>@���-�y���;���l.������;��n�̈[�`�����8�t۪�P��rb�l�Tvzp��種��e��.\\P�M[͉+��t�����7�^����}ګ켈��{o��jtO_�XJ�ۣs���=�� ���ۜ8.��6�r��d�zǻ;����ɝ�^��^[���ş�>�/�A�c��Z87��y���g�Nt�ꯧ�]�����[���ɗas
>���}�ݫ[����F'�NSr�r�������y��}]��,��q��W�;���;k #�K��ߧ��Ƿ��6�%%�IG�jN�o��A��G�k־n|��u"�莍�ۜ����M�<;i�Ö�'P���Ϭx����`�O�I�X[2�3'f����
`�ۮF����	�� ��;��zޜT� �c��&�Ԧk�22S��
`��f~n2�S�X���c�(�r�%��bQK�P��,6 pIH[AS�����9Z�[��l-HH�y���h�Z��~
`�ة����=�lp��:ktO��u��ƒק�J{l ��)@�zn=�ȴX+EHy/]~���RK�^��J	4�9�;��ٵ[�c�ژ������� &�;����&��'Uz�K�:��*9�:���	��.�UI`{sD	8�w�����u�7 un�d�暿�280V7�>osm�K���, ��zgn̊U�b�H6���F�X�pC�l���G��� �����6%��>l[�w���!����uPAqb�F�Q���p(��9��8  �u HJ�TR����Y���fI[I��H4 U�'W��'g���7 �N�X�]��f�ٓ|�@���Q֞k�ظu]���Ι��2KN^½�L��7
"���a �Ak�dY��f�n.���=--�Qrx�-�o� @ �����:���ܳ?\�Ut@�(�}�Tk)���U)�.�W���;� ���Ò,�C�G�Q0R4��_B�h�������u5gwVt�+�~=���쥪�C�BM��u���m=*�1P�TwD,m�skS �v4�O��Z���nrB��Iue�8���PN{�^�=�N����6&��t}���: ` (�@@����)&���$�$���_~�]*ܑu+����>����p �$��� 2խ��4��g������}�����E��5��N�5�w-s4L��gRl*��)�M���M.�}r�G�N" de��+e��f>[*���1�h:��S�s��oN֫ӉN �>0[$��1�1���I�cz�r�fͬ�h�1�8�)S�3s�cQz�DH
DHwP��$��I�-y���$�	k��g�hj��^��t���&.N���� ��&]�x%�N��gUk#�á���a ��caL�%�m��Q�Q3�[��e��8K�ǯv^�׾W�G{'�V' ���	Lq;$I���!Ge�$ݱn�lZ{�X���N�x�^���-#��ҫ m�f��m �oc�H���[�w��'oWm�n���2�( x~\�N{e��Eۭ5����γ�*����B}G=9�"W�=��L@�^{֖:�utE��^��������T:G��k W������6��s n^���<��-��yqbQz�ȥ��eSI9Z�]N�5{;uM@���^#i�U��gŘ_[���&%�z�XV6h����S3�>�8�%X6feg��ij:Dab�� �/���3�SsO���+k�,]Ҭ�2����y�T���I��a�iצK���Y�,� '��[���b�>��8ݪ o���  x�$�x���7��	��O~(��q�~<W�O�]��G�_�OW���o� ���m�;oU�x��]���xN����Ƴ��z��g���jL���r�<Ӡ:�����f��6Q�:_2��,����ze`��	�d]�-��)�<��\��r啘^y�-��\�xv͕�s=���W&��&m�q�f+����-�|Z8π�%�K��UeU�c O��i����HnY��J�)���t��{�����Ss)���<`IuxmR��7����;�������F]"��\���V����]1bՕ U�|,PWy�h6�F�1�"�-  �.e� �v�u ���^�鴒�+��zg�ᠲU"��bK�(�X&]9�X�ES4�Ɉ�;�ۜ��d.�!Q$��Tx�J��f@�;����G9���ijC��qKP���p]f�;�� ��(2$Uy ܗ��N��W �A����oM�38d�m�T���g���]�1����
��+H�f��z;�b�����ݾ���+Yr ,+�d�� �.�%�[�i�Y��{boD�C�q��qO"�a?��!����uPAqb��|��Y��(Pr�3rF��!���% @��ʾ���o��4~ڑ�+mdu�E���kGθ��(r��/!�� T$	H���ǃ�H����%(/�H����	k@��r���Π�y�S4�dd<��&�֯�{�W�-�ҩV���4;K��ĳF��v�h�����ҫhm��u��� ~��r��]2����HS��wê6�z $e���uWč�'Xj�.�Hc��\K�Muc�����ʋ
��Y>��<� P4��f��V���  9��k֢μ,+�&��~Vxӥ%�W>�u�k*[�!X�,�d�e�ѕ��[4ES��h�c����K�"�BQ��C��-i��ŵө�4W�[N��4�!���%���Ng�.
���U��k�P֎ݱhM�@�D���nu�s~��p�j�5����M�uKPQ
N���Rve,Ǩz��*(o��5ND�ˡ=mWz� �(٣��cD �ĊE� ˊE-Yf,@�K��9˛Q�����. >��#�#R���,��JY'Vy�7��u�%9#g�j?	ը�f��tƭ-�W�	 `��pl��iGZV���Ս'V�Q9�R��h�����;�P�@@$ �~��K�.-[�59Щ�,q��'��[_���v� G�x�5 hf9tx|g���)�P22����-ǂ6&�\ez��¾M�~����?��ѩV���4;K��ĳF��v�h�����ҫhm��u��.���=!7�w�%CJ;<��s�j׶�V�����f�b�o#��L�%i�՘ki��nlQ �#V]yQP5��u�� �f�l��*�ق�  �!g9~��Zԙ�e���T��*����[pfn�F����bK�(�X&]9�X�ES4�Ɉ�;�ۜ��d.��.�~>tiݒ�ٝJ�xu��,��j�v`/�(�㖠*V;��(��wTWA:�Pd@5X;vǢ5)��V��)k�����n	*J��ճ�Pʮ��U�Q]���Ɖ({9���J�� 0�ю�Z.%V.�� XV,j�2c
P]�o��YތڌV�p�ܘ�F��CTUi#렂��*O�Fѳn�Q��"g�Z�'����θ���j��B  �rl���Ս'V�Q9�R��h�����;�P�@@$ �~��K�.-[�59$�	q*ab���q���	k@��r���Π�y�S4�dd<�1oE[�mL4���(Ol ��}��[{�/C�mE*��4;��j'��0b���D�m����^E3h����7�t@�fk�# ��޾\I�S��jɐ��#YL�k[���P����\��.k��[��i�l�x  ���`-��˲�j�.[R�U��P��cF4�v��ӗ�Eޅ��χ.�[�6��#��
�x_����9<�Ȁj�v�EkR-�b�������R���8e/���]�[  ����t���5r�7�6����-\4 DtW�1��%T�R������^�p<��Ӧ����"��H@�ja�X]0Z�:kr`n��s���EӳN���9��Ǽm9�1��*#ˢ�C�d|�q�q����(r��� �{�JB���TK��vx`�b�]��nXՆZ,�������gZE6[0 �0�,ǯ5X�:󲬴���80�e�=��ۜ��d.��.�~>tiݒ�ٝ����]��ET��cw,Z�"�h v���L��k����C{ڮ��-d��]j�5Oi~j�,oFmF�+[�h �����77�K��~��O���,����θ���*��\�}��n��_W*�$ѯv���e��&D��g�W��ܛ�P4=�� (��z�[іcAM�2M����J�Kjw�^�p��P~7Kϲ����X��{�V��.���|7k�y0�U�V�[�	�_ؗ��)+�w����V���������=>����q'�۔��op���Ҍ�)�~给�ezu��.�י����z�m"����I�/$=��˗��L�L��)���<��T���ݰ��ޤM��ŀ�v<Տg�Hc��\K�Muc������=s��������2\�\��"T3�$K�� Z'�x ��J%���\	fɩ%���D�YǦ����0��U��b�������|O?/?mZE6[0 �0�,ǯ5X�:󲬴 �G���Bˤ� �(%��=S;��Xˠ�ؒ-��	��f��ρ.���!D (.��C��F�K& ���|oK�����%��E�u{Q�����{NO7/C�nsz����»P���ХuK�fw H�9�\�۴7��w2D�z���6��^�=̙��$���%�ʖװ����--�U�D��e5ʵǓ���2��H ���u:"ɔ� (3B���h]&���u3B$
�#_>ˋt)Q�K)�?B��{� T��}Vc�g-}U
@+��P�ƛ�U�>�6�Βy@���p6�b	�	���� ���#��m��M]_������ET��cw,Z�"�h�.�i�anwݫ�=&�I�ެ��i{�NŚ���v��;�C6��-AEN/8h�~�ӗ��ԃ�Jf,���\/Y��& ��� �)H���˂���<�D����.)��#]��@&�R��yq����ɇ��TE��T$t�4,E�p��Ḳ]���K_�������c��#�����(9��h#y�$��1�3��\�?�6�?�ܓ?��{��-}���k����+{ï�Ô�V'���О�+�r�A��իq)���K\̙��������-YY�ƙ�9PPb�'K�b^��4�e	v�W9���_��|����FM���)�b'��P�D��K��U��l4�Dv��$Z��LeR��~+�jJ��b�}c�c���{��PPZa�������8�9$wT��+�����/�M'����������?��?7u��Ij�,oFmF�+[�h6m6���Q@w���r6g�jM�� T;����,��JYk��&� Hզe�`PɞK K��J��	h]E˓"`�$2䊤�ߣ��HA�g�}���Bwч��y���{&������~_s�8��v��}�J�F�6�3nm)��e�	�1�G���ѺO����Ņi�wi9�G���ƋKx�~S�Oβ��|~s��"�JR�,"�Nyc��4t��g��}��˞���wҗ��[����@��a�博�����	BE��$���.��`�lu��@Y
 �^�q=UW��9��T
����4^:� �����d���>�H\ ��>B+ �rv�Б�©���a�P� !�*!1&$@i3m���8�P��}d�΃���t���������k�a{�_���|o
�7������[�� (��z�[іcAM�2n �� 8�ԙ�i���vo��x��fgi���x�z�A�f��_-�dM�di���,�.$�M@K��-B�� �;�J��ٕ'�ٕ�,!2i�ʩ	m�P��6'�^ݩy=�<I�(�$� 2g X��U�8��E
�Ǆo}m���u ���h��PA�ߍ�h��S�p��MU����|�%������� 2   �����2�y�l�]�*�ń �Ȗtٕ �� @��y��2�Rr�������)Ȟ+��.�o����yrG �A�:���5w��I^ǻ�\y �����u����ɂ���fh�|ś/�jҗ�����2 ��w��7�)�^����'�o�w���������,�]�?�Ŀ7��Ѿ,������bK�������������Z�C��45�ZO�iv
�����Z���wo�O|ѵ�7��J}�1�_h��(x�K��(,�^����֭aO��=#bj�Њ��OO���W�g�����o"���|��n�|��[+\��@A�M�����S$�X�r����sb{���<�ٜ�����~������?z��#_�%���_�������������q��g��ՙ_�M}8ҥ=MJ�Ϫ�6�@��Y�go������2 ������~�⻬,�$�����]�O3���\P��{>sv�V�
B+�@�
�o��F���:Uf:έ�0��Z'�t����<���eD�o�\[2o��G� ��T���ޢ��M��5O=��O��:��^}n���~�W�^×r}�;�J6�ҝSJfy#�M꓏���lzVv�9H72�~a���1����HS��wê6�z ���>���e�O��Y(Ҙ�1��jS�آ �륩f��2J ��u�UpѦ����^�ɬC���w��/ '���f��� p*�N`��������W Z�:"1���i��:��BW^
�Z�E`g�^���ehL��f� �����kQg^��V#��� x�{���d�Ԏ'!V,*�-٢���P��$S�9�7����FjA��`�i���?避m����!E�S�@�D#�.?U$P�[�v��֓�K�Q��`u���s,� t��uG^Zꋪnd6� :t����L?.?��ۜ��d.��.�~>tiݒ��]��$ ��8�K��9S;�Dq8�U���Z����ڿ��fo����$S �pP~GRӛM|h���D�
	TG�|�3�R��q,��N�/^���i�H�4�v�=' �2����n��)�����|/�&�����'�;^������3Pd@5X;vǢ5)��+v�V�1��/��"���zgpȦۺ%���'�aE\���n����+��"	Y0���:�p�A2�"L�,��0pPd���G��a�S%���Z�2��K���@\��U�9򉿠���e[ P�a�/mo�� �%/��z7�9�q�z�Q�rhOە^���1��<3$�~�C�,+ 
J�Xd�����.�m�����)���k'��P���b�+�Qz�2$	H�]��)��ק��*Yw�i� �g�*= �zzU&Z�.mn*?�vX/8Ң�-�w�,��[�ֻ�\���t�ȸ�k����:O�����3����W���^5o13qQU����
��c3	�R��v��/_�]$ � d�R�Ȁ��pa���@ܨ���22�l
0՝�  �k��1qϞ\Jz��~����"s�Q�����6恽��w���c6w\~~u{�]+.@���x����?Mn@k���?��[҆6~���$�/J�0w�E��$C3 ���zNQ&7���<k)���� ИM�  �j��6�E&�O=�+�4���-+{��ˎ������`�cf�����ɊK0�?��]���������DZ'n���rT�(X��J�� 4�r��a����H���e�@3R:V����4M |��s�� ���ɇ�_��&;�' 0�w��Ok�9�?����z����7F����^zh;z��~��=���O�N�J��f��+�}��|�i�g�� d-��tULV� :�ʒ�-/F�
�����ȯSd?�`K��]iF��2�� :�O{* 	)n�}Z�|�� ˯xཫ���̘�r�- �+QE��g�\�]Ld$�ؔ,WH���LA�`5B D���Ǟ��M
v;&eő����R��a���Α������ �������J��j��%MΝ +<���Ƭâ )��-~��R�m(��3)n�).�=� 1�Ȫ焿��u��G$���fh�~�)|�^i�K�%�R��'#ܥ��1k�=ҭ��Ш�����z��p=�����[�����3��?�n��[�cn���q�@���C̬�}��?��(  )  o�S0-���,�� �������9 0v ���)����-5������}C+�G�ُH`���뭐��ls���]o:��X��n���9O�M4Fli���wz�$�}�uzҎ��h4X�j�;R�K���]�j<���[�7�&��j6;+z��0�U�DbW�X�''9 ��}�<o��π��D��G����Ce|����se���.0�3�������J����E��+���B�"��_�r(/G����k���b0��d��
  �9��wlj�ۀ�Ӕ�C\+{a��ڜ��VV��� �95���6Ս�Hc.��,��0�(�����y���	� $i�E)��i�B��ȔZ�t�NRUB�%Q.fI���$�r��i��T���P���ɟ/�$
��:6sA͌zIq����%�K���L��&�	`X�Q�	cd�	�*`
�˰��5/�U�V�� ���~�-=5vt>W�c� ��_�zX�gfv�(i9��,���C!�Tj�d8��ҥ��#��r���R��˗@�38��R*#H�r�� �"t��'!.��.]�2�!"�b�*-��\g�ZQuhkO}.�d{��Wz%�D�I�F`i�g{�^�v8�t*�2TՍ�j��l�� ��wZ�t �0qȔ 4B������#�� ���u"m\$`1�+�y�$�i��2��EZw@���hM���"Wr�W@��~+�u�V��&�4��ռb>  �"�Q�����E�� �=����T�e.ko
4��<��;�%� �;��+�b����$� ���&>4��X/�NY_evb��t�Ҩ�x"��&��ޤ�B*�07�Ypu<S�(�L�+��pMJZ��w]��,Hk�,7-ǬOؽ�!��D�3·���VM�����M�D}"���H�HB�t�]*�YJ �"�|��ac	RӛH�yb�^Q �Xb"�r7Փ��)?�$Q^t=�B�i�[� ��U�%^Tկ�.d���]B7���;�.�� կ��e/�����њ���UH<�[��4���=
X�Y �>�L#t�LE%'��H�ꒉS��Pl�Qˇ{ב$K�*�fB�Yɣ:�=-DU�QmY�ɩ����g�frt<j1���D+n59������le����w�_���^�����2J��d�����,�'��d�E� ;y� ��i(��ٕ�G�F�dx�2���)ȣ�'�W
t ]A�wI=�u6��ؓ|:���y��2�*��X�g��V�JK^�*�؀��ϓ�Lt��!]�mR^�] �d�!�R��(;@A(

X�2 �ꎏ��z>:$�1���}:z�Y[O��N����!fF#��!����uPAq�@(���'�N� ��� H($�a>ZT% �rz�}�+��(�, �)5��\5}���e�,WA��@������{������� � $�$�,��A�> �U�(7�vd�9�[�ǟ	 ��۹�!iC?�c{X��{�!���@�lr�!<� `��cd�xR:���~=BR�]�c�7�}g�W7m�J	!�����	h��Ġ��Z�U����CRjl�푈�[o[���]�H�	��ɬehe��9���Q͢`�RR�G!,�B�V�����Gt ��"�� ���i@)��eE1��
��h�(V�DGKyF$P�Ǭ�6ٹVeH>:�zW����;ζ���1�B7��'�q� �o"6�����@��u��Mf�Pz�������7�btN�lb�9�6k�EJkfVU'�:8g}���K���3}}V���gs����������i[I���0r%�����"-���-�f-Ғ�ѐ��9��H2	@�BQ���: ��.jZ'�D�d+d"I��3������
��'�r�4Q�2�MKY( �Hܙ�-U�4q����Ǭ���F�yJ�+�/#֠�U�c
�d�T��q}�D��M�w(�O��Jd%l�H���v�x�Ωz'�\��n�ۯzP�A2��F����=
aV�*J^�]+����y�V}m��k�������Q��樂J��"[޿��p/� ��\{k� ������"; (����x2Ry�-g�[`F,���؛�� й\��A$s�7 �õ��x:�����@���(�����b" )���\o:��V�~.�] ����^r�GRi��;L?  ���*�߅�;ě�������D�	�R�w�8f���P����;���[���ir� ��{+���w@��	�A��c��3��,��)~��~�sO59W"A�l��{t����{�ke/̗�Z��������������	op��8jS݈�4�j�ňe����h�����>�Zg[�4�~��y�S
�G�����쳦.�P�f�gQ��C��җ)����ٔ'���&��B�{ƾ�uJ��a���y�\�[��%�a�F-V��֗�E�1�:+I� ��_<���Xqk^>�b�N� &���T[zj��|���n�=��~ lo{�C�33�FkT[��SDԜ��^B�-UB�Z�iH��|���Ԥ�(����{q0
<2E�D;OB��S�Y�2H�
\撻n�� XuuhkO}.�d{��Wz%�A���8@C��ah�g{�2��%���0�RN����Y�<�X H·1O�M�X@��-s'� {��IR�z ѷ�=@������\�Ub��A�622�w�+� ���#��#Q���~��� �?$pmXG�g�I�wɟ's9��!W�O�����d.��S��]����� Қ�7���GZ及��J�zQ�Ò�$ L���H�� %6 ����Nt�.�P 	
���:�dJ U�+�F�������S0/��
��j�פ���y���ς��@� ���3�A6{�zg�ru[��'�����;��(u�5t��}
�q��%t+t��U x�?�6"7�?&��{Q���M<;b(�?0�$�IBw	�J_�������8��%�@�B�E���Y���ݕ���B�O��2�! ���>���-UoT�]�y��35���c������+=�7�~�$�,�ګ����r%��S!s���(p� #yEUb�M�f�	)T�d/�?���)�G (���D� N���`��2�@��BT��|�#ؑ@���dJ�etI��,���4Ѱd:Y�\�ۀU���c�y|�H����ee�1�����k��(�r�%���Gc.��uk�-�|ا<�A�
���;��o�4�g���<3<f���l�Kߩe�Qt�QPo��N��ؽΎ�	��.%Y���J�� FWz4�Ɇo7��h�!�����R6ݞ���>����"���3ȍ��L=��"Bo �$$�[bɝ�Е�zϳJY�rePTYY`%@�a yI$��
�V�	XI� �((`�/��s�|tH�c����t�Lq;{��8����F�A�0,	�R*���9�[�$��:��eЛc���O����4�v����ڳG�U�"�N.�㘧Yg�W��S�S�j&f���u|[�o$�8��e?�|<�7),%2ou��?����c��y:�1�s~ӏ�nc.��K����ȕaǫɞ�\SNaMw�v��cUq)��UÒ�����P7��ȐȠ$@�O�`	���A�C'K"CV�ا�Qn��Ȱs�	�������}X�m�8��6����`@!�T�S��[`������e���	��>ȝ�tv֞N�&�k�~o�і��f�)��k��5e��>(�p� X�]{Jr��8�qd��OSX��	�<�EK<s"�s�>g�����w����8к��|���wG�{f~���l�S�c�n4>�,�)0SGF�Jh�o���: �����pHJ���=�q�m� �svK+���4^:�`�R
Y��9"�l�l��8��j�V|]�I<jyx�/��\8$��g5}s@^@���@d �;%�����癲��k��n���F/��A�i�ӧ��F��cOw�Rp�c��()��d.�����Y��I^@���uCk�t6����f�v�.��Ӿ����?oa)�fEO���M4��w�����N�h @l1Nc��0I궶�p/�s�6���'���䉥 `w�D
@T$`�@Q@ ��a媔�A�j�Y���Y*��ZƊ��|Vg ����|��}���*��l�)��L$,���ĭ�N��|�v���o��,-$1bq����f�f��	��bO���0}���w�u�*tG��&O�v'����H�����&����-g��,���ߢ������*���e���ʻ�]S����ޤ��o��jO9�q��Ws��$��ud5f���6�s������X�G���.���Û����q�'g����Vov?&sHU��~c-��$��ȝ�:���I�b�/e�sR�V�i�b&W�*�]D��:�<%q�����������J��Z{5� 4+��%m7	Լ$���R���M��(zP�A2q*O�ӑaI>(�ᮦ����Y�U0�&�<VU�p�\�y�nf�j�~x�U_�/��7���)��5m��gT���$�k�-}D mO�{ =Mg ���|ti�c�T�,�Z��]�	DV�{;��iԠ��t� �{;'`��U ����X��id$�9��9�RV�d��ϗ��5k�)-.�[�h��R�븖b%}/�2�:��6�x����  ������K ���H ��q���}�s���@��  $
�cUB<Nyj�)|έ�JJA���(���$W��
m�L��r $�i|���s���=�[��c���J(I����
UIǞ�<�{ӣ5gO��9Kkv���̾�y2��@o�K �XU=zR�4�����l��'�G[�j��lo���,�cוgt�\ʴ���@ɥ�5�k0P#�}��*� ��1`�k �����T�z��@�t{;>;0��-}vO���llr;�ө��]�{H��s���u��Y�����.0���~�I�����gp�2�6�UHM6�)J�����ə��}8M5ʨ^��(X�V'���7k�~����]?U:ҿ��r)��X���K9(wP�2�&��TpI'��*�E���Ɏ�V�3)�c�;�$*�)���6�@H�O�H�2�"0��VE9`P��0�/S��Rv�Х�#`�^�P�l��8Ğu�V�_^˧R��۳�t�5Gb9oa��Qzmr�b�q��c��H���6��[z%>�$��<m�FD����ԄƎ	@���N��ߎ<frpn_�=��`��$��p���t4V�_޹��wc���x3�KI����d$'ޥ��̳vΤl�&9��d]9u�?I�ۧ�z��ɘe�J_;�g�|6�k$ٜ�Is�*�[{J[3�	��$����JFjT6������K�]K4iW[��u$���];P���|)���*���]JK��vx6&��Q,e�L��y�5��Gs�5�ޠm �Ν���>����k�j�OO�V� Xߖ�������[׺��ω��F6���Lxȕ��Ll��S�_`�M�y���:s��#,��nDEs5�bĲE`�x4�G��ַy��g� ���k~�e���k�qȝu��w�+��D��a7����fh���5�Xˠ��RԺ��.��*��}�[�=�z窂��4�����k���l9,���_�����j���e��qKP�-B�z�*����e���U�z�y7j����O�����W.x�a���%����m�T���/<�_���k8����^ �<�<�����j���X��XF���,9 V�Nd����?ʆ�w��'^Xa�K^o���:���'_�v�+fF#��!����uPA4���X�pz���4�ƃg�_�� 6��%�����iC?�c{���n�(�Zzc4�k�������}�O/4�;�&+.��3'�����g���o�>���8qs��N�(�����Ɯ����{i=���r�#NRˊK/=�q�s޸��E��l�{0t�V�6;���ډgo�5o�g�8Pć��=!7�w�%CJ;<0�d1ծmq7�jC��}��}�vׇXj�uD"��s-�6Ս-
 ��1�,�*�ق�  �!g9~��Zԙ�e��$���k7�VR����������V��*�-E�k�����%s��w����K떴��V�F�̀:��?�����l{�Eq8�U��vx@��`���֤4Z@%�2 �=����|?���nQ��t[��н�8e/���]�[�z;�b���<��79� ��]~,���O� �{G���ͨ�hp`e�Y��{boD�C>����h��CTUi#렂Ҽ�Q�̀A�[[J�@��ʾôR!  i9�G���Ƌ��%	D��W���Ѳ�Y� �`��n ��q��4^:� ��u�f �́�G=�h˱���&Wɾ{�W�-�N�ꒊ5;���:m;��5��YyC�NX���=!7�w�%CJ;<0�dqe롫��ݫv $e���uWč�GYj�uD"��sii�Ud�� �e+��c�*kIʜ.��~Vxӥ%�W>�u�k*[�!"�t������%s�%�!�&���-�ĵө�4W�[N��4������*.46����Ă�U�Y�k���8j�Y���杝0c��r�'����d����� `B���$1�[]��e9���oM��?��}f-�2~vL92;z0����>��:}Y7��I�U�yˈ�Aĳ��7����%�0�[�)�KNN/�KIG# @���C�1"Pk �>S@sr���� ��ex X�����@�A� �DJ�qƔ?�E�r�G�yxDj�4~���	W ��~�l3W T-	����k[�qH��7l��3�P"W�Β!�K���S��Tt�$D �60��4~�a>D �!�*�9iy~����Y`+@? �䫛���o�W�$["�6	BE��$  ����>@���ĵϞ̞sn}!GP^ڑ<;�`Pd=��@(���%_���h-щ	�%Gg��������6Y�h@��x�H��{� ���.��4�W�{���n�jU<��|���=W�i���rr�ʉ�e}IO����i��囇X��悞���^�a!k�S�X��XF��< ���/�����H����dlp݇��0�>(p��l�+	u꿛`Hi��W��jXٽj��ʹŶ�Fڞi�l�x  �a�ʣ����Z�2���,{U޽���mNO_2YB�j���~�J�xu��,_�sx@��  L�9Э���2s���Eu)�h���A�8Θ�'��U.�w�[���G��+�?A�H  �  }_�է ��8�0��jz�)�P22� ��^�  XQ�� H?�ʋ��?5��!�@�������� �������}'��P��;͒!��G�����U���U; ��k�em�Æ�V���  ��<��骬%)s��˖Tx�'6�~��/u��nsz����ʐT@������B�5^ͬ��!z("� �	1"Z�:; ��dڻuh�.]�`.99��.%�  `^�sz죯v2�oP*�3���-z���"����؊�/C������82] ���~N�J��	BE��$  ����>��.�M�L�'���d��u�f �́�G>��*��;  bY4{(�́?��8��s�^�X��XF@v��� p�����_����wST�E� �Qk5Ql�&�\I�<`4i.1�]�Y" ������ң̈́���;i���w�)���<�ŕ���Vv�ځ%��5�?�/+5�w˦�×ͱ�y��hG'[�!	�xLu�,r�h*\l�
FE�kk�tͮ �O�&դY�=���������v���H�������%L��f� �V��tU֒�9]�y|�ײ��<��Jk҈��KDk�P��δ�M���s5�#S*�RZ*��)  @1Qʺl��|~��_���?��6��/�
�6��/��,�I5tXoy?�I�
�R�޹��6\'��4��h�����'`X�5���K�@�[,@�H�}í���,�d�j]�|s��]��-��ϼ�?��~�͇����ϼ�Z[�f-D1�Y��O�W�le@E�̈́RR9@�/[�٬B �Rd�R�Z$�R6k� �j��@*��]UT� TQE���*Z��
��j#� @U!���H&�l6��B�g3ʘ�Q�TlŖb4V2��fl�R�Rp�.QJ��UR�uVi�~��}������������ß�� %�� ��� �^�����>���4H�ƴN}.5?�S��?���0�!<peS�
������$�Z���:j��j�U0�Gz�ϼ�'k����n�r��j~��1�BJ1(��Ӡ�SL��`A_P��4�v��uU9 ��uT�rZ�P���I�4�< �	2�㠎
  `�@���E�ԧO3  Y=��!U m-�t(Uy�U&=�-� �Hq����e@�<s���r�,C"F�4�;�+���Fv�u�\�`.99��.%�d��]j���R��:p���gj�q�:�%���X���S�i*׵���(�50O]�~�J����M��m�\�T��׭�Q�fE2j�d�NU��b� �� ,, �̬d)<k D|Rv#SI�(ϸRUTXn��|%XX؅fB���_��YB����J�c ��(3�T�(CS���R��/0m�W���&Z{}�Ͽp��g?��g�iJ�qƔ?�E�rY�ތn7�d�����QP����A�������4��z_[���x *��h[�8N< v�;���.X@>'�8@H�&�d�ȴp��,j� Z` R��%T:�f��� Aj4� X�&���D*,��q��D�b̬M�|΂@�M 40 �}Q-p]�O���=~}��$1 ����teZ���G��+ ��59 ����O�;����ɓ☜��� ��8Ut8�����t����))����[sy�\?���3)�� ��ʀA��y�6$Y�i�`���D&��i�d (��5���ZU�'����0迼��<��4/e�ew~�r#%A�H  �  }_�է ��^Hs����mqL�t�^�;��9ݫ�t܀}�c��L������:��-��_���?��\F�����;���̿4o�>8��������O�?b�߽~W�__�89A�� �\-4���<  �-�bBA Kî��$��A�H�=��t�-Ͳ��Z"I
 �
dbFNS	$i3�gN�`[P�DZP�H_�M  "�K�l2���K���azU�%}>{�c�{-��";4L��E���
��Lz��'�N� w7�:E3 J�@�#@b��  M����J�K�s_� ��S��9;� ��5f��9�_�_��y��oL�GQH����sП��I����o[�Ln��￦��_�迦7_ȟ�-��v��2;M� H牸�|bYO�S��G���}�d���ɉz�|��|�I.��'bi*-�6�L9Y�B�&i�dԊ�|R��� ������TE0,�,���bg)�gUR�N$ ȝ-r����&y>��ō���'V�g�p���U߂�ي貹�9��)  Rv.����fI���K��h�
yC`�c0�H ����=����/���7��7���#��]�vJ���w����._���ɯ��W��+`y~�����dғ� �|�eE�<O���IIz��y�p��}��'OWZ�i_>��js����1�� �+ IQ�3+�
 fT�K!(����'Z=��*�mI��5�{rK=@��j =�  �l����ͻ���5���I���@����3��g��I�2H����3@y�����v]�D/ a��:��ѓ;�ɲs�1p%�N����X�g�/zb7O_����X�"j��a�N��Ħ2(�Y  ���e|��q�i���R'R*��SI	�C�fN�W�gɏ�)C�
��4� $>����   5����cN�Q�L던��<9|�E��vx`����CW+�W�&m:�-FXj�T�,*2��-o��s�Z}����HbI^+c,���� ��?,|l�x���!AOƵ��:_�>.�����"�v�T�'xH�D-p&������)���'�, _x����$: �Iӱ��@��4��T�9da֜%k���������V���  ��<��骬%)s: �G���BX�lS�'QN_�	�-w��~ҧԜ��j�*�D�'�� 	�|��M$�G��h!E� $����#\�-|XH �"$`�$=t(?�L�a�@1�(�٘#����A�vd�CeZ�X�ۜ��d.��2$��a9��� $�u�G,N/����ӞOE3�x��Hȧ��ɝS��y��3[W5/�����	�}�?o4/�(�7�
���L�8a(d�-	��PY0$��$'�J���5�m�;~X���@-��$\	D���2=��@ڵ]@��P(��`.R��y�$�\�&
���h����NAx��_e����. ���X$@@⭊H0b�*B昳���Yc(L�p�11�� k#�� ���`]N�����볼/m�=������������k p�
����-A��,��ח{��ԥ����WJ�HX�W� �ȉ�LCi����F�p�O�@8�%y�4��Dh	��S(����4nz�sG �}BU ��>�:I�k���!H4�
(��`s���c������W¨\�:���0����(��`�D|@��Cxs(�� kg�L�\rrzQ]J:�v�^�K������  *1"�B��=}��=�ڒ�u��Bl�&�u��)��F�!0$&��P�-�s0#O��1$�bB��P�+�	�!� �h�3��J�B�<��a�J1D���Y�@�	�x%*	 j�x  dl|��%F�e%r(��Z�Rq�1�Onѫ\l<�l.3ۂ�j�d��y��B�`-��K>K*mK �IHd���&P �Ȥ�D�@U�����g��w ��;�&bV��@���D����Y�x?7D��@5 �+m �Lh6E�F!b �k�:�=5�LEW �ܲ����g{^\�v��~˞:jeX�u�J��<�lсY�L�ظ�	�x:@_��)n�tE�� Hq%`�h��XC��;	�N��[e\�M��¡�o"�DD<%/   ��x Y4K�PL@�` ����"I  ��5[}
��( |���z��K�@��ul���v��t��Yk;uy���$�Z"�"EO��ėd���<�/�В��p���m����<ߖ�#���c.��
y��4Z��`N�ל���8�����eb�%�؍��.Ɗ�DE[$�-�_B��F[�;O��%�H���/e�9+��.̀1@hU�r�<�@ave�� %s � ����  �  \S<����T�i�-�5 3��悵�����ij>R X�^�����X�'zV5*9Biu@�W��ʎ� �	�R��$ ��O���\;Q�,���{�u�rn(�N)�Ό���ThZ��/'� �lK{�}�-$}Pٓ�Y�� hI���N�=d���c�B`�)~J�,�$������������ + CE�I�Ĭ/1|2�Y�Or��R�X��XF��[o��o��1���Մ ���{<��y  ��6-��{�@�� 8IR  l�<��\�$)<��$�x"g���G�o�:V��#pI=��焤 �Z�  ,����,�\�=	�8���|����۩�4��z�-�<��0õ���P>�20�< �J�#�	H!@�1����	�Y!
�3�ҕY�L:��i5�>��_�wT�5�=|� ]�S��쉶�' �DSi��S68�g'sY�R&,��P`$`֟���� 0�i�l"�7��?��N�@4e]�Vi�l\Ǟ/���m�JB���!R��y$�+[]5��^���`N��t=�*�ق�  �ò�G�1]��$eN'��� ���mNO_2YB�j���~@��$��_;<��@^  &Ĉ�+v�V�1��g��%]�`.99��.%��O��G�!�|��)�oP*�3���-z�ˀ^u��Sv_zܫ&�hu�{j��� AH�5������	BE��$  ����>�u?Z����JIo~"��Y�h@��x�H��{� ಱ��Et��k����-�2R����{Bn���K��vx`����CW+�W�d���W+��=�*�ق�  �ò�G�1]��$eN���W����v��ӗ�E�P��� :,��� �-%Y��=�� �������5?��J���%'�ե������n����k�v��7(�S����e��r��1��z�݃O������82]�&I  �wz�I���"I  ��5[}
�V��H(�VRz�]yhz�)�P22� ��^�  8��v�i�OT}�^�X��XF��>���r�7Y�X���@��Z��b�6��J��={� cU ��ٝ�G�	3���v����&R��y$�+[]5��^��N�;���կ}���\�i���~��ĩWNt��hG'[�!	�xL�Al�QB%-���l�B`߲�<� �?�T�fm���~��o�}�3���{ �~��7~�sE	�*�ق�  �ò�G�1]��$eN.�v����omǯ�
?ve�N3�d���S���=&�B'�J����@1Qʺ�������?��/
���_n�����nsz����ʐT@����>�n�$@|�=}~x�S��V�ew�B��[��7n�' �"J��S�,9%}в�!#��MWR�EcÞ��L;$��FӞn)�\����#��S8��mUN�h$K��"f�!�q�)�ʔ�� ���PJJ g ��V�׸���� ��B��)�n� `U��q|�-���Q�$��HYsH�ͤ,�1P��j���x>�R�|Y"��0*_�AMH%'a���Le K-J�%\��"�%���Ҷ��K�H�%B��W?��o^��z��PD /  bD|l  Nˮ~�Oխ>�1�����j�qW��\���_����IgN9Ʃ7OQd�Mbc���ô�Y9v�G{��ћ�ǘ�II���G�%�y:����G�������m	��K�?�k�^QI1(��Ӡ�SL��`A_P��4�v��V��4 �~9�4��P�H�D�	0*���
uHo`��*_�T�+kQ<E��2� �zM�A6����C�՘�l(��flAF���ڌ,��B��"����&ˠ|�!F�4�;�+���Fv��fT�e
撓Ӌ�R��  4�f��?�:������f'{���%�����9�����r+���K��Ij��t��mJ���\NV>�MrP�5��ts�D=���,ة�vQ>X `��� ���,��B  A�''��'�oR��C �B	Ǜ��D��dM�D �B|	@�f	�*��J� @�QB�&�(CSI3SR��0m�W���&Z����ӳ��Ŵ��8cʟܢW�̤����q�P�����,b`%���r��E>dK���� � ��@i~��|  @J4�B���* T- �@ə  (O�  K�~�M�A�D-  MY�P �3Q�IYY����U!ߌK� @�M��M��A��C�����?� Q��z�2��zO�#S���t���Ir�[���v��ʉ�D�(�@�s!gU�������	� ?����C� ���b �rY@@FD@�T2Ŭ�g�kr���hT�(�T@�� �V!�J��|�5,葌C�{�)(�(��R��"I  ��5[}jҚr]�jJeJ��-;b�	�`'�3!�������B��l��-��fny���MgrV�ӫS�?��&٤	@��d1IDY�(J���A ��b��]��b�%�� X �'�-Q��'�e2���]R1���M�e�Je�ˬ	�T r
k�jT�@����0*ϤJU@z6L��&�$�����@���w'o���d�� %s � �����N��)� %��l�j_�`�!��e�!�Ң��1�A�%%=���dr�W��5�_�迴7�ٖ�#����0I�lv*O�iS���x �*��
��l����j3`R`R���L�xxU,���\�)ٞd-j�!���8�� c �%OY$YC�%g6A����Iٰ��LT�  ��!{��}�)�f��R�ȡ2j&�d4E��!�@��������K����M"qWtH��@:�Ք��_��c���~���$���_s,O/��_�IO D×�q�������Pv���@G��UV2EoVGR)*�(��! 8H"ނ��  ��D�(��U(�̭��qp�C�\��{��{����W$��I�Q���jsr�W�F�=	�U:���]��M+� ǰ\�q�:�E��&9 �#��P����"��/���5bOY�������dHi��,�l=tհ�{��5�wr��O=��7n��q%F��h�y�����Z~���������b?l��?������C�χ��߂Ǜy<�騥�2��^M���XJ��\;�.����*�ق�  �ò�G�1]��$eN���k{�rI�ʾ�����B����  ��dk�wp�����,$a����m��쁂�e���s_}��)
Tv�qh@-H�˥@��J0��IG�����6��/��,�I5tXoy?@��Z����?�����"����z\��A(��s��nk�/����^�vX}�����ؗ ����-w� p��)����T*� 3Bec$Zer�@�A�95}�9>4��:�H�]�!!��4��,/fJoJ�,�j�JH�R�[��a&���5t��|�� 0!F�@��y���辷=�k� ��M�do�㖝��I��� ��ߣ������]c+��멿�U ��E�����O�֣���o^�r���w�"W�����G�7.M�^�pJ/$�^E�$��T��];��Hu��H��+���Pٰ\E�0����u���������t4z/�ᖻ������ǹ�L.w��КT�	Ht{�w����"��'P��Е����<��wgC��Y�p -G�&�*�؀�
v��)�:%�h���r��
Μ4�A��`�ɠTgL��[�*�K�cg?}j@}�|���[����M�|u�X�Y(�%�88���[5R�8'%R�����s�X�0=��|.���{6?��# �o�n,ES!��=�?^��vEsh|5�}�+��m��4&3�Gz~��s=�KUV59����������W��/n��6t����zO�#S� k�i
��z�?x�o~z�T������bv�L�� $����b�	�s������۳�ɽ�巾-C^�%	D�  ��k�� W�!�O���i_�药�����_f��B@Rk���#nc����1C��t�	q��N��98�\GGw������>�\�O�%�*|:&������/~|����|�N���9����X��r ��w�^x��R�x����L��I1���[�]�X�ex�O~���� \�g~��_�uſ���?}K:"���	p����=����ź����[��w��2����|R"��( ��Y���P{�v��[��#yC`�c�e�����;��� �WJX�s���f}���
����ݺ��1�:��M�R� ���B~��5����sTJ]��EQp���;:���q����?�ݔ?�r�i��dHi��,�l=tհ�{�����;���^y��v<Տg�HcZ~�SmPf%{��ק������>������+A�w��3�����e4��I���0�"�- @8,[yT�UYKR�t	%}��M��������s�bh�wp�����,���Je�E7^$�-tG{���(E�ӗ{�wR`�]���'���2������%s�%�!�&���-��*�^�u��_��C��)������.�n��N[i2T�&�[��m���|�k �έǟ4��O�.�B{g	(L�ss79�\ݞ�nP81��)L��E{��mK�Y��={%�2GP�޵��I���8<���3̄�*� ���g���[2{�=�q�du۪2TԹ���r��n�]��{�)�p9{��t|���Zܾ.�r�Qt��A�Vs⊭?ݣ��V6������xӘ�TI�?�����Q����[~�d3�t�.S0���^T���F���γ��Ǭ,���s�p����;�\ʰ@��P	�%@�4WJ���Y`W�9�ή�r��
	i+h���X�(d��d;�t����o���������������Һ�A�8Θ�'��U.κ��{#�z�7>��h�,���%sPv6 uR �8�K\ ��8  �
j_�z/��WCb�����82] �<W��,��� H8��%��!�?VW� �X�*��CM�"��H@ ��}�V�R��a��n ��>^��9��rT�UB�0 1���5��KC����gZ�2n�	���X�H�zX�h@��x�H��{����wO�������.m��.����������O���'ll~;��'���6��&�뀁�[N�l��?��O��e�G�X��XF@����������p�s=�E{
���E�ggdE��w����y rR,y�u��h/�k�;���g���y��q����?���ߝk^}���n��� ��?i��O����ۗ�_��w��W4�>��O�3�;��K~��?�������i��h�q�E�g^��X7�y;���o����)m5n��?������_�������o~�i?����+���sh�O	�YY�e�������$�mmw�ڨKT�1Wc��զ��E`�Ȝi�β��} ~��s)�xݷ�UMeY��mw��(�Vƹ��)�j�`��n�^�7&�S��w~�����y՞�_��L�[{|��Q;#;~%h���y���>����iyy�'W�]8O�z��r74����p/�Zkp����)g~�[��L{��O�+z����`z�wrl+���泪M��]>���f{���v�ޯ���ᠲU� +�ŖlQ�X=��<m9.	VFV���TG�w����k�Śu�^P���/��i豈���6/����Fp�<�v沴}w��@�?����_�㿢�^y��ݦ՜FB�K�Ϊs!jfﶂ�����.�頥B���~k��N�-AU��pr�j6����刈�6��^�.\w�5�c���x��eT���ʦ����6 ��p�^���sW����ܓV ��M^�d��ڙy�e>6�s�xv�?���p�/�vYGL��몬m�h���՞z�Od�� xs`��4cv�������z�I	�4��p/�w����%�y:/3�������P&�[���7�On��,m�� L�ss79�\ݞ�nЂ`��,Qw��1�M��m-��w���=q��o��Y���=���Sg���)i�[��G~�������.�9�� �]@O0�mW#������^�r8d��[S;�C6��-AEζ��8���.&瞟��> c��s|�����V�[ko�,m�ڵ��?�]J���ѹgs�N@ ���6'9.�z;=�G&������CV~5OR.�{a����I��9����m.�Y RP���ū�LlW�l�]�)u�<�Wp�:������A%��L/�j`���?�2lN�G����{u�u{`�W����iJ.\�^�8�|?������E{�3��f�4�sR2'fdON7�u{�&��.�B@a��.\\P�M[͉+��t�����7�^����}�K�U��S���=*y�Qd����o?ٿ^����]2OI��_���Ӓ��[`e�]3�� �����qUT�A�kfJ�X�Ȓ`�IX��1`����'�>n�&Pk���%�)��_��B�ة%�#�,�N�~R�1���?����;�| ڦ�N���T���F��Y�k�� �  ��}���Ͽ��1d	���\)��:g�]u�:�v�=sld �����9��MV6�G@��.	i+h���X��3G�q��	��*��Vc\P�H��"I'�ʘ������ +��1qe� �Ë����U��8+VUi#렂:	c휥���

l�S0���M�5?�u��[6-#'��9 ��7 Ƥj����~v#�'��C��bXRI�F]2�\�v��mSSA�c ЁX����@�0���Ͼ�_��S�w&�: `  '5  c	ű=L�iGZV���Ս�I�x�fI3���`v� ?�#��'y���O�&fY�2!����_�EcKU�L��/�.�`1h�V:Gg�/?�3h�v/� �X�/�� �򳢛�N[yw�0�b�S⳪�������Kz�	�rz�����	�/��g��Mۄ8�Ϧ�LB�mV�i�_��#⃦:�"�_{Z˛� ��8[WRl�D3��-�А���@�qI1��9:�ZR���f��)����8��������$��1���m;�d�*�6��~�>�T�G�
����gO�E x%�����$��/tr|&ġ	�a�D��7o~6͞k��� iBi]�U�j�:z�Ϥ�T,'�jA��Nɭ�Z�|��d.�������W�w���ݤs���^m�Ƭ쬵<MM�@��q��H$�ʗ����VI  �N���N�N<{;��u{^�o��f<��T�E�?�ĺuM�n�n�a֤K���E��,�{mk)�T�Ϗr�i�,��6�p���R�󭼿ܦ��tE[���|޹}꬙<�gyϦv�vͮM�ꁂ�J.\O���w�U��@�~��^��/��i����C��[��x1�>�Ts�P=}�S����8G��k W�����
45[f��k��n�<޼u�%�m�����쬕�����r(>����6P�66?���Ӌ�~��5��GOS>k��o�[����'������ˊ��� ��V�i�WZ�����^���ǯ+��/�+���Qw�)�����(��t�,ko� ��=��Tw�pM_�3 ���o�=�6 W�}/����ɧ;�� �k�>  ��8�&˛���k��)X�,�S�%�����.7�# ��{�y)yp
�E>1��;���P8�K<Y��� ���p��w��l��z�+���h�
���:��c��G����-����K��N��&�����n�	j�<��V7�3`�+/�K��U��p�ʋ�~��.�:��i?��/���W��?a��sͫ��#�At��?��?,{��~��(������� ���?��>���7|��@����̍Ni�A��y�M�~�?M?n�c��W���<|��.����ab}*s֞��K��wg���o��#Vv!fg��*�6n��˦����ã�]���F]�"��s-�6Ս-
 �G�L�v�U��� �ۗ_�K���ݮj*���l�cNG��G�j�oK�%����͎�����	���9/wC�H������w�i+�K���u{,��U�-NX�.�G�!�*wl�����|.�����6�3�����9"7&/5��(���V:���gU���|t�0;:�\�x�lՆ(^,�-٢(�zz�x�r\������<����,mߝ�-���԰:nި�*���:�v\�֍{�9���$��_o�����HHScI��Yu.D���V��uT��M��[!��[S�v:n	��兓�P����'/GD��Y���
��t�íI��ƻ,��$�LV6�,5�ݷ�e]�k�
"�E>;���I�ݴ�}�5���}�]�s��3�p]��gs�ᯗ��� �ԟ�$5�k�˜;��v�?��h}�O_tN�"�z�q���gw7���������}Sk��}f0=����Lsu{z�A�鮲DU%�ġD'g�IB����m�ue��h�;� �ͫ�C"��?^k½��Po��1�M��m-���}�����s�x���e��K�w�����~��)m����~���Q�쓬n �>��T ��vu0��*���oM��t[�9ۂ���0����\�{~�� ��_����֎��Z�o��ճ�k׮{��v)��^�G�͝{:�����u���m������/�g���e-�z�nW�����U7��?G���[_�yp������j���3��/O�'��82��񽏵J��){�:��$9��2�?���>�������� �|д՜�b�O�n��z��UkN/<Ч��=��"v^�}Z��=}%b)�n�G{t�����rN]�p�������n �ܹ^x��F�U��S���=*y�Qdd�_��oݵ=/�����Gi��"�7�]3�� ������J�X�Ȓ`�IX��1`����'�>n�&Pk���%�)��_��B�ة% 0�}��%I�6���v�j��~� K�� ��Z�' pн�|,�Ėw/r7 UV����k�< ��b\~6����i�+�$�����Vc}r����-�O�$��<G�t�E�U?Ul�Qk�=]g7:��z|��g���	d ��*��Vc\P� i2d �(��z�\����  ^����WԈ�p��*mdT��0��Yj���� ;5 ��@Єx��yi|��޼�����`���-oO�m+Y��u'��� �,����`�*��c ЁX���K%uY����h9y�Y�V&� � �x��u%� :�o4K�YO���� �u* �7�5�  i9��%Y�xQ����>i��0�=ok�i f� ��9 ����>�gs�2n\w��Mw���+���3��#�ғ�{��jIwI��bЦ�y`L�k���9�kЪ�b�I>ݷ����_�\� ��a��q���~5O����/ H�AJ����8qs�����;#���	q00 �M(����۬X�@��wG�MuzE޿��@�qi1K�y���ɺ�b__��?':����Z8+���zz�2۽{�@�Ɯ��-����8�������-p�t2u��)V@��	�ߜE�u��7yد��R���K� `T��B�$�1ㅆi����L�MRB7Ŷ	����qA�'�{��$ �TW�Ӧ + L�5��N���8*`C� ��6��;�����0ZW��/>4�~��������8���X�[��� X~���op�g:m+�[�F������,����^x{��f<��T�E�?�ĺuM�n�n�a֤K���E��,�{mk��1��
Y*�3�p�+��@$���U�wC�TO����~5�KtnXw�>�� �ݞ+�~���~���3�&������Y�>�J�ʥ�2���~����͇[�\���\��ٻ�מ��� ��w�T9۟\��LSo�m �ۮ͏�S�4�{��	�1Gt��]�]���7��2�( ���;��b�wm��On�'��5��Rs����i��]�V���^
����-jeVz�~	8`����/��z���� ��O]�=�n��Ϳ�㮸k��fG�=����3 ���Q���V����1�_}�k��~����ٿJ b+?;�+�y�) ���  ���	�M�����k�7��ȉ��ֽE�qu>]n�G ��i/ �'O�7�Of�t�@��>��~#��񎳹4�8g�����\~�>=����\OAF�c��Y2�s�ǧ�S_y�Ӯo|�|�����/��˾�{��ɝK'_���;��;Ї�V7�3`�������Z8O��?����^?�[���8�'/ĸ�P���):l���h��"?�]m۱��UY� �͵��v�|��6Ս�Hc.���h�U���0�ۿ�&����"�s�*{ї��%^���O=���v���]#JZM}Wu��>U�.�wT!�݁Kꢥ�N�9�Э@����_ޞwZ����M�~�q ��� ����Z��$B Z�:; �����G)�A6{�zg�����i��; @9隲Ƽ��t�� p�]~,����\J��jB��%�(DtW�1vP#΢�m��s��$ $!v  �& �xf?�M��"mh���j���s/܍J"��WԸ2�:���S{���r�t�Ty"����q����O�e�����;x��Ͷ��O����]�,�=�J��7���:m+�[�=�z/��.��;���> ���u�JB���f�-����>���>9���G4Ze�ஶ�XT�ت�S,������Yj�.�H�_��w>_t>;1^m}���6�29{����FR���U���X�g5��M�*>l
F'��II��9n(�7ھ�|�-����e����3]_��)ì0Y��2��t�����%5ٝ �/Q��Uً�tX=��q`^�����7�P٪�wI���n��.e�K�Q[�2�ݬ%��8=X�Z�
�q��6�����~Wu��>U�.�wT!�݁Kꢥ�N?$q+�K����Y���ij���'V�kU\hl&WoI�1~�F�����q�R�jg��;;;`�2k%L&>m֖Q�N^�t7���$.�f����`7h�<k��f��T��4/�fq�xw�bT���Ե� j�ШM��f�V �q��x��y^u6k��1=mKک��ݠ�r�g�`F� ����Z� ,�~<v����8 ��Y��(����U���K�l�j���
K���|�t��9�i��ɼ�1u�C��1ҜtG}�H<y*&Gg�i�[�$ě��pom�[i$0�=0y����&}�ه��W ���"I
����I" ��+5�:Ӳ�j�5��������2~vL92;z0����>��:}Y7��I�U�yˈ�Aĳ��5Ĝ���\y-oD��uGg�O���LvDӹ�;NO7)9��b+����I����X�*�fe��:1혘[X-���형�MWE�Bޤ(�yĩ2�b���V�:�cj ���ܪde� {�/���N$^_���!�zb�b9��%�HzJ6��$j�%hg�sd/��<;�s���d�B��dj@������gb��U�y
Ó�GZ�ġ�n�Ț�f�I��Z�)hS�Q�[4&$)���ç9��  !x�k���]j��O�K�@@�,�L��i[ ���#��`�VG4�& ��:<B�)�Z�uP��:P99���w�nQn1z:h)Z�&:���@�,X�U-@F�H�A�p��s��M�s����$�yX�t3�K8�ZL@� {�@� S)��X��-�'H�7�l]u*d����dWm0��.h�U�8h���[u�'#OJv��T���S	����Z���IIW�CsM���Q�L��>�r)���	!�,#�У�7���G�^s�Ԇi�8x�� 3����f�@�Z���a�׶|�fyo��1f.+��~�Vo͉ '.z�N\ޟdPx�1r��q �N� �N� �Qg�	l��A�����wZ�;���a	�{#$J� @��WF@��J��:-� �(c�N  0͛Wb5U������%����$�v6��[C �; �H$�kr@"`{pl��i�� �8�����IgGf�� � D��n�6 F���;<z�薵ͤdE32�`+enN2t��Q�>y�qg� �Tos�[y{�J�U8�n �%!�<����d�kx��_;G@OU&zu�;y�X����ۢ�VnU�@Ǖv��({�ǽ��5���s/܍J"��WԸ2�:���S{�����
�������^op�)���u@�h����Q�}Z�-�����@]rt�n��:�\U�$�i��j�
�\�d!2�J�[k��`ӓw��h��&&�U��.5 �u�~�x��4ۤQ;2[�+oz��8(Lv�U��I\ t4�� O��$���&�>���Tz%�h딱��= ���v�DP��r\�=51Y��g۵�VE�II?���	ɪ�OC�S ����=���xB�����4_��9 �H��/�l;��Ę���5�����Ը�>���J�jU4��f�랫�}�[99p��岃����W@�4w���C,�jsAOrD�g�Nnzeu�%
��QPm{��.�bm���4�W��)�T z�wD�U��u͜8g�5���#=<H���� ,k�3�|��t$�5��ŕ��j-.i��M�����5xk��֑�LKW5-U�5;�X��V
	YU��D�D����O��^N�{��3�P
p�R����_�m�Y��Wfgui�[� x�>�������\�X�vqu9r��n�4�{ti���� �[_pq"���x�����"��G��5�G���y o� Ъ��-k�{��C��z�uW���- (����= �M ����W��zeR\��"̒�j�o� �C�1n���>��2O�-�)�lk�tO��-]P�K$=�gR�\Z�?������e�5�_	���)Cl���h��"?�]m۱��UY�ܤM���hu=ӪOgy���_R��	b�R�9]���K�������](M/H\�UD�T5��
�Q�tv.����:@��sԹhz~�q ��� ����Z��$B ��������uק����Os�� B��I�  ��^��bً���=�K�\Mٸd�ƣ��2�+�l��s��$ $!v  �&�e�	���>m>��ݨ$�OxqE�+C�s��=��o@Y
 �^����|�/� �"�^�|��(�c�"j׀[  �)p%�N�w��       [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://d3tpnxcy3pnev"
path="res://.godot/imported/Picture.png-177ae9801e24cff07ab70e34079dee29.ctex"
metadata={
"vram_texture": false
}
             [remap]

path="res://.godot/exported/133200997/export-53924df8e0ba501d0cdbcf3847bbfbf3-main_scene.scn"
         [remap]

path="res://.godot/exported/133200997/export-ae4ef22a5e307f1cbeed5cf604474d4b-label_settings.res"
     [remap]

path="res://.godot/exported/133200997/export-97fef84aea54af999ff5898c940d6ab5-theme1.res"
             list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             ��a��=�,   res://label_settings/new_label_settings.tres^Gs��   res://scene/main_scene.tscn��3O~?r   res://theme/theme1.tres��h���I.   res://icon.svg��a��=�(   res://label_settings/label_settings.tres��a��=�"   res://settings/label_settings.tres	ʏ)f�/   res://Picture.png ECFG      application/config/name         TangoPlayer    application/config/descriptiond      \   A dictionary made by Godot, you should drag a txt which converted from mdx into the program.   application/run/main_scene$         res://scene/main_scene.tscn    application/config/features(   "         4.1    GL Compatibility    "   application/boot_splash/show_image              application/boot_splash/fullsize             application/config/icon         res://icon.svg  "   display/window/size/viewport_width      �  #   display/window/size/viewport_height      ,     display/window/size/resizable             input/MOUSE_BUTTON_LEFT�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     �B  pA   global_position      �B  `B   factor       �?   button_index         canceled          pressed          double_click          script              