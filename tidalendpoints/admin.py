from django.contrib import admin
from tidalendpoints.models import CustomerRegister, UserAdminData

# Register your models here.
admin.site.register(CustomerRegister)
admin.site.register(UserAdminData)
