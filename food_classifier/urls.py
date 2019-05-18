"""food_classifier URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.9/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url, include
from django.contrib import admin
from classifier.views import *

from django.contrib.staticfiles.urls import static
from django.contrib.staticfiles.urls import staticfiles_urlpatterns

from rest_framework import routers

router = routers.DefaultRouter()
router.register(r'images', ImageViewSet)

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^img_upload/', upload_image),
    url(r'^process/', process),
    url(r'^$', upload_image),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    url(r'^', include(router.urls)),
    url(r'^post_images/$', ImagesList.as_view()),
    url(r'^get_ingredients/$', get_ingredients),
    url(r'^get_recipe/$', get_recipe),
    # url(r'^images/$', ImageViewSet),
]

urlpatterns += staticfiles_urlpatterns()
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

