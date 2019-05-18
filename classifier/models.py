from django.db import models
from django.conf import settings
import socket

class ImageModel(models.Model):
	# ip = [(s.connect(('8.8.8.8', 53)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][0][1]
	# image = models.ImageField(upload_to = 'images/originals/{0}'.format(ip), blank=False)
	image = models.ImageField(upload_to = 'images/originals/', blank=False)
	image_uploaded = models.DateTimeField(auto_now=True, auto_now_add=False)