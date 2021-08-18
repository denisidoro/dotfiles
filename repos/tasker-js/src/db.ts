export type Id = number
export type Path = string
export type Filename = string
export type Size = number
export type Date6 = number

export interface FsFolder {
	id: Id,
	name: string,
	parent: Id
}

export interface FsFile {
	id: Id,
	name: string,
	folder: Id
	kb: number,
	date: number
}

export interface TelegramUpload {
	id: Id,
	fileId: Id,
}

export interface AzureFile {
	id: Id,
	name: string,
	folder: Id,
	files: Id[]
}

export interface Data {
	fs: { folders: FsFolder[], files: FsFile[] },
	telegram: { uploads: TelegramUpload[] },
	azure: { files: AzureFile[] }
}

function asInt(x: any): number {
	return parseInt(x)
}

function asStr(x: any): string {
	return x.toString()
}

function asIntVec(x: any): number[] {
	return x.toString().split(";").map(asInt)
}

function withoutLeadingSlash(path: string): string {
	if (path[0] === "/") return path.substring(1)
	return path
}

function withZip(path: any): string {
	return `${path}.7z`
}

function nullOrUndefined(x: any): boolean {
	return (x === null || x === undefined)
}

function getProp(data: Data, name: string): any[] | undefined {
	let xs = data
	for (const p of name.split(".")) {
		xs = xs[p]
		if (!xs) break
	}
	// @ts-ignore
	return xs
}

const transformers: { [key: string]: [string, (arg: any) => any][] } = {
	"fs.folders": [
		["id", asInt],
		["name", asStr],
		["parent", asInt]
	],
	"fs.files": [
		["id", asInt],
		["name", asStr],
		["folder", asInt],
		["kb", asInt],
		["date", asInt],
	],
	"telegram.uploads": [
		["id", asInt],
		["fileId", asStr],
	],
	"azure.files": [
		["id", asInt],
		["name", asStr],
		["folder", asInt],
		["files", asIntVec]
	],
}

export class Db {

	data: Data

	constructor(txt: string) {
		this.data = {
			fs: {
				folders: [],
				files: []
			},
			telegram: {
				uploads: []
			},
			azure: {
				files: []
			}
		}

		let ctx = null
		txt.split("\n").forEach((line: string) => {
			if (line[0] === "[") {
				ctx = line.substring(1, line.length - 1)
				return
			}
			const ps = line.split(",")
			if (ps[0] === "") {
				return
			}
			const transformer = transformers[ctx]
			const x = {}
			for (let i = 0; i < transformer.length; i++) {
				const [name, fn] = transformer[i]
				const value = ps[i]
				const isEmpty = (value === null || value === undefined || value === "")
				if (!isEmpty) {
					x[name] = fn(value)
				}
			}
			let v = this.data
			ctx.split(".").forEach((p: string | number) => {
				v = v[p]
			})
			// @ts-ignore
			v.push(x)
		})
	}

	serialize(): string {
		let out = ""

		for (const [name, keys] of Object.entries(transformers)) {
			out = `${out}[${name}]\n`
			const xs = getProp(this.data, name)
			if (!xs) continue

			xs.forEach(x => {
				const ps = []
				keys.forEach(([k, fn]) => {
					const value = nullOrUndefined(x[k]) ? "" : x[k]
					const valueStr = fn === asIntVec ? value.join(";") : value.toString()
					ps.push(valueStr)
				})
				out = `${out}${ps.join(",")}\n`
			})
			out = `${out}\n`
		}

		return out
	}

	fsFolderFullPath(id: Id): Path {
		let path = ""
		let folder = null
		while (true) {
			if (folder != null) {
				id = folder.parent
			}
			if (id === 0) {
				break
			}
			folder = this.data.fs.folders.find((x) => x.id === id)
			path = `${folder.name}/${path}`
		}
		return path
	}

	fsFileFullPath(id: Id): Path {
		const file = this.data.fs.files.find((x) => x.id === id)
		const folderPath = this.fsFolderFullPath(file.folder)
		return `${folderPath}${file.name}`
	}

