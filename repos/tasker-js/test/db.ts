import assert = require('assert');
import { Db } from '../src/db'

const txt = `
[fs.folders]
1,Pictures,0
2,DCIM,1
3,Games,0

[fs.files]
0,img00.jpg,2
1,gta.sav,3

[telegram.uploads]
0,123,456
1,987,765

[azure.files]
0,witcher.sav,3,0;1
`

const out = `
[fs.folders]
1,Pictures,0
2,DCIM,1
3,Games,0
4,Books,0
5,Fiction,4
6,German,4
7,Documents,0
8,ID,7

[fs.files]
0,img00.jpg,2,,
1,gta.sav,3,,
2,img01.jpg,2,323,150630
3,LotR2.pdf,5,1123,181203
4,img01b.jpg,2,,
5,img03.jpg,2,,
6,nein.pdf,6,,
7,rg.jpg,8,,
8,titre.jpg,8,,

[telegram.uploads]
0,123
1,987
2,666
4,666
7,666
8,666

[azure.files]
0,witcher.sav,3,0;1
1,blob.rar,4,2;5;3;6`

describe('Db', () => {
   it('idempotency', () => {
      const db = new Db(txt)
      const db2 = new Db(db.serialize())
      const db3 = new Db(db2.serialize())
      assert.deepStrictEqual(db3.serialize().trim(), db.serialize().trim())
   });

   it('integration test', () => {
      const db = new Db(txt)
      db.fsFileAdd("Pictures/DCIM/img01.jpg", 323, 150630)
      db.fsFileAdd("Books/Fiction/LotR2.pdf", 1123, 181203)
      db.fsFileAdd("Books/Fiction/LotR2.pdf", 1123, 181203)
      db.telegramUploadAdd("Pictures/DCIM/img01.jpg.7z", 666, 777)
      db.telegramUploadAdd("/Pictures/DCIM/img01.jpg", 666, 777)
      db.telegramUploadAdd("/Pictures/DCIM/img01b.jpg", 666, 777)
      db.azureFileAdd("/Books/blob.rar", ["Pictures/DCIM/img01.jpg.7z", "Pictures/DCIM/img03.jpg", "/Books/Fiction/LotR2.pdf", "Books/German/nein.pdf"])
      db.telegramUploadAdd("/Documents/ID/rg.jpg", 666, 777)
      db.telegramUploadAdd("/Documents/ID/titre.jpg", 666, 777)

      assert.deepStrictEqual(db.azurePathsNotUploaded(), [
         'Pictures/DCIM/img01b.jpg',
         'Documents/ID/rg.jpg',
         'Documents/ID/titre.jpg'
      ])

      assert.deepStrictEqual(db.serialize().trim(), out.trim())
   });
});