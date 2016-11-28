# 编译 / 更新 编辑器 | Build / Update Editor

## Build_Release.bat

* 编译并发布编辑器，完成后可以在publish目录下找到完成打包的编辑器
* Build and Release Editor, result will place to "publish"

##Update_XXXX.bat

* 注意在使用这类升级操作之前，你需要先将零散的项目编译出来，你可以尝试先编译（使用VS2013）"Development/Core/Solution/YDWE.sln"，编译过程中会显示所有需要的文件
* Notice you should build those scattered project first, you could try build (with VS2013) "Development/Core/Solution/YDWE.sln" first, it will show almost every component you need.

### Update_Debug.bat

* 更新编辑器的组件数据，通常在修改了位于OpenSource或ThirdParty中的代码后会需要使用，会将一些零碎的组件复制到../Development/Build/bin/Debug的对应目录下
* Update Editor's Compoenent and some scattered files, those files will be place to "../Development/Build/bin/Debug"

### Update_Release.bat

* 类似上一个，只是把Debug改为了Release
* Similar to the previous one, just change Debug to Release