from django.urls import path, reverse
from wagtail.admin.menu import MenuItem, SubmenuMenuItem, Menu
from wagtail import hooks

from apps.monitor.views import index, page_visit_data, top_pages

@hooks.register("register_admin_urls")
def register_monitor_urls():
    return [
        path("monitor/", index, name="monitor"),
        path("monitor-page-visit-data/", page_visit_data, name="page-visit-data"),
        path("monitor-top-pages/", top_pages, name="top-pages"),
    ]

@hooks.register("register_admin_menu_item")
def register_monitor_menu_item():
    menu = Menu(items=[
        MenuItem("Monitor", reverse("monitor")),
        MenuItem("Top Pages", reverse("top-pages")),
    ])
    return SubmenuMenuItem("Monitor", menu)
