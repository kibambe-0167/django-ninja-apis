# Generated by Django 4.0.6 on 2022-07-21 16:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tidalendpoints', '0002_devicemanufacturinginfo'),
    ]

    operations = [
        migrations.AlterField(
            model_name='devicemanufacturinginfo',
            name='device_version',
            field=models.DecimalField(decimal_places=2, max_digits=20),
        ),
    ]
