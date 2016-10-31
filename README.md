# XYWE

咸鱼地图编辑器，重整结构中。

## 常用Git命令

### 仓库目录外

克隆XYWE到 工作路径/DirName 目录  
git clone https://github.com/LazyKnightX/XYWE DirName

克隆XYWE和非嵌套子模块到 工作路径/DirName 目录  
git clone --recursive https://github.com/LazyKnightX/XYWE DirName

### 仓库目录内

克隆/更新 所有子模块  
git submodule update --init --recursive

移除子模块  
git rm --cached path/to/submodule

## 资源结构

### ./XYWE.exe Develop.lnk

以开发模式启动咸鱼工具箱，包含 编译YDWE (XY Edition)，发布XYWE 等操作

### ./core/editor

固定的编辑器目录，编译后的YDWE会被放到这里，咸鱼工具箱会在每次启动WE前根据用户配置来更新editor目录的数据，从而实现动态管理