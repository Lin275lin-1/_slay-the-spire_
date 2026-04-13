class_name FileHelper

static func get_all_resources_in_directory(dir_path: String) -> PackedStringArray:
	var resource_paths: PackedStringArray = []
	# 当前目录的所有内容
	var items: PackedStringArray = ResourceLoader.list_directory(dir_path)
	if items.is_empty():
		printerr("目录{dir_path}为空")
		return []
	for item in items:
		if item == "." or item == "..":
			continue
		
		var full_path = dir_path.path_join(item)
		# 子目录
		if item.ends_with("/"):
			var subdir_paths: PackedStringArray = get_all_resources_in_directory(full_path)
			resource_paths.append_array(subdir_paths)
		# 资源
		elif item.ends_with(".tres") or item.ends_with(".res"):
			resource_paths.append(full_path)
	return resource_paths
