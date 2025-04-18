
import * as http from 'http';

const hostname = '0.0.0.0';
const port = 3001;

const server = http.createServer((req:any, res:any) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello, World!');
});

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
    console.log('Happy developing ✨')

});

