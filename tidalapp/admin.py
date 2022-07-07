from django.contrib import admin
# get models
from tidalapp.models import CustomerRegister, UserAdminData

# Register your models here.
admin.site.register(CustomerRegister)
admin.site.register(UserAdminData)
