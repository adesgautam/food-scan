from rest_framework import serializers
from classifier.models import ImageModel


class ImageSerializer(serializers.ModelSerializer):

    class Meta:
        model = ImageModel
        fields = ('image', 'image_uploaded',)