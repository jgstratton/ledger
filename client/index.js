/**
 * Use express to serve production build react files
 */
const express = require('express');
const proxy = require('http-proxy-middleware');
const app = express();

const proxyUrl = 'http://localhost:' + process.env.LUCEE_PORT + '/src/index.cfm/';

app.use(proxy('/api', { target: proxyUrl }));
app.use(express.static('build'));

const path = require('path');
app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, 'build', 'index.html'));
});

app.listen(process.env.REACT_PORT).on('error', console.log);
