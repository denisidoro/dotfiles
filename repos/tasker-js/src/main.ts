import { Db } from "./db"

const txt = `TODO`

const db = new Db(txt)

const files = db.data.fs.files;
files.forEach(file => {
   const id = file.id
   const path = db.fsFileFullPath(id)
   console.log(`${path};${id};${file.kb};${file.date}`)
})
