import web
import datetime

urls = (
    '/', 'index','/sinfo','serverinfo'
)

class index:
    def GET(self):
        return "Hello, world!"

class serverinfo:

    def POST(self):
        input=web.input()
	dt=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        f=open('server.list','a+')
        f.write(str(dt+'\t'+input.ip+'\t'+input.hn+'\t'+input.on+'\t'+input.st+'\n'))
        f.close()

    def GET(self):
	f=open('server.list','r')
	data=f.read()
	f.close()
        return data

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
