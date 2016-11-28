# 编译 / 更新 编辑器 | Build / Update Editor

## Update_XXXX.bat

* 注意在使用这类升级操作之前，你需要先将零散的项目编译出来，你可以尝试先编译（使用VS2013）"Development/Core/Solution/YDWE.sln"，编译过程中会显示所有需要的文件
* Notice you should build those scattered project first, you could try build (with VS2013) "Development/Core/Solution/YDWE.sln" first, it will show almost every component you need.

### Update_Debug.bat

* 更新编辑器的组件数据，通常在修改了位于OpenSource或ThirdParty中的代码后会需要使用，会将一些零碎的组件复制到 {XYWE}/core/editor 的对应目录下
* Update Editor's Compoenent and some scattered files, those files will be place to "{XYWE}/core/editor"

### Update_Release.bat

* 类似上一个，会复制一些只属于Release模式的数据
* Similar to the previous one, will copy something just belong to Release mode.