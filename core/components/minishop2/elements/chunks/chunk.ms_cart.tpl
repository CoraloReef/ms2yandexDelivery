<div id="msCart">
    {if !count($products)}
        {'ms2_cart_is_empty' | lexicon}
    {else}
        <div class="table-responsive">
            <table class="table table-striped">
                <tr class="header">
                    <th class="image">&nbsp;</th>
                    <th class="title">{'ms2_cart_title' | lexicon}</th>
                    <th class="count">{'ms2_cart_count' | lexicon}</th>
                    <th class="weight">{'ms2_cart_weight' | lexicon}</th>
                    <th class="price">{'ms2_cart_price' | lexicon}</th>
                    <th class="remove">{'ms2_cart_remove' | lexicon}</th>
                </tr>

                {foreach $products as $product}
                    <tr id="{$product.key}">
                        <td class="image">
                            {if $product.thumb?}
                                <img src="{$product.thumb}" alt="{$product.pagetitle}" title="{$product.pagetitle}"/>
                            {else}
                                <img src="{'assets_url' | option}components/minishop2/img/web/ms2_small.png"
                                     srcset="{'assets_url' | option}components/minishop2/img/web/ms2_small@2x.png 2x"
                                     alt="{$product.pagetitle}" title="{$product.pagetitle}"/>
                            {/if}
                        </td>
                        <td class="title">
                            {if $product.id?}
                                <a href="{$product.id | url}">{$product.pagetitle}</a>
                            {else}
                                {$product.name}
                            {/if}
                            {if $product.options?}
                                <div class="small">
                                    {$product.options | join : '; '}
                                </div>
                            {/if}
                        </td>
                        <td class="count">
                            <form method="post" class="ms2_form form-inline" role="form">
                                <input type="hidden" name="key" value="{$product.key}"/>
                                <div class="form-group">
                                    <input type="number" name="count" value="{$product.count}"
                                           class="input-sm form-control"/>
                                    <span class="hidden-xs">{'ms2_frontend_count_unit' | lexicon}</span>
                                    <button class="btn btn-default" type="submit" name="ms2_action" value="cart/change">
                                        <i class="glyphicon glyphicon-refresh"></i>
                                    </button>
                                </div>
                            </form>
                        </td>
                        <td class="weight">
                            <span>{$product.weight}</span> {'ms2_frontend_weight_unit' | lexicon}
                        </td>
                        <td class="price">
                            <span>{$product.price}</span> {'ms2_frontend_currency' | lexicon}
                            {if $product.old_price?}
                                <span class="old_price">{$product.old_price}</span> {'ms2_frontend_currency' | lexicon}
                            {/if}
                        </td>
                        <td class="remove">
                            <form method="post" class="ms2_form">
                                <input type="hidden" name="key" value="{$product.key}">
                                <button class="btn btn-default" type="submit" name="ms2_action" value="cart/remove">
                                    <i class="glyphicon glyphicon-remove"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                {/foreach}

                <tr class="footer">
                    <th class="total" colspan="2">{'ms2_cart_total' | lexicon}:</th>
                    <th class="total_count">
                        <span class="ms2_total_count">{$total.count}</span>
                        {'ms2_frontend_count_unit' | lexicon}
                    </th>
                    <th class="total_weight">
                        <span class="ms2_total_weight">{$total.weight}</span>
                        {'ms2_frontend_weight_unit' | lexicon}
                    </th>
                    <th class="total_cost">
                        <span class="ms2_total_cost">{$total.cost}</span>
                        {'ms2_frontend_currency' | lexicon}
                    </th>
                    <th>&nbsp;</th>
                </tr>
            </table>
        </div>
        <form method="post">
            <button class="btn btn-default" type="submit" name="ms2_action" value="cart/clean">
                <i class="glyphicon glyphicon-remove"></i> {'ms2_cart_clean' | lexicon}
            </button>
        </form>
    {/if}
</div>

<script src="https://delivery.yandex.ru/widget/loader?resource_id=*****&sid=*****&key=*****"></script>
<!-- Создаем условный объект с данными о содержимом корзины (для примера) -->
<script type="text/javascript">
    window.cart = {
        quantity: {$total.count}, // общее количество товаров
        weight: {$total.weight}, // общий вес товаров
        cost: {$total.cost} // общая стоимость товаров
    }
</script>

