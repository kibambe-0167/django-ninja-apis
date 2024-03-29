# Generated by Django 4.1.1 on 2022-09-16 03:30

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ("tidalendpoints", "0004_delete_customerregister_and_more"),
    ]

    operations = [
        migrations.CreateModel(
            name="CustomerRegister",
            fields=[
                (
                    "customer_id",
                    models.DecimalField(
                        decimal_places=0,
                        max_digits=10,
                        primary_key=True,
                        serialize=False,
                    ),
                ),
                ("customer_name", models.CharField(max_length=100)),
                ("email", models.CharField(max_length=50)),
                ("phone", models.CharField(max_length=40)),
                ("billing_address", models.CharField(max_length=200)),
                ("contact_person", models.CharField(max_length=50)),
                (
                    "customer_status",
                    models.DecimalField(decimal_places=0, max_digits=1),
                ),
            ],
        ),
        migrations.CreateModel(
            name="DeviceManufacturingInfo",
            fields=[
                ("device_manufacture_date", models.DateTimeField(auto_created=True)),
                ("device_id", models.IntegerField(primary_key=True, serialize=False)),
                ("device_status", models.IntegerField()),
                (
                    "device_version",
                    models.DecimalField(decimal_places=2, max_digits=20),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UserAdminData",
            fields=[
                (
                    "user_id",
                    models.CharField(max_length=50, primary_key=True, serialize=False),
                ),
                ("customer_id", models.DecimalField(decimal_places=0, max_digits=10)),
                ("user_password", models.CharField(max_length=100)),
                ("date_created", models.DateTimeField(auto_now_add=True)),
                ("user_status", models.DecimalField(decimal_places=0, max_digits=6)),
                ("roles", models.DecimalField(decimal_places=0, max_digits=1)),
                ("last_seen", models.DateTimeField(auto_now_add=True)),
                ("user_IP", models.CharField(max_length=15)),
            ],
        ),
    ]
