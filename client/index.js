/**
 * Use express to serve production build react files
 */
const express = require('express');
const proxy = require('http-proxy-middleware');
const app = express();

const PORT = process.env.REACT_PORT || 3000;
const API_PORT = process.env.REACT_APP_API_URL || 3000;

app.use(proxy('/api', { target: 'http://localhost:' + API_PORT }));
app.use(express.static('build'));

const path = require('path');
app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, 'build', 'index.html'));
});

app.listen(PORT).on('error', console.log);