	fsFolderNextId(): Id {
		return this.data.fs.folders.length + 1
	}

	fsFileNextId(): Id {
		return this.data.fs.files.length
	}

	azureFileNextId(): Id {
		return this.data.azure.files.length
	}

	fsFileFind(path: Path): FsFile | undefined {
		path = withoutLeadingSlash(path)
		const [filename, ...dirsRev] = path.split("/").reverse()
		let folder = {
			id: 0
		}
		for (const p of dirsRev.reverse()) {
			// console.log({folder})
			folder = this.data.fs.folders.find((x) => (x.name === p || withZip(x.name) === p) && x.parent === folder.id)
			if (!folder) break
		}

		if (!folder) return null

		return this.data.fs.files.find((x) => x.name === filename && x.folder === folder.id)
	}

	fsFileFindOrCreate(path: Path): FsFile {
		return this.fsFileFind(path) || this.fsFileAdd(path, null, null)
	}

	fsFolderAdd(path: Path): { folder: FsFolder, filename: Filename } {
		path = withoutLeadingSlash(path)

		let parent = {
			id: 0,
			name: "",
			parent: 0
		}

		const [filename, ...dirsRev] = path.split("/").reverse()
		dirsRev.reverse().forEach((p: any) => {
			const existingFolder = this.data.fs.folders.find((x) => x.name === p && x.parent === parent.id)
			if (existingFolder) {
				parent = existingFolder
			} else {
				const id = this.fsFolderNextId()
				const folder = {
					id,
					name: p,
					parent: parent.id
				}
				this.data.fs.folders.push(folder)
				parent = folder
			}
		})

		return {
			folder: parent,
			filename
		}
	}

	fsFileAdd(path: Path, kb: Size, date: Date6): FsFile {
		path = withoutLeadingSlash(path)
		const addFolderRes = this.fsFolderAdd(path)
		const filename = addFolderRes.filename
		const parent = addFolderRes.folder
		const existingFile = this.data.fs.files.find((x) => (x.name === filename || withZip(x.name) === filename) && x.folder === parent.id)
		if (existingFile) return existingFile
		const id = this.fsFileNextId()
		const file = {
			id,
			name: filename,
			folder: parent.id,
			kb,
			date
		}
		this.data.fs.files.push(file)
		return file
	}

	telegramUploadFind(path: Path): TelegramUpload | undefined {
		const file = this.fsFileFind(path)
		if (!file) return null
		const id = file.id
		return this.data.telegram.uploads.find((x) => x.id === id)
	}

	telegramUploadAdd(path: Path, fileId: Id, thumbId: Id): TelegramUpload {
		const file = this.fsFileFindOrCreate(path)
		const id = file.id
		const upload = {
			id,
			fileId,
			thumbId
		}

		const idx = this.data.telegram.uploads.findIndex((x) => x.id === id)
		if (idx >= 0) {
			this.data.telegram.uploads[idx] = upload
		} else {
			this.data.telegram.uploads.push(upload)
		}

		return upload
	}

	azureFileAdd(path: Path, filePaths: Array<Path>): AzureFile {
		const {
			folder,
			filename
		} = this.fsFolderAdd(path)

		const existingFile = this.data.azure.files.find((x) => x.name === filename && x.folder === folder.id)
		if (existingFile) return

		const fileIds = []
		for (const filePath of filePaths) {
			const file = this.fsFileFindOrCreate(filePath)
			fileIds.push(file.id)
		}

		const id = this.azureFileNextId()
		const file = {
			id,
			name: filename,
			folder: folder.id,
			files: fileIds
		}

		this.data.azure.files.push(file)

		return file
	}

	azurePathsNotUploaded(): Path[] {
		const uploadedSet = new Set()
		for (const file of this.data.azure.files) {
			for (const id of file.files) {
				uploadedSet.add(id)
			}
		}
		const all = this.data.fs.files.map((x) => x.id)
		const diff = all.filter((x) => !uploadedSet.has(x))
		return diff.map((id) => this.fsFileFullPath(id))
	}
}
