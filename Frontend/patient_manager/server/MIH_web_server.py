from http.server import HTTPServer, BaseHTTPRequestHandler

port = 83
class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        # if self.path == '/':
        self.path = '/index.html'
        try:
            file_to_open = open(self.path[1:]).read()
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(bytes(file_to_open, 'utf-8'))
        except:
            self.send_response(404)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b'404 - Not Found')
print(f"Web Server starting on port {port}")
httpd = HTTPServer(('', port), SimpleHTTPRequestHandler)
print(f"Web Server started on port {port}")
httpd.serve_forever()