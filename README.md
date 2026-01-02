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

<div align="center">
	<span style="font-weight: bold"> 中文 | <a href=README_EN.md>English</a> </span>
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

## 开始

Fork此仓库后，点击右上角Star就会开始

## 制作结果
Actions把结果上传后，解开压缩包，内部文件结构如下，详情请看表格

## 文件结构

| 文件名               | 类型    | 描述                                                         |
| ------------------ | ------- | ------------------------------------------------------------ |
| `system.img`     | IMG  | SGSI本体                                        |
| `Patch1.zip`<br>`Patch2.zip`<br>`Patch3.zip`  | ZIP  | Patch模板   |
| `Patch-maker.zip`  | ZIP  | `Patch-maker`内文件提取自Rom，用来制作Patch补丁                                        |

## 疑难解答
### 问题1:  为什么不支持动态分区ColorOS的SGSI制作？

解答: 动态分区ColorOS制作出来的SGSI，经过多次测试仍然无法开机，故舍弃此方案

### 问题2: 为什么工具不能全自动化制作？

解答: 本工具Patch部分需要手动 因为有些处理自动化并不理想 多变 所以手动制造Patch1 2 3更好 （感谢 **[@迷路的小新大大](https://github.com/xiaoxindada)**）
