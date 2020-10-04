<h1 align="center"> 利用Github Actions制作XiaoxinSGSIs</h1>

<p align="center">
	A Github Action to make XiaoxinSGSIs
</p>

<div align="center">
	<a href="../../actions">
		<img src="../../workflows/build_XiaoxinSGSIs/badge.svg" title="Building Status" />
	</a>
</div>

<br />

## 配置

配置文件是[sgsi.json](sgsi.json)

| 名称               | 类型    | 描述                                                         |
| ------------------ | ------- | ------------------------------------------------------------ |
| `rom_url`     | String  | Rom地址                                        |
| `rom_name`  | String  | Rom文件名                                        |
| `pack_sgsi`  | String  | 打包压缩后的文件名                                        |
| `make_miui` | Boolean  | 指示是否制作MIUI的sgsi                                            |
| `make_flyme`    | Boolean  | 指示是否制作Flyme的sgsi                                        |
| `make_coloros`   | Boolean | 指示是否制作ColorOS的sgsi                                     |
| `make_h2os`           | Boolean  | 指示是否制作H2OS的sgsi                  |
| `make_smartisanos`    | Boolean  | 指示是否制作SmartisanOS的sgsi                                           |
| `make_zui`        | Boolean  | 指示是否制作zui的sgsi                 |
| `make_super`      | Boolean  | 指示是否制作动态分区的sgsi<sub>（注: 不支持动态分区的`ColorOS`）</sub>        |
| `upload_transfer`      | Boolean  | 指示是否上传sgsi到wetransfer        |
| `upload_artifact`      | Boolean  | 指示是否上传sgsi到artifact<sub>（注: Github貌似对免费用户有限制，上传累计到一定量时就不能再上传了，故不推荐此方案）</sub>         |

## 开始

Fork此仓库后，点击右上角Star就会开始

## 制作结果
在此提供三个选择，详情请看表格

## 关于Patch
这里引用小新大大的一句话 
>本工具仅仅制作system.img部分 Patch部分需要手动 因为有些处理自动化并不理想 多变 所以手动制造Patch1 2 3更好

***Prepare_patch.zip***是我从Rom的vendor提取部分文件打包得来，用以筛选文件合成Patch1

Patch样本我已内置在压缩包里，请解压后自行更改