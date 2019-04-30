/**
 * Use express to serve production build react files
 */
const express = require('express');
const app = express();

app.use(express.static('build'));

const path = require('path');
app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, 'build', 'index.html'));
});

const PORT = process.env.REACT_PORT || 3000;
app.listen(PORT).on('error', console.log);
