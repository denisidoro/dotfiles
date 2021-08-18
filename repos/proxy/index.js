const express = require('express')
const port = process.env.PORT || 3000

const app = express()
app.use(express.json())

const handler = (req, res) => {
    const x = { req: { headers: req.headers, body: req.body, path: req.path, url: req.url } }
    console.log(x)
    res.json(x)
}

app.get('/*', handler)
app.post('/*', handler)

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})