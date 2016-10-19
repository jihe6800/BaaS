from __future__ import absolute_import
from celery import Celery

app = Celery('test_celery',
             broker='amqp://majae:majae123@localhost/majae_vhost',
             backend='rpc://',
             include=['test_celery.tasks'])
