const express = require('express');
const app = express();
const port = 3000;

// FIXED: Changed '.' to ',' below
app.get('/', (req, res) => {
    res.send('Hello, DevOps World!');
});

app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
});