from django.views.generic import DetailView
from django.shortcuts import render, get_object_or_404
from .models import Post  # Assuming this is your model name

class AktivGromadiDetailsView(DetailView):
    model = Post
    template_name = 'portfolio-details.html'
    context_object_name = 'post'

def aktiv_gromadi_details_content(request, pk):
    post = get_object_or_404(Post, pk=pk)
    return render(request, 'portfolio-details.html', {'post': post})