<!-- Инициализация виджета -->
<script type="text/javascript">
    ydwidget.ready(function(){
        ydwidget.initCartWidget({
            //получить указанный пользователем город
            'getCity': function () {
                var city = yd$('#city').val();
                if (city) {
                    return { value: city };
                } else {
                    return false;
                }
            },
            //id элемента-контейнера
            'el': 'ydwidget',
            //общее количество товаров в корзине
            'totalItemsQuantity': function () { return cart.quantity },
            //общий вес товаров в корзине
            'weight': function () { return cart.weight },
            //общая стоимость товаров в корзине
            'cost': function () { return cart.cost },
            //габариты и количество по каждому товару в корзине
            'itemsDimensions': function () { return [
                {foreach $products as $product}
                [{$product.width[0]},{$product.length[0]},{$product.height[0]},{$product.count}],
                {/foreach}
            ] },
            //объявленная ценность заказа. Влияет на расчет стоимости в предлагаемых вариантах доставки, для записи поля в заказ данное поле так же нужно передать в объекте order (поле order_assessed_value)
            'assessed_value': cart.cost,
            //Способы доставки. Влияют на предлагаемые в виджете варианты способов доставки.
            onlyDeliveryTypes: function(){ return ['todoor','pickup','post']; },
            //обработка автоматически определенного города
            'setCity': function (city, region) { yd$('#city').val(region ? city + ', ' + region : city) },
            //обработка смены варианта доставки
            'onDeliveryChange': function (delivery) {
                //если выбран вариант доставки, выводим его описание и закрываем виджет, иначе произошел сброс варианта,
                //очищаем описание
                if (delivery) {
                    // Вывод стоимости доставки и общей суммы
                    yd$('#delivery_price').text('Доставка: ' + delivery.costWithRules + ' руб.');
                    var costWithDelivery = delivery.costWithRules + cart.cost;
                    yd$('#delivery_total').text('Итого: ' + costWithDelivery + ' руб.');

                    yd$('#payments').show();

                    document.getElementById('delCostValue').value = delivery.costWithRules;

                    yd$('#delivery_description').text(ydwidget.cartWidget.view.helper.getDeliveryDescription(delivery));

                    if (ydwidget.cartWidget.selectedDelivery.type == "POST") {
                        yd$('#street').val(ydwidget.cartWidget.getAddress().street);
                        yd$('#building').val(ydwidget.cartWidget.getAddress().house);

                        yd$('.delivery-address').show();

                        getListPayment();
                        ydwidget.cartWidget.close();
                    } else {
                        getListPayment();
                        ydwidget.cartWidget.close();
                    }

                    if (ydwidget.cartWidget.selectedDelivery.type == "TODOOR") {
                        yd$('.delivery-address').show();
                    }

                    if (ydwidget.cartWidget.selectedDelivery.type == "PICKUP") {
                        yd$('.delivery-address').hide();
                    }

                } else {
                    yd$('#delivery_description').text('');
                    yd$('#payments').hide();
                }
            },
            //завершение загрузки корзинного виджета
            'onLoad': function () {
                //при клике на радиокнопку, если это не радиокнопка "Яндекс.Доставка", сбрасываем выбранную доставку
                //в виджете
                yd$(document).on('click', 'input:radio[name="delivery"]', function () {
                    if (yd$(this).not('#delivery_2')) {
                        ydwidget.cartWidget.setDeliveryVariant(null);
                    }
                });
            },
            //снятие выбора с варианта доставки "Яндекс.Доставка" (настроенного в CMS)
            'unSelectYdVariant': function () { yd$('#delivery_2').prop('checked', false) },
            //автодополнение
            'autocomplete': ['city', 'street', 'index'],
            'cityEl': '#city',
            'streetEl': '#street',
            'houseEl': '#building',
            'indexEl': '#index',
            //создавать заказ в cookie для его последующего создания в Яндекс.Доставке только если выбрана доставка Яндекса
            'createOrderFlag': function () { return yd$('#delivery_2').is(':checked') },
            //необходимые для создания заказа поля
            //возможно указывать и другие поля, см. объект Order в документации
            'order': {
                //имя, фамилия, телефон, улица, дом, индекс
                'recipient_first_name': function () { return yd$('#receiver').val() },
                'recipient_last_name': function () { return yd$('#surname').val() },
                'recipient_phone': function () { return yd$('#phone').val() },
                'deliverypoint_street': function () { return yd$('#street').val() },
                'deliverypoint_house': function () { return yd$('#building').val() },
                'deliverypoint_index': function () { return yd$('#index').val() },
                //объявленная ценность заказа
                'order_assessed_value': cart.cost,
                //товарные позиции в заказе
                //возможно указывать и другие поля, см. объект OrderItem в документации
                'order_items': function () {
                    var items = [];
                    {foreach $products as $product}
                    items.push({
                        'orderitem_name': '{$product.pagetitle}',
                        'orderitem_quantity': '{$product.count}',
                        'orderitem_cost': '{$product.price}'
                    });
                    {/foreach}
                    return items;
                }
            },
            //id элемента для вывода ошибок валидации. Вместо него можно указать параметр onValidationEnd, для кастомизации
            //вывода ошибок
            'errorsEl': 'yd_errors',
        })

    })
</script>
