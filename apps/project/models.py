from django.http import JsonResponse
from django.utils.timezone import now
from django.core.paginator import Paginator
from wagtail.models import Page
from django.views.generic import View  # Import View
from apps.post.models import Post
from wagtail.fields import RichTextField
from wagtail.admin.panels import FieldPanel
from wagtail.contrib.routable_page.models import RoutablePageMixin, route

RICH_TEXT_FEATURES = [
    "bold",
    "italic",
    "code",
    "ol",
    "ul",
    "link",
    "document-link",
]

class ProjectIndex(RoutablePageMixin, Page, View):
    parent_page_types = ["home.HomePage"]
    subpage_types = ["post.Post"]
    max_count = 1

    description = RichTextField(features=RICH_TEXT_FEATURES, null=True, blank=True)

    content_panels = Page.content_panels + [
        FieldPanel("description"),
    ]

    @route(r"^$")
    def current_events(self, request):
        post = self.get_children().live()
        paginator = Paginator(post, 1)

        page_number = request.GET.get("p")
        if page_number:
            result = paginator.get_page(page_number)
        else:
            result = paginator.get_page(1)

        # Get the latest post
        latest_post = Post.objects.live().order_by('-id').first()

        return self.render(
            request,
            context_overrides={
                "result": result,
                "last_post": latest_post,
            },
        )

    @route(r'^projects/$', name='projects') # Add 'name' to the route
    def projects(self, request):
        projects = Post.objects.live().filter(content__date__gte=now())
        projects_data = [
            {
                'title': project.title,
                'date': block.value.strftime('%Y-%m-%d'),
                'description': str(project.content),  # Convert StreamField to string
                'url': project.url, # Add the event URL
            }
            for project in projects
            for block in project.content if block.block_type == 'date'
        ]
        return JsonResponse(projects_data, safe=False)
