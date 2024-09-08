from django import template
from wagtail.images.models import Image

register = template.Library()

@register.filter
def multiply(value, arg):
    return value * arg

@register.filter
def first_image(content):
    for block in content:
        if block.block_type == 'image':
            return block.value
    return None

@register.simple_tag
def slice_list(value, start, end):
    return value[start:end]