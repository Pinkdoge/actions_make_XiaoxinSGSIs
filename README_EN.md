<h1 align="center"> Auto XiaoxinSGSIs Tools </h1>

<p align="center">
	A Github Action to make XiaoxinSGSIs
</p>

<div align="center">
	<a href="../../actions">
		<img src="../../workflows/build_XiaoxinSGSIs/badge.svg" title="Building Status" />
	</a>
</div>

<br />

## Configuration

The configuration file is [sgsi.json](sgsi.json)

|   Variable             |  Type   | Description                                                         |
| ------------------ | ------- | ------------------------------------------------------------ |
| `rom_url`     | String  | Your rom url                                        |
| `rom_name`  | String  | Your rom file name                                        |
| `pack_sgsi`  | String  | The compressed file name after compilation                                        |
| `make_miui` | Boolean  | Indicates whether to make MIUI sgsi                                            |
| `make_flyme`    | Boolean  | Indicates whether to make Flyme sgsi                                        |
| `make_coloros`   | Boolean | Indicates whether to make ColorOS sgsi                                     |
| `make_h2os`           | Boolean  | Indicates whether to make H2OS sgsi                  |
| `make_smartisanos`    | Boolean  | Indicates whether to make SmartisanOS sgsi                                           |
| `make_zui`        | Boolean  | Indicates whether to make zui sgsi                 |
| `make_super`      | Boolean  | Indicate whether to create a dynamic partitioned sgsi <sub>（Note: The production of `ColorOS` with dynamic partition is not supported）</sub>       |
| `upload_transfer`      | Boolean  | Indicate whether to upload sgsi to wetransfer        |
| `upload_artifact`      | Boolean  | Indicate whether to upload sgsi to artifact <sub>（Note: Github seems to have restrictions on free users, uploads can no longer be uploaded after a certain amount of upload, so this scheme is not recommended）</sub>         |

## Start

After Fork this repositorie, click on Star in the upper right corner to start

## Compilation result
Provide three upload ways, please see the form for details

## File Structure

| File               | Type    |  Description                                                        |
| ------------------ | ------- | ------------------------------------------------------------ |
| `system.img`     | IMG  | The main of SGSI                                      |
| `Patch1.zip`<br>`Patch2.zip`<br>`Patch3.zip`  | ZIP  | Patch template   |
| `Patchmod.zip`  | ZIP  | Apply patch templates to make patches                                        |

## Troubleshoot
### Q1:  Why not support the SGSI production of super partition ColorOS?

A1: The SGSI produced by Dynamic Partition ColorOS can not boot after several tests, so it is not supported.

### Q2: Why can't tools make SGSI fully automated?

A2: The Patch part of this tool needs to be manually, because some processing automation is not ideal and often changes, so it is better to make Patch1 2 3 manually （Thanks to **[@迷路的小新大大](https://github.com/xiaoxindada)**）