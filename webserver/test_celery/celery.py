from __future__ import absolute_import
from celery import Celery

app = Celery('test_celery',
             broker='amqp://group2:group2_123@130.238.29.177/group2_vhost',
             backend='rpc://',
             include=['test_celery.tasks'])
