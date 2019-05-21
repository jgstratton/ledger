/**
 * Use express to serve production build react files
 */
const express = require('express');
const proxy = require('http-proxy-middleware');
const app = express();
const https = require('https');
const fs = require('fs');
const proxyUrl = 'http://lucee:8080/src/index.cfm';
const sslEnabled = process.env.ENABLE_SSL || false;
const port = process.env.REACT_PORT;
const certFile = process.env.CERT_BASE_PATH + '/' + process.env.CERT_FILE;
const certKey = process.env.CERT_BASE_PATH + '/' + process.env.CERT_KEY_FILE;
const path = require('path');

app.use(proxy('/api', { target: proxyUrl }));
app.use(express.static('build'));

app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, 'build', 'index.html'));
});

if (sslEnabled) {
    const options = {
        key: fs.readFileSync(certKey),
        cert: fs.readFileSync(certFile)
    };
    https
        .createServer(options, app)
        .listen(port)
        .on('error', console.log);
} else {
    http.createServer(app)
        .listen(port)
        .on('error', console.log);
}
