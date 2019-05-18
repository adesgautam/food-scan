from django import forms
from .models import ImageModel

class ImageUploadForm(forms.ModelForm):
    """Image upload form."""
    #image = forms.ImageField(label='Select an image')

    class Meta:
    	model = ImageModel
    	fields = ('image',)