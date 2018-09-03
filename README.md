# ms2yandexDelivery

Yandex Delivery for MODX minishop2

Run PHP: 
```php
if ($miniShop2 = $modx->getService('miniShop2')) {
    $miniShop2->addService('delivery', 'msYandexDelivery',
        '{core_path}components/msprofile/model/msprofile/msyandexdelivery.class'
    );
}
```
