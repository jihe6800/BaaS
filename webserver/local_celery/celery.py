from __future__ import absolute_import
from celery import Celery

app = Celery('test_celery',
             broker='amqp://guest@localhost//',
             backend='rpc://',
             include=['local_celery.tasks'])


if __name__ == '__main__':
    app.start()

