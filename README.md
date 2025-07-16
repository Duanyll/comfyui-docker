# ComfyUI Docker

另一个 [ComfyUI](https://github.com/comfyanonymous/ComfyUI) 的 Docker 镜像，适合个人自用。

- 基于 PyTorch 官方镜像构建
- 没有内置 ComfyUI 代码和 Python 依赖，因为经常更新
- ComfyUI 代码仓库使用用户权限挂载在主机文件系统中，方便修改
- 可正常使用 ComfyUI-Manager 更新本体、安装插件和模型，修改能永久保存
- 带有 [FileBrowser](https://filebrowser.org) 方便在网页端管理模型和输入输出文件
- 支持直接使用 docker compoose 启动或者使用 devcontainer 调试

## 使用方法

运行 `container.sh` 脚本启动容器. 默认会在当前目录下创建 `workspace` 文件夹用于挂载 ComfyUI 代码仓库. ComfyUI 对外端口为 10001, FileBrowser 为 10002.

要调试代码，使用 VSCode 打开本文件夹，然后按 F1 打开命令面板，输入 `Remote-Containers: Reopen in Container` 即可. 按 F5 开始调试.