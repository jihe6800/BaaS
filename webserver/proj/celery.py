from __future__ import absolute_import

from celery import Celery

app = Celery('proj', backend='rpc://', broker='amqp://guest@localhost//', include=['proj.tasks'])

if __name__ == '__main__':
    app.start()
