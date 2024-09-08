from django.http import HttpRequest
from django.urls import reverse
from django.shortcuts import render, get_object_or_404
from apps.post.models import Post

def aktiv_gromadi_details(request):
    posts = Post.objects.all()  # Or any queryset you're using to get your posts
    return render(request, 'aktiv-gromadi.html', {'posts': posts})

def aktiv_gromadi_details_content(request, pk):
    post = get_object_or_404(Post, pk=pk)
    return render(request, 'portfolio-details.html', {'post': post})

def page_not_found(request: HttpRequest, exception):
    return render(request, "404.html", status=404)


def server_error(request: HttpRequest, **kwargs):
    print(kwargs)
    return render(request, "500.html", status=500)



def robots(request):
    d = request.build_absolute_uri(reverse("sitemap"))

    return render(
        request,
        "robots.txt",
        content_type="text/plain",
        context={"sitemap_url": d},
    )
