from django.shortcuts import render, HttpResponse, HttpResponseRedirect

from classifier.models import ImageModel
from classifier.forms import ImageUploadForm

# for scrapping
from bs4 import BeautifulSoup
import urllib.request as urllib2

# for process
from PIL import Image
from numpy import *
import os
import numpy as np
from keras.models import load_model
import tensorflow as tf
import numpy as np
from keras.utils import np_utils

from classifier.serializers import ImageSerializer
from rest_framework import viewsets, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view

from django.conf import settings

from collections import OrderedDict

base_dir = settings.BASE_DIREC

model = load_model(settings.MEDIA_ROOT + '/models/model_g_3x.h5') # rgb model_rgb_v0.01.h5
																  # 10 classes model model_g_3x
graph = tf.get_default_graph()

settings.UPLOADED = False

# for GET
class ImageViewSet(viewsets.ModelViewSet):
	queryset = ImageModel.objects.order_by('-image_uploaded')
	serializer_class = ImageSerializer

# for POST
class ImagesList(APIView):
    def post(self, request, format=None):
        serializer = ImageSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            q = ImageModel.objects.order_by('-image_uploaded')[0].image
            print(q)
            prediction = predict()
            return Response(prediction, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def get_ingredients(request, format=None):

	data = request.data
	food = data['food']
	response = getIngredients(food)

	return Response({ 'ingredients': response, })

@api_view(['POST'])
def get_recipe(request, format=None):

	data = request.data
	food = data['food']
	response = getRecipe(food)

	return Response({ 'recipe': response, })

def upload_image(request):
	if request.method == 'POST':
		form = ImageUploadForm(request.POST, request.FILES)
		if form.is_valid():
			if form.save():
				settings.UPLOADED = True
				msg = 'Image Uploaded !'
				img = ImageModel.objects.order_by('-image_uploaded')[0]
			return render(request, 'index.html', {'form': form, 'msg': msg, 'img': img})
	else:
		form = ImageUploadForm()
	return render(request, 'index.html', {'form': form})
	
def predict():
	img_rows, img_cols = 32, 32
	img_path = settings.PROJECT_ROOT + ImageModel.objects.order_by('-image_uploaded')[0].image.url
	img = Image.open(img_path).resize((img_rows, img_cols)).convert('L')
	img_matrix = array([ array(img).flatten() ], 'f')
	image = img_matrix.reshape(1, 32, 32, 1)
	image = image.astype('float32')
	image /= 255

	with graph.as_default():   
		label = model.predict(image)
		print(label)
		print(label[0])
		
		foods = ['biryani', 'dhokla', 'dosa', 'gulab_jamun', 'idli', 'jalebi', 'kachori', 'momos', 'poha', 'samosa']
		result = {}
		
		for f,j in zip(foods,label[0]):
			result[f] = j

		f_result = {}
		s_result = OrderedDict(sorted(result.items(), key=lambda x: x[1], reverse=True))
		for x,y in zip(s_result.keys(), s_result.values()):
			f_result[x]=y

	return f_result # prediction

def process(request):

	# # check if file is uploaded for prediction
	if settings.UPLOADED == False:
		return HttpResponseRedirect('/img_upload/')
	
	# # For heroku only
	# path1 = settings.MEDIA_ROOT + '/images/originals/'
	# path2 = settings.MEDIA_ROOT + '/images/results/'
	# if not os.path.exists(path2):
	# 	os.makedirs(path2)

	prediction = predict()
	img = ImageModel.objects.order_by('-image_uploaded')[0].image.url
	settings.UPLOADED = False

	return render(request, 'result.html', {'prediction': prediction, 'img': img })

def getIngredients(query):
	# query
	query = query.replace('_',' ').title().replace(' ','-')

	# url
	url = 'http://www.sanjeevkapoor.com/Recipe/' + query + '.html'

	# url to html
	user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
	headers={'User-Agent':user_agent,} 

	request=urllib2.Request(url,None,headers) #The assembled request
	response = urllib2.urlopen(request)
	html = response.read()

	ingredients = []
	
	# scrap recipie
	soup = BeautifulSoup(html,"lxml")
	for span in soup.find_all("ul", class_='list-unstyled'):
		for child in span:
			ingredients.append(child.text)

	return ingredients

def getRecipe(query):
	# query
	query = query.replace('_',' ').title().replace(' ','-')

	# url
	url = 'http://www.sanjeevkapoor.com/Recipe/' + query + '.html'

	# url to html
	user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
	headers={'User-Agent':user_agent,} 

	request=urllib2.Request(url,None,headers) #The assembled request
	response = urllib2.urlopen(request)
	html = response.read()

	procedure = []

	# scrap procedure
	soup = BeautifulSoup(html,"lxml")
	for div in soup.find_all("div", class_='stepdetail'):
		h4 = div.findChildren('h4')
		for child in h4:
			procedure.append(child.text)

	return procedure











